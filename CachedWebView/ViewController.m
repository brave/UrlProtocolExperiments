//
//  ViewController.m
//  CachedWebView
//
//  Created by Robert Napier on 1/29/12.
//  Copyright (c) 2012 Rob Napier.
//
//  This code is licensed under the MIT License:
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
//  DEALINGS IN THE SOFTWARE.
//

#import "ViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface ViewController()<UIWebViewDelegate>
@property (atomic) int counter;
@property (nonatomic, strong) NSString* loaded;
@end

@implementation ViewController
@synthesize webView = webView_;

- (void)viewDidLoad
{
  [super viewDidLoad];
 // [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:]]];
  [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:
                                                               @"https://nytimes.com"
//                                                               @"https://garvankeeley.github.io/web/adrepl.html"
//@"http://safeframes.net/examples/IAB_RisingStars/sidekick_sample.html"
                                                               ]]];

  //[self.webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://publisherconsole.appspot.com/safeframe/creative-preview.html"]]];
  self.webView.delegate = self;
}
bool ok = YES;

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
//  if (self.counter == 2)
//    ok = NO;
//  if (!ok) return NO;
//  if ([request.URL.absoluteString rangeOfString:@"blank"].location == NSNotFound) {
//    //NSLog(@"%@ is main %d", [NSThread currentThread], [NSThread isMainThread]);
   //NSLog(@"^^^ shouldStartLoadWithRequest: %@ %@", request.URL.absoluteString, request.mainDocumentURL.absoluteString);
//    NSMutableURLRequest* mr = (NSMutableURLRequest*)request;
//      [mr setValue:@"funky" forHTTPHeaderField:@"monkey"];}
  return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
  self.counter++;
//  NSLog(@"^^^ start load %d %@", self.counter, webView.request.URL.absoluteString);
//
//  JSContext *ctx = [JSContext contextWithJSGlobalContextRef:[self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"]];
//
//  JSValue *three = [ctx evaluateScript:@"1+2"];
//  NSAssert([[three toNumber] isEqual:@(3)], @"It Is As It Was");
//    [ctx evaluateScript:@"console.log('this is a log message that goes nowhere :(')"];
//                                      ctx[@"console"][@"log"] = ^(JSValue *msg) {
//                                        NSLog(@"JavaScript %@ log message: %@", [JSContext currentContext], msg);
//                                      };
//                                      [ctx evaluateScript:@"console.log('this is a log message that goes to my Xcode debug console!!!! :)’)"];


}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
  //NSLog(@"did finish");
  self.counter--;
return; //++++++++++++++++++++++++++
//  NSLog(@"••• %d, Frame %@ ", self.counter, webView.request.URL);

 // js = [webView stringByEvaluatingJavaScriptFromString:@"document.images[0].src"];
  NSString* ss = [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.outerHTML"];
 // NSLog(@"%@", ss);
 // assert([ss rangeOfString:@"i.ytimg.com"].location != NSNotFound);
  if (self.counter < 1 && ![webView.request.URL.absoluteString isEqualToString:self.loaded]) {
    self.loaded = webView.request.URL.absoluteString;
    ss = [ss stringByReplacingOccurrencesOfString:@" the " withString:@" ZZZ "];
    //NSLog(@"%@",ss);
    //[webView loadHTMLString:ss baseURL:webView.request.URL];
   // NSLog(@"replacing");
    [self performSelector:@selector(installJS) withObject:nil afterDelay:1.0];
  } else {
  //  NSLog(@"not replacing %d", self.counter);
  }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{

}


- (void)installJS
{
  NSArray *frames = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.childFrames"];

  [frames enumerateObjectsUsingBlock:^(id frame, NSUInteger idx, BOOL *stop) {
    JSContext *context = [frame valueForKeyPath:@"javaScriptContext"];
    context[@"Window"][@"prototype"][@"alert"] = ^(NSString *message) {
      NSLog(@"%@", message);
    };
  }];
}



@end
