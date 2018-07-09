//
//  MenuVC.m
//  LSHK
//
//  Created by Kwok Ho FUNG on 11/11/2015.
//  Copyright © 2015 ULIP. All rights reserved.
//

#import "MenuVC.h"

@interface MenuVC ()

@end

@implementation MenuVC

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if(webView==webv){
        NSString* link=[[request URL]absoluteString];
        if([link hasSuffix:@"toglos://"])
            [self performSegueWithIdentifier:@"toGlossaryVC" sender:self];
        else if([link hasSuffix:@"togame://"])
            [self performSegueWithIdentifier:@"toGameVC" sender:self];
    }
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    webv.mediaPlaybackRequiresUserAction=NO;
    webv.scrollView.bounces=NO;
    [webv loadRequest:[NSURLRequest requestWithURL:[[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"web/menu" ofType:@"html"]]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
