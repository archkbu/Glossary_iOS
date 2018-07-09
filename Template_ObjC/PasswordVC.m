//  Created by Dave Fung.
//  Copyright (c) 2015 Hong Kong Baptist University. All rights reserved.

#import "PasswordVC.h"

@interface PasswordVC ()

@end

@implementation PasswordVC

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString* link=[[request URL]absoluteString];
    if([link hasPrefix:@"tonext://"]){
        [self performSegueWithIdentifier:@"pwToHome" sender:self];
        return NO;
    }else if([link hasPrefix:@"wrongpw://"]){
        [DeviceAPI showAlert:@"Wrong Password" alertMsg:nil alertCancelBtn:@"OK"];
        return NO;
    }else if([link hasPrefix:@"emptypw://"]){
        [DeviceAPI showAlert:@"Please enter the password" alertMsg:nil alertCancelBtn:@"OK"];
        return NO;
    }else if([link hasPrefix:@"toback://"]){
        [self.navigationController popViewControllerAnimated:YES];
        return NO;
    }
    return YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setAppPassword('%@')",[GlobalValues getAppPassword]]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"Password";
    [self.navigationController.navigationBar setHidden:YES];
    webv.scrollView.bounces=NO;
    [webv loadRequest:[NSURLRequest requestWithURL:[[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"snapscreen_web/passwordvc" ofType:@"html"]]]];
    webv.mediaPlaybackRequiresUserAction=NO;
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