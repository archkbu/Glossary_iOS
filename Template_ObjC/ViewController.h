//  Created by Dave Fung.
//  Copyright (c) 2015 Hong Kong Baptist University. All rights reserved.

#import <UIKit/UIKit.h>
#import "GlossaryVC.h"
#import "GlobalValues.h"

@interface ViewController : UIViewController<UIWebViewDelegate>{
    IBOutlet UIWebView *webv;
    BOOL isInBM;
    BOOL needFS;
    BOOL isSearching;
}

@end
