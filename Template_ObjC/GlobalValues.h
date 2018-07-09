//  Created by Dave Fung.
//  Copyright (c) 2015 Hong Kong Baptist University. All rights reserved.

#import <Foundation/Foundation.h>

@interface GlobalValues : NSObject

+(void)setShowPasswordPageForFirstTimeUsing:(BOOL)isNeed;
+(BOOL)getShowPasswordPageForFirstTimeUsing;
+(void)setAppPassword:(NSString*)password;
+(NSString*)getAppPassword;
+(void)setIsSearching;
+(BOOL)getIsSearching;
+(void)setIsNotSearching;

@end
