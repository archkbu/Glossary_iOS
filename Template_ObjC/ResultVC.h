//
//  ResultVC.h
//  LSHK
//
//  Created by Kwok Ho FUNG on 20/11/2015.
//  Copyright © 2015 ULIP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceAPI.h"
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

@interface ResultVC : UIViewController<UIWebViewDelegate>{
    IBOutlet UIWebView *webv;
    NSArray *resultArr;
    id father;
    int nglv;
    NSString *isMC;
}

-(void)setResultArr:(NSArray*)arr isMC:(NSString*)mc;
-(void)setFather:(id)vc;

@end
