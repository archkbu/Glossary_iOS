//
//  ResultVC.m
//  LSHK
//
//  Created by Kwok Ho FUNG on 20/11/2015.
//  Copyright © 2015 ULIP. All rights reserved.
//

#import "ResultVC.h"

@interface ResultVC ()

@end

@implementation ResultVC

-(void)setFather:(id)vc{
    father=vc;
}

-(void)setResultArr:(NSArray*)arr isMC:(NSString*)mc{
    resultArr=arr;
    isMC=mc;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    //NSLog(@"setResultArr(%@);",[DeviceAPI dicarrToJsonString:resultArr]);
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setResultArr(%@,%@);",[DeviceAPI dicarrToJsonString:resultArr],isMC]];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if(webView==webv){
        NSString* link=[[request URL]absoluteString];
        if([link hasPrefix:@"toback://"]){
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-3] animated:YES];
        }else if([link hasPrefix:@"tonew://"]){
            NSString* link=[[request URL]absoluteString];
            link=[link stringByReplacingOccurrencesOfString:@"tonew://" withString:@""];
            nglv=[link intValue];
            [self.navigationController popViewControllerAnimated:YES];
            SEL s=NSSelectorFromString(@"newGameWithLevel:");
            [father performSelector:s withObject:[NSNumber numberWithInt:nglv]];
        }
    }
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"Results";
    [self.navigationItem setHidesBackButton:YES animated:YES];
    webv.mediaPlaybackRequiresUserAction=NO;
    webv.scrollView.bounces=NO;
    [webv loadRequest:[NSURLRequest requestWithURL:[[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"web/result" ofType:@"html"]]]];
    nglv=0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
