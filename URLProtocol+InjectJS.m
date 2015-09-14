#import "URLProtocol+InjectJS.h"

@implementation RNCachingURLProtocol (InjectJS)


//
// need to find <html> early in the stream
// todo: handle token being split
// todo: handle top level vs subframes
//
- (NSData*)injectIntoStreamForUrl:(NSURL*)url withData:(NSData*)data
{
  if (self.foundHtmlInStream)
    return data;

  if ([url.absoluteString hasSuffix:@"html"]) {
    NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (str)  {
      if ([str rangeOfString:@"<html>" options:NSCaseInsensitiveSearch].location != NSNotFound) {
        self.foundHtmlInStream = true;

        // perform injection
      }
    }
  }

  return data;
}

@end
