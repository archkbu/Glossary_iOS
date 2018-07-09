#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>

@interface DeviceAPI : NSObject

+(int)getScreenWidth;
+(int)getScreenHeight;
+(BOOL)getIsIPad;
+(NSString*)getiOSDevice;
+(UIViewController*)getUIStoryboard:(NSString*)vcName;
+(int)getMinInArray:(NSArray*)arr;
+(int)getMaxInArray:(NSArray*)arr;
+(UIImage*)imageByScalingToSize:(CGSize)targetSize sourceImage:(UIImage*)sImg;
+(void)showAlert:(NSString*)alertTitle alertMsg:(NSString*)alertMsg alertCancelBtn:(NSString*)alertCancelBtn;
+(NSString*)getFileString:(NSString*)path isDocument:(BOOL)isDocument type:(NSString*)type;
+(NSObject*)getJSONFromFile:(NSString*)path isDocument:(BOOL)isDocument;
+(NSObject*)getJSONFromJSFile:(NSString*)path isDocument:(BOOL)isDocument;
+(NSObject*)getJSONFromNSURLRequest:(NSURLRequest*)request;
+(NSString*)dicarrToJsonString:(NSObject*)obj;
+(void)writeStringToFile:(NSString*)jString path:(NSString*)path;
+(void)dicarrToJsonFile:(NSObject*)obj path:(NSString*)path isDocument:(BOOL)isDocument;
+(BOOL)isFileExist:(NSString*)path isDocument:(BOOL)isDocument type:(NSString*)type;
+(BOOL)isFirstTimeUse;
+(void)setAppUsed;
+(NSString*)getNowDateTime;
+(NSString*)encodeUIImageToBase64String:(UIImage*)image;
+(UIImage*)decodeBase64ToUIImage:(NSString*)strEncodeData;
+(BOOL)connectedToNetwork;
+(void)interactiveWithInternet:(NSString*)link postString:(NSString*)postString resultIsJSON:(BOOL)resultIsJSON delegatedObject:(id)delegatedObject endSelector:(SEL)endSelector;
+(void)interactiveWithInternetByPassingDictionary:(NSString*)link postDictionary:(NSDictionary*)postDictionary resultIsJSON:(BOOL)resultIsJSON delegatedObject:(id)delegatedObject endSelector:(SEL)endSelector;

@end