#import <Foundation/Foundation.h>
#import "DeviceAPI.h"

@interface BookmarksHelper : NSObject

+(void)useBookmarks:(NSString*)name byUsingTypes:(BOOL)byUsingTypes;
+(NSMutableArray*)getBookmarks:(NSString*)name type:(NSString*)type;
+(NSString*)getBookmarksJSONString:(NSString*)name;
+(void)addBookmarkWithInt:(NSString*)name intId:(int)intId type:(NSString*)type;
+(void)addBookmarkWithString:(NSString*)name stringId:(NSString*)stringId type:(NSString*)type;
+(void)removeBookmarkAtIndex:(NSString*)name index:(int)index type:(NSString*)type;
+(void)removeBookmarkWithInt:(NSString*)name intId:(int)intId type:(NSString*)type;
+(void)removeBookmarkWithString:(NSString*)name stringId:(NSString*)stringId type:(NSString*)type;
+(void)removeAllBookmarksInType:(NSString*)name type:(NSString*)type;
+(BOOL)isAlreadyAddedToBookmarksWithInt:(NSString*)name intId:(int)intId type:(NSString*)type;
+(BOOL)isAlreadyAddedToBookmarksWithString:(NSString*)name stringId:(NSString*)stringId type:(NSString*)type;

@end