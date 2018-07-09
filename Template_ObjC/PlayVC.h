//
//  PlayVC.h
//  LSHK
//
//  Created by Kwok Ho FUNG on 18/11/2015.
//  Copyright © 2015 ULIP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookmarksHelper.h"
#import "ResultVC.h"

@interface PlayVC : UIViewController<UIWebViewDelegate>{
    IBOutlet UIWebView *webv;
    int gmode;
    NSString *lang;
    NSString *subfield;
    NSArray *resultArr;
    BOOL showTips;
    int nwlv;
}

-(void)setGameModeTo:(int)gm;
-(void)setLangToEng:(BOOL)b;
-(void)setSubfield:(NSString*)sf;
-(void)newGameWithLevel:(NSNumber*)lv;

@end
