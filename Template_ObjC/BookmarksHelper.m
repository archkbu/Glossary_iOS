#import "BookmarksHelper.h"

@implementation BookmarksHelper

static NSMutableArray *bmFiles;
static NSString *prefixOfJSONFile=@"bm_";
static NSString *defaultName=@"bookmarks";

+(NSObject*)getBookmarksFromDevice:(NSString*)name{ // Private
    NSString *jsonfileNewName=[NSString stringWithFormat:@"%@%@",prefixOfJSONFile,name];
    NSObject *ad=[DeviceAPI getJSONFromFile:jsonfileNewName isDocument:YES];
    if([ad isKindOfClass:[NSArray class]]){
        NSArray *jArr=(NSArray*)[DeviceAPI getJSONFromFile:jsonfileNewName isDocument:YES];
        NSMutableArray *jMArr=[[NSMutableArray alloc] init];
        for(int i=0; i<jArr.count; i++){
            [jMArr addObject:[jArr objectAtIndex:i]];
        }
        return jMArr;
    }else if([ad isKindOfClass:[NSDictionary class]]){
        NSDictionary *jDic=(NSDictionary*)[DeviceAPI getJSONFromFile:jsonfileNewName isDocument:YES];
        NSMutableDictionary *jMDic=[[NSMutableDictionary alloc] init];
        for(NSString *key in jDic){
            [jMDic setObject:[jDic objectForKey:key] forKey:key];
        }
        return jMDic;
    }
    return nil;
}

+(void)saveBookmarks:(NSString*)name{ // Private
    if(name==nil)name=defaultName;
    NSString *jsonfileNewName=[NSString stringWithFormat:@"%@%@",prefixOfJSONFile,name];
    [DeviceAPI dicarrToJsonFile:[BookmarksHelper getBookmarksRaw:name] path:jsonfileNewName isDocument:YES];
}

+(NSObject*)getBookmarksRaw:(NSString*)name{ // Private
    if(name==nil)name=defaultName;
    for(int i=0; i<bmFiles.count; i++){
        if([[[bmFiles objectAtIndex:i] objectForKey:@"name"] isEqualToString:name])
            return [[bmFiles objectAtIndex:i] objectForKey:@"object"];
    }
    return nil;
}

+(void)addBookmark:(NSString*)name object:(NSObject*)object type:(NSString*)type{ // Private
    if(name==nil)name=defaultName;
    NSMutableArray *mArr=[BookmarksHelper getBookmarks:name type:type];
    [mArr addObject:object];
    [BookmarksHelper saveBookmarks:name];
}

+(void)transferFromNontypeToType:(NSString*)name type:(NSString*)type{ // Private
    if(name==nil)name=defaultName;
    NSMutableArray *mArr=[BookmarksHelper getBookmarks:name type:type];
    NSMutableDictionary *mDic=[[NSMutableDictionary alloc] init];
    [mDic setObject:mArr forKey:type];
    NSObject *obj=[BookmarksHelper getBookmarksRaw:name];
    obj=mDic;
    [BookmarksHelper saveBookmarks:name];
}



