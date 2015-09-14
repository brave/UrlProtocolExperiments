#import "URLProtocol+ShouldHandle.h"
#import "NSURL+Matcher.h"
#import "Adblock.h"
 
@implementation RNCachingURLProtocol (ShouldHandle)

+(BOOL)shouldHandleRequest:(NSURLRequest*)request
{
  NSURLComponents* urlComponents = [[NSURLComponents alloc] initWithURL:request.URL resolvingAgainstBaseURL:NO];
  urlComponents.query = nil; // Strip out query parameters.

  // replace this style tpc.googlesyndication.com/simgad/15067328871183717387


  BOOL isImage = [request.URL hasString:@"tpc.googlesyndication.com/simgad"];

  ////     [[self client] URLProtocol:self didFailWithError:[NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorTimedOut userInfo:nil]];
  ////      return;
  ////  }
  //  if ([self.request.URL.absoluteString rangeOfString:@"googles"].location != NSNotFound && ![self.request.URL.absoluteString hasSuffix:@"html"]) {
  //   // [[self client] URLProtocol:self didFailWithError:[NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorTimedOut userInfo:nil]];
  //
  //
  //    return;
  //  }

  // only handle http requests we haven't marked with our header.
  if ([[self supportedSchemes] containsObject:request.URL.scheme] &&
      ([request valueForHTTPHeaderField:RNCachingURLHeader] == nil) && isImage)
  {
    Adblock* ad = [Adblock singleton];
    return [ad shouldBlock:request];
  }

  return NO;
}
@end
