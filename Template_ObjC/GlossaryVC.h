//
//  GlossaryVC.h
//  LSHK
//
//  Created by Kwok Ho FUNG on 16/11/2015.
//  Copyright © 2015 ULIP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDetailsVC.h"
#import "BookmarksHelper.h"
#import "GlobalValues.h"

@interface GlossaryVC : UIViewController<UIWebViewDelegate,UIAlertViewDelegate>{
    IBOutlet UIWebView *webv;
    NSDictionary *toIndexDic;
    NSString *lang;
    BOOL nrbm;
    BOOL isInBM;
    BOOL showTips;
    BOOL needFS;
}

-(void)needRefreshBookmarks;
-(void)setInBM:(BOOL)inbm;
-(void)setNeedFocusSearch;

@end
