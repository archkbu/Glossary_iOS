//
//  BookmarksVC.m
//  LSHK
//
//  Created by Kwok Ho FUNG on 17/11/2015.
//  Copyright © 2015 ULIP. All rights reserved.
//

#import "BookmarksVC.h"

@interface BookmarksVC ()

@end

@implementation BookmarksVC

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if(webView==webv){
        NSString *link=[[[request URL]absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        if([link hasPrefix:@"todetails://"]){}
    }
    return YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    webv.mediaPlaybackRequiresUserAction=NO;
    webv.scrollView.bounces=NO;
    [webv loadRequest:[NSURLRequest requestWithURL:[[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"web/bookmarks" ofType:@"html"]]]];
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
