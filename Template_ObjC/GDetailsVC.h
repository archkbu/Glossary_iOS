//
//  GDetailsVC.h
//  LSHK
//
//  Created by Kwok Ho FUNG on 16/11/2015.
//  Copyright © 2015 ULIP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookmarksHelper.h"
#import <objc/message.h>

@interface GDetailsVC : UIViewController<UIWebViewDelegate>{
    IBOutlet UIWebView *webv;
    NSDictionary *indexDic;
    NSString *lang;
    id glvc;
}

-(void)setIndex:(NSDictionary*)ind lan:(NSString*)lan gvc:(id)gvc;

@end
