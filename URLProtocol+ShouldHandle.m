#import "URLProtocol+ShouldHandle.h"
#import "NSURL+Matcher.h"
#import "Adblock.h"
 
@implementation RNCachingURLProtocol (ShouldHandle)

+(BOOL)shouldHandleRequest:(NSURLRequest*)request
{
  //NSLog(@"%@ ••• Accept: %@, Referrer: %@", request.URL, request.allHTTPHeaderFields[@"Accept"], request.allHTTPHeaderFields[@"Referer"]);
  // replace this style tpc.googlesyndication.com/simgad/15067328871183717387
  BOOL isImage = [request.URL hasString:@"tpc.googlesyndication.com/simgad"];


  // only handle http requests we haven't marked with our header.
  if ([[self supportedSchemes] containsObject:request.URL.scheme] &&
      ([request valueForHTTPHeaderField:RNCachingURLHeader] == nil))
  {
//    if (isImage) {
//      Adblock* ad = [Adblock singleton];
//      return [ad shouldBlock:request];
//    }
    return YES; //[request.URL hasSuffix:@"html"] ;
  }

  return NO;
}
@end
