//
//  GDetailsVC.m
//  LSHK
//
//  Created by Kwok Ho FUNG on 16/11/2015.
//  Copyright © 2015 ULIP. All rights reserved.
//

#import "GDetailsVC.h"

@interface GDetailsVC ()

@end

@implementation GDetailsVC

-(void)setIndex:(NSDictionary*)ind lan:(NSString*)lan gvc:(id)gvc{
    indexDic=ind;
    lang=lan;
    glvc=gvc;
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if(webView==webv){
        NSString *link=[[[request URL]absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        if([link hasPrefix:@"addbm://"]){
            NSDictionary *indexDic2=(NSDictionary*)[DeviceAPI getJSONFromNSURLRequest:request];
            int intKey=[[indexDic2 objectForKey:@"key"] intValue];
            int intData=[[indexDic2 objectForKey:@"data"] intValue];
            NSString *str=[NSString stringWithFormat:@"%d,%d",intKey,intData];
            if([BookmarksHelper isAlreadyAddedToBookmarksWithString:nil stringId:str type:lang]){
                [BookmarksHelper removeBookmarkWithString:nil stringId:str type:lang];
                [webView stringByEvaluatingJavaScriptFromString:@"setBookmarked(false);"];
            }else{
                [BookmarksHelper addBookmarkWithString:nil stringId:str type:lang];
                [webView stringByEvaluatingJavaScriptFromString:@"setBookmarked(true);"];
            }
            objc_msgSend(glvc, sel_getUid("needRefreshBookmarks"));
        }
    }
    return YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    NSString *str=[NSString stringWithFormat:@"%d,%d",[[indexDic objectForKey:@"key"] intValue],[[indexDic objectForKey:@"data"] intValue]];
    BOOL bed=[BookmarksHelper isAlreadyAddedToBookmarksWithString:nil stringId:str type:lang];
    NSString *bStr=@"false";
    if(bed)bStr=@"true";
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setIndex(%@,'%@');setBookmarked(%@);",[DeviceAPI dicarrToJsonString:indexDic],lang,bStr]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"Details";
    webv.mediaPlaybackRequiresUserAction=NO;
    webv.scrollView.bounces=NO;
    [webv loadRequest:[NSURLRequest requestWithURL:[[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"web/gdetails" ofType:@"html"]]]];
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
