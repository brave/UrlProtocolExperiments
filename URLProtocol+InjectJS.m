#import "URLProtocol+InjectJS.h"
#import "Adblock.h"
#import "NSURL+Matcher.h"

@implementation RNCachingURLProtocol (InjectJS)

NSString* js = @""
      "<script type='application/javascript'>\n"
      "var replaced = %@;\n"
      "window.onload = function () {\n"
      "  var images = document.images;\n"
      "  for (var i = 0; i < images.length; i += 1) {\n"
      "    var replacedImg = replaced[images[i].src];\n"
      "    images[i].src = 'https://i.ytimg.com/vi/wMzRnOLdck0/0.jpg';\n"
      "  }\n"
      "};\n"
      "</script>\n";

NSString* html = @"<html>";

UIImage* imageWithColor(UIColor *color) {
  CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
  UIGraphicsBeginImageContext(rect.size);
  CGContextRef context = UIGraphicsGetCurrentContext();

  CGContextSetFillColorWithColor(context, [color CGColor]);
  CGContextFillRect(context, rect);

  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();

  return image;
}

-(void)responseImage
{
  UIImage* image = imageWithColor([UIColor purpleColor]);

  NSData* data = UIImageJPEGRepresentation(image, 0.4);
  NSURLResponse* response = [[NSURLResponse alloc] initWithURL:self.request.URL
                                                      MIMEType:@"image/jpeg"
                                         expectedContentLength:data.length
                                              textEncodingName:nil];
  [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed]; // we handle caching ourselves.
  [[self client] URLProtocol:self didLoadData:data];
  [[self client] URLProtocolDidFinishLoading:self];
}

BOOL isTypeTextOrHtml(NSString* mime) {
  return [mime rangeOfString:@"text"].location != NSNotFound ||
  [mime rangeOfString:@"html"].location != NSNotFound;
}

BOOL isTypeImage(NSString* mime) {
  return [mime rangeOfString:@"image"].location != NSNotFound;
}

- (NSData*)injectIntoConnection:(NSURLConnection*)connection
                         forUrl:(NSURL*)url
                       withData:(NSData*)data;
{return data;
  if (isTypeTextOrHtml(self.response.MIMEType)) {
    if (self.injectionResult == isUnset ||
        self.injectionResult == isText)
    { // !self.foundHtmlInStream && self.bytesRead < 500) {
      NSUInteger resultCode = isUnset;
      NSData* newData = [self injectIntoStreamForUrl:url withData:data result:&resultCode];
      self.injectionResult = resultCode;
      if (self.injectionResult == isTextAndJsInjected) {
        NSLog(@"injectIntoConnection %@", url);
      }
      return newData;
    }
  }
  else if (isTypeImage(self.response.MIMEType) &&
           [[Adblock singleton] isAlreadyBlockedUrl:url]) {
    [self responseImage];
    
    [connection cancel];
    connection = nil;
    return nil;
  }

  return data;
}

//
// need to find <html> early in the stream
// todo: handle token being split
// todo: handle top level vs subframes
//
- (NSData*)injectIntoStreamForUrl:(NSURL*)url withData:(NSData*)data result:(NSUInteger*)resultCode
{
//  if (self.bytesRead > 500) {
//    *resultCode = isIgnored;
//    return data;
//  }

  self.bytesRead += data.length;

  NSMutableString* str = [[NSMutableString alloc]
      initWithData:data
      encoding:NSUTF8StringEncoding];

  if (!str)  { // need to rename bool to use it for the case where the data is not ascii
    *resultCode = isBinary;
    return data;
  }

  NSRange r = [str rangeOfString:@".location.replace"];
  if (r.location != NSNotFound) {
    [str deleteCharactersInRange:r];
  }

   r = [str rangeOfString:@".removeChild"];
  if (r.location != NSNotFound) {
    [str deleteCharactersInRange:r];
  }

  NSUInteger location = [str rangeOfString:html options:NSCaseInsensitiveSearch].location;
  if (location != NSNotFound) {
    NSString* blocked = [[Adblock singleton] getBlockedAsString];
    //if (blocked.length < 3)
      //return data;
    
    NSString* insertedJs = [NSString stringWithFormat:js, blocked];
    [str insertString:insertedJs atIndex:location + html.length];

    data = [str dataUsingEncoding:NSUTF8StringEncoding];
    assert(data);
    *resultCode = isTextAndJsInjected;
    return data;
  }

data = [str dataUsingEncoding:NSUTF8StringEncoding];assert(data);

  *resultCode = isText;
  return data;
}

@end
