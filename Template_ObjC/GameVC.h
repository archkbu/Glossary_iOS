#import <UIKit/UIKit.h>
#import <objc/message.h>
#import "PlayVC.h"

@interface GameVC : UIViewController<UIWebViewDelegate>{
    IBOutlet UIWebView *webv;
    int mctt;
    BOOL isEng;
    NSString *subfield;
    BOOL showTips;
}

@end
