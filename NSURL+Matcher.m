#import "NSURL+Matcher.h"

@implementation NSURL (NSURL_Matcher)

-(BOOL)hasString:(NSString*) find
{
  return [self.absoluteString rangeOfString:find].location != NSNotFound;
}

@end
