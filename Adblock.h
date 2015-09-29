//
//  Adblock.h
//  CachedWebView
//
//  Created by Garvan Keeley on 2015-09-11.
//
//

#import <Foundation/Foundation.h>

@interface Adblock : NSObject

+ (instancetype)singleton;
- (BOOL)shouldBlock:(NSURLRequest*)request;
- (NSString*)getBlockedAsString;
- (BOOL)isAlreadyBlockedUrl:(NSURL*)url;
@end