+(void)useBookmarks:(NSString*)name byUsingTypes:(BOOL)byUsingTypes{
    if(name==nil)name=defaultName;
    if(bmFiles==nil)bmFiles=[[NSMutableArray alloc] init];
    NSString *jsonfileNewName=[NSString stringWithFormat:@"%@%@",prefixOfJSONFile,name];
    BOOL alreadyHas=[DeviceAPI isFileExist:jsonfileNewName isDocument:YES type:@"json"];
    NSObject *arrOrDic=nil;
    if(byUsingTypes){
        NSMutableDictionary *jsonDictionary=nil;
        if(!alreadyHas){
            NSString *usedtPath=[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@.json",jsonfileNewName]];
            [@"{}" writeToFile:usedtPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
            jsonDictionary=[[NSMutableDictionary alloc] init];
        }else{
            jsonDictionary=(NSMutableDictionary*)[BookmarksHelper getBookmarksFromDevice:name];
        }
        arrOrDic=jsonDictionary;
    }else{
        NSMutableArray *jsonArray=nil;
        if(!alreadyHas){
            NSString *usedtPath=[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@.json",jsonfileNewName]];
            [@"[]" writeToFile:usedtPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
            jsonArray=[[NSMutableArray alloc] init];
        }else{
            jsonArray=(NSMutableArray*)[BookmarksHelper getBookmarksFromDevice:name];
        }
        arrOrDic=jsonArray;
    }
    NSDictionary *dic=(NSMutableDictionary*)[[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:name,arrOrDic,nil] forKeys:[NSArray arrayWithObjects:@"name",@"object",nil]];
    [bmFiles addObject:dic];
}

+(NSMutableArray*)getBookmarks:(NSString*)name type:(NSString*)type{
    if(name==nil)name=defaultName;
    NSObject *obj=[BookmarksHelper getBookmarksRaw:name];
    if(obj==nil)return nil;
    if([obj isKindOfClass:[NSMutableArray class]])return (NSMutableArray*)obj;
    else if([obj isKindOfClass:[NSMutableDictionary class]]){
        if(type==nil || [type isEqualToString:@""])return nil;
        NSMutableDictionary *dic=(NSMutableDictionary*)obj;
        if([dic objectForKey:type]==nil)[dic setObject:[[NSMutableArray alloc] init] forKey:type];
        else{
            NSMutableArray *tmpArr=[[NSMutableArray alloc] init];
            for(int i=0; i<[[dic objectForKey:type] count]; i++){
                [tmpArr addObject:[[dic objectForKey:type] objectAtIndex:i]];
            }
            [dic setObject:tmpArr forKey:type];
        }
        return (NSMutableArray*)[dic objectForKey:type];
    }
    return nil;
}

+(NSString*)getBookmarksJSONString:(NSString*)name{
    return [DeviceAPI dicarrToJsonString:[BookmarksHelper getBookmarksRaw:name]];
}

+(void)addBookmarkWithInt:(NSString*)name intId:(int)intId type:(NSString*)type{
    [BookmarksHelper addBookmark:name object:[NSNumber numberWithInt:intId] type:type];
}

+(void)addBookmarkWithString:(NSString*)name stringId:(NSString*)stringId type:(NSString*)type{
    [BookmarksHelper addBookmark:name object:stringId type:type];
}

+(void)removeBookmarkAtIndex:(NSString*)name index:(int)index type:(NSString*)type{
    NSMutableArray *mArr=[BookmarksHelper getBookmarks:name type:type];
    [mArr removeObjectAtIndex:index];
    [BookmarksHelper saveBookmarks:name];
}

+(void)removeBookmarkWithInt:(NSString*)name intId:(int)intId type:(NSString*)type{
    NSMutableArray *mArr=[BookmarksHelper getBookmarks:name type:type];
    for(int i=0; i<mArr.count; i++){
        if([[mArr objectAtIndex:i] intValue]==intId)
            [mArr removeObjectAtIndex:i];
    }
    [BookmarksHelper saveBookmarks:name];
}

+(void)removeBookmarkWithString:(NSString*)name stringId:(NSString*)stringId type:(NSString*)type{
    NSMutableArray *mArr=[BookmarksHelper getBookmarks:name type:type];
    for(int i=0; i<mArr.count; i++){
        if([[mArr objectAtIndex:i] isEqualToString:stringId])
            [mArr removeObjectAtIndex:i];
    }
    [BookmarksHelper saveBookmarks:name];
}

+(void)removeAllBookmarksInType:(NSString*)name type:(NSString*)type{
    NSMutableArray *mArr=[BookmarksHelper getBookmarks:name type:type];
    [mArr removeAllObjects];
    [BookmarksHelper saveBookmarks:name];
}

+(BOOL)isAlreadyAddedToBookmarksWithInt:(NSString*)name intId:(int)intId type:(NSString*)type{
    NSMutableArray *mArr=[BookmarksHelper getBookmarks:name type:type];
    for(int i=0; i<mArr.count; i++){
        if([[mArr objectAtIndex:i] intValue]==intId)return YES;
    }
    return NO;
}

+(BOOL)isAlreadyAddedToBookmarksWithString:(NSString*)name stringId:(NSString*)stringId type:(NSString*)type{
    NSMutableArray *mArr=[BookmarksHelper getBookmarks:name type:type];
    for(int i=0; i<mArr.count; i++){
        if([[mArr objectAtIndex:i] isEqualToString:stringId])return YES;
    }
    return NO;
}

@end