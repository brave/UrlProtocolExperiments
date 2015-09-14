#import "RNCachingURLProtocol.h"

@interface RNCachingURLProtocol (InjectJS)

- (NSData*)injectIntoStreamForUrl:(NSURL*)url withData:(NSData*)data;


@end
