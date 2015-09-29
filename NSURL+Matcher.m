#import "NSURL+Matcher.h"

@implementation NSURL (NSURL_Matcher)

- (BOOL)hasString:(NSString*) find
{
  return [self.absoluteString rangeOfString:find].location != NSNotFound;
}

- (BOOL)hasSuffix:(NSString *)find
{
  NSURLComponents* urlComponents = [[NSURLComponents alloc] initWithURL:self resolvingAgainstBaseURL:NO];
  urlComponents.query = nil; // Strip out query parameters.
  return [urlComponents.path hasSuffix:find];
}
@end
