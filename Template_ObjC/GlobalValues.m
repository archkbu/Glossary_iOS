//  Created by Dave Fung.
//  Copyright (c) 2015 Hong Kong Baptist University. All rights reserved.

#import "GlobalValues.h"

@implementation GlobalValues

static BOOL showPasswordPageFFTU=NO;
static NSString *appPassword=@"root";
static BOOL isSearching=NO;

+(void)setShowPasswordPageForFirstTimeUsing:(BOOL)isNeed{
    showPasswordPageFFTU=isNeed;
}

+(BOOL)getShowPasswordPageForFirstTimeUsing{
    return showPasswordPageFFTU;
}

+(void)setAppPassword:(NSString*)password{
    appPassword=password;
}

+(NSString*)getAppPassword{
    return appPassword;
}

+(void)setIsSearching{
    isSearching=YES;
}
+(BOOL)getIsSearching{
    return isSearching;
}
+(void)setIsNotSearching{
    isSearching=NO;
}

@end
