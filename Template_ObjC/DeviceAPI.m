#import "DeviceAPI.h"

@implementation DeviceAPI

+(int)getScreenWidth{
    CGRect screenRect=[[UIScreen mainScreen] bounds];
    CGFloat screenWidth=screenRect.size.width;
    return (int)screenWidth;
}

+(int)getScreenHeight{
    CGRect screenRect=[[UIScreen mainScreen] bounds];
    CGFloat screenHeight=screenRect.size.height;
    return (int)screenHeight;
}

+(BOOL)getIsIPad{
    return ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPad);
}

+(NSString*)getiOSDevice{
    //NSLog(@"%d, %d",(int)[[UIScreen mainScreen] preferredMode].size.width,(int)[[UIScreen mainScreen] preferredMode].size.height);
    if([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPad)return @"iPad";
    if(CGSizeEqualToSize([[UIScreen mainScreen] preferredMode].size,CGSizeMake(640, 960)))return @"iPhone 4";
    if(CGSizeEqualToSize([[UIScreen mainScreen] preferredMode].size,CGSizeMake(640, 1136)))return @"iPhone 5";
    if(CGSizeEqualToSize([[UIScreen mainScreen] preferredMode].size,CGSizeMake(750, 1334)))return @"iPhone 6";
    if(CGSizeEqualToSize([[UIScreen mainScreen] preferredMode].size,CGSizeMake(1242, 2208)))return @"iPhone 6 Plus";
    return @"iPhone 4";
}

+(UIViewController*)getUIStoryboard:(NSString*)vcName{
    NSString *st=@"Main_iPad";
    if([[DeviceAPI getiOSDevice] isEqualToString:@"iPhone 4"])st=@"Main_iPhone3-5";
    else if([[DeviceAPI getiOSDevice] isEqualToString:@"iPhone 5"])st=@"Main_iPhone5";
    else if([[DeviceAPI getiOSDevice] isEqualToString:@"iPhone 6"])st=@"Main_iPhone6";
    else if([[DeviceAPI getiOSDevice] isEqualToString:@"iPhone 6 Plus"])st=@"Main_iPhone6P";
    return [[UIStoryboard storyboardWithName:st bundle:nil] instantiateViewControllerWithIdentifier:vcName];
}

+(int)getMinInArray:(NSArray*)arr{
    for(int i=0; i<arr.count; i++){
        NSNumber *thisNum=[arr objectAtIndex:i];
        int numAdded=0;
        for(int k=0; k<arr.count; k++){
            if([thisNum doubleValue]<=[[arr objectAtIndex:k] doubleValue])numAdded++;
        }
        if(numAdded==arr.count)return i;
    }
    return 0;
}

+(int)getMaxInArray:(NSArray*)arr{
    for(int i=0; i<arr.count; i++){
        NSNumber *thisNum=[arr objectAtIndex:i];
        int numAdded=0;
        for(int k=0; k<arr.count; k++){
            if([thisNum doubleValue]>=[[arr objectAtIndex:k] doubleValue])numAdded++;
        }
        if(numAdded==arr.count)return i;
    }
    return 0;
}

+(UIImage*)imageByScalingToSize:(CGSize)targetSize sourceImage:(UIImage*)sImg{
    UIImage *sourceImage = sImg;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (!CGSizeEqualToSize(imageSize, targetSize)) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if(widthFactor < heightFactor)
        scaleFactor = widthFactor;
        else
        scaleFactor = heightFactor;
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if (widthFactor < heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor > heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(targetSize);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    return newImage ;
}

+(void)showAlert:(NSString*)alertTitle alertMsg:(NSString*)alertMsg alertCancelBtn:(NSString*)alertCancelBtn{
    [[[UIAlertView alloc]initWithTitle:alertTitle message:alertMsg delegate:self cancelButtonTitle:alertCancelBtn otherButtonTitles:nil] show];
}

+(NSString*)getFileString:(NSString*)path isDocument:(BOOL)isDocument type:(NSString*)type{
    if(isDocument)path=[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@.%@",path,type]];
    else path=[[NSBundle mainBundle] pathForResource:path ofType:type];
    return [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
}

+(NSObject*)getJSONFromFile:(NSString*)path isDocument:(BOOL)isDocument{
    if(isDocument)path=[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@.json",path]];
    else path=[[NSBundle mainBundle] pathForResource:path ofType:@"json"];
    return [NSJSONSerialization JSONObjectWithData:[[[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
}

+(NSObject*)getJSONFromJSFile:(NSString*)path isDocument:(BOOL)isDocument{
    if(isDocument)path=[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@.js",path]];
    else path=[[NSBundle mainBundle] pathForResource:path ofType:@"js"];
    NSString *jStr=[[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSArray *arr=[jStr componentsSeparatedByString:@"="];
    NSString *newStr=@"";
    for(int i=1; i<arr.count; i++){
        if(i!=1)newStr=[NSString stringWithFormat:@"%@=%@",newStr,[arr objectAtIndex:i]];
        else newStr=[arr objectAtIndex:i];
    }
    if([[newStr substringFromIndex:[newStr length]-1] isEqualToString:@";"]){
        newStr=[newStr substringToIndex:[newStr length]-1];
    }
    return [NSJSONSerialization JSONObjectWithData:[newStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
}

+(NSObject*)getJSONFromNSURLRequest:(NSURLRequest*)request{
    NSString *link=[[[request URL]absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSArray *array=[link componentsSeparatedByString:@"://"];
    @try{
        NSString *cont=[array objectAtIndex:1];
        NSString *input=[cont stringByReplacingOccurrencesOfString:@"%u" withString:@"\\u"];
        NSString *convertedString=[input mutableCopy];
        CFStringRef transform=CFSTR("Any-Hex/Java");
        CFStringTransform((__bridge CFMutableStringRef)convertedString,NULL,transform,YES);
        NSObject *conJSONObject=[NSJSONSerialization JSONObjectWithData:[convertedString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        return conJSONObject;
    }
    @catch(NSException *exception){return nil;}
}

+(NSString*)dicarrToJsonString:(NSObject*)obj{
    return [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
}

+(void)writeStringToFile:(NSString*)jString path:(NSString*)path{
    [jString writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

+(void)dicarrToJsonFile:(NSObject*)obj path:(NSString*)path isDocument:(BOOL)isDocument{
    NSString *jStr=[DeviceAPI dicarrToJsonString:obj];
    if(isDocument)path=[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@.json",path]];
    else path=[[NSBundle mainBundle] pathForResource:path ofType:@"json"];
    [DeviceAPI writeStringToFile:jStr path:path];
}

+(BOOL)isFileExist:(NSString*)path isDocument:(BOOL)isDocument type:(NSString*)type{
    if(isDocument)path=[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@.%@",path,type]];
    else path=[[NSBundle mainBundle] pathForResource:path ofType:type];
    return ([[NSFileManager defaultManager] fileExistsAtPath:path]);
}

+(BOOL)isFirstTimeUse{
    NSString *usedtPath=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/usedt.json"];
    if([[NSFileManager defaultManager] fileExistsAtPath:usedtPath])return NO;
    return YES;
}

+(void)setAppUsed{
    NSString *usedtPath=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/usedt.json"];
    [@"{\"usedTime\":1}" writeToFile:usedtPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

+(NSString*)getNowDateTime{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddhhmmss"];
    return [dateFormatter stringFromDate:[NSDate date]];
}

+(NSString*)encodeUIImageToBase64String:(UIImage*)image{
    return [NSString stringWithFormat:@"data:image/png;base64,%@",[UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]];
}

+(UIImage*)decodeBase64ToUIImage:(NSString*)strEncodeData{
    return [UIImage imageWithData:[[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters]];
}

+(BOOL)connectedToNetwork{
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len=sizeof(zeroAddress);
    zeroAddress.sin_family=AF_INET;
    SCNetworkReachabilityRef defaultRouteReachability=SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    BOOL didRetrieveFlags=SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    if(!didRetrieveFlags)return 0;
    BOOL isReachable=flags & kSCNetworkFlagsReachable;
    BOOL needsConnection=flags & kSCNetworkFlagsConnectionRequired;
    return (isReachable && !needsConnection) ? YES : NO;
}

+(void)interactiveWithInternet:(NSString*)link postString:(NSString*)postString resultIsJSON:(BOOL)resultIsJSON delegatedObject:(id)delegatedObject endSelector:(SEL)endSelector{
    if([DeviceAPI connectedToNetwork]){
        @try{
            NSData *myRequestData=[NSData dataWithBytes:[postString UTF8String] length:[postString length]];
            NSMutableURLRequest *request=[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString: link]];
            [request setHTTPMethod:@"POST"];
            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
            [request setHTTPBody:myRequestData];
            NSURLSession *session=[NSURLSession sharedSession];
            NSURLSessionDataTask *dataTask=[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
                @try{
                    if(resultIsJSON){
                        NSError *myError;
                        NSMutableDictionary *resultJSON=[[NSMutableDictionary alloc]initWithDictionary:[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&myError]];
                        [delegatedObject performSelectorOnMainThread:endSelector withObject:resultJSON waitUntilDone:NO];
                    }else{
                        NSString *resultString=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                        if(resultString!=nil && [resultString isEqualToString:@""]==NO)
                            [delegatedObject performSelectorOnMainThread:endSelector withObject:resultString waitUntilDone:NO];
                    }
                }@catch(NSException *nse){
                    NSLog(@"Failure on interactive with internet.");
                }
            }];
            [dataTask resume];
        }
        @catch(NSException *nse){
            NSLog(@"Failure on interactive with internet.");
        }
        @finally{}
    }else NSLog(@"Network is unavailable.");
}

+(void)interactiveWithInternetByPassingDictionary:(NSString*)link postDictionary:(NSDictionary*)postDictionary resultIsJSON:(BOOL)resultIsJSON delegatedObject:(id)delegatedObject endSelector:(SEL)endSelector{
    NSString *postString=@"";
    int count=0;
    for(NSString *key in postDictionary){
        NSString *value=(NSString*)[postDictionary objectForKey:key];
        if(count==0)postString=[postString stringByAppendingString:[NSString stringWithFormat:@"%@=%@",key,value]];
        else postString=[postString stringByAppendingString:[NSString stringWithFormat:@"&%@=%@",key,value]];
        count++;
    }
    [DeviceAPI interactiveWithInternet:link postString:postString resultIsJSON:resultIsJSON delegatedObject:delegatedObject endSelector:endSelector];
}

@end