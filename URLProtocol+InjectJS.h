#import "RNCachingURLProtocol.h"

@interface RNCachingURLProtocol (InjectJS)

- (NSData*)injectIntoConnection:(NSURLConnection*)connection
                         forUrl:(NSURL*)url
                       withData:(NSData*)data;


@end
