//
//  WtaVC.m
//  Created by Dave Fung.
//  Copyright (c) 2015 Hong Kong Baptist University. All rights reserved.

#import "WtaVC.h"

@interface WtaVC ()

@end

@implementation WtaVC

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if(webView==webV){
        NSString* link=[[request URL]absoluteString];
        if([link hasPrefix:@"tonext://"]){
            [self performSegueWithIdentifier:@"toAgreeVC" sender:self];
            return NO;
        }else if([link hasPrefix:@"toback://"]){
            [self.navigationController popViewControllerAnimated:YES];
            return NO;
        }
    }
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"Why this APP";
    [self.navigationItem setHidesBackButton:YES animated:YES];
    [self.navigationController.navigationBar setHidden:YES];
    webV.scrollView.bounces=NO;
    [webV loadRequest:[NSURLRequest requestWithURL:[[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"snapscreen_web/wtavc" ofType:@"html"]]]];
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