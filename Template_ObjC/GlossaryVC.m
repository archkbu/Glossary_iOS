//
//  GlossaryVC.m
//  LSHK
//
//  Created by Kwok Ho FUNG on 16/11/2015.
//  Copyright © 2015 ULIP. All rights reserved.
//

#import "GlossaryVC.h"

@interface GlossaryVC ()

@end

@implementation GlossaryVC

-(void)needRefreshBookmarks{
    nrbm=YES;
    if(nrbm)[webv stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setBookmarksWithRefresh(%@);",[BookmarksHelper getBookmarksJSONString:nil]]];
    nrbm=NO;
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if(webView==webv){
        NSString *link=[[[request URL]absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        //NSLog(@"%@",link);
        if([link hasPrefix:@"todetailseng://"]){
            lang=@"eng";
            toIndexDic=(NSDictionary*)[DeviceAPI getJSONFromNSURLRequest:request];
            [self performSegueWithIdentifier:@"toGDetailsVC" sender:self];
        }else if([link hasPrefix:@"todetailschi://"]){
            lang=@"chi";
            toIndexDic=(NSDictionary*)[DeviceAPI getJSONFromNSURLRequest:request];
            [self performSegueWithIdentifier:@"toGDetailsVC" sender:self];
        }else if([link hasPrefix:@"inbm://"]){
            [self addRemoveAll];
        }else if([link hasPrefix:@"ninbm://"]){
            [self removeRemoveAll];
        }else if([link hasPrefix:@"nobm://"]){
            [DeviceAPI showAlert:@"No Bookmark added yet." alertMsg:nil alertCancelBtn:@"OK"];
        }
    }
    return YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [webv stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setBookmarks(%@);",[BookmarksHelper getBookmarksJSONString:nil]]];
    //NSLog(@"%@",[BookmarksHelper getBookmarksJSONString:nil]);
    if(isInBM)[webv stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setIsInBM(true);"]];
    else [webv stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setIsInBM(false);"]];
    if(showTips)[webv stringByEvaluatingJavaScriptFromString:@"show_tips(true);"];
    else [webv stringByEvaluatingJavaScriptFromString:@"show_tips(false);"];
    if([GlobalValues getIsSearching]){
        [GlobalValues setIsNotSearching];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [webv stringByEvaluatingJavaScriptFromString:@"setTimeout(function(){document.getElementById('input_searchbar').focus();},10);"];
        });
    }
}

-(void)addRemoveAll{
    UIBarButtonItem *flipButton=[[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStylePlain target:self action:@selector(wantToRemoveAllBookmarks)];
    self.navigationItem.rightBarButtonItem=flipButton;
}

-(void)removeRemoveAll{
    self.navigationItem.rightBarButtonItem=nil;
}

-(void)wantToRemoveAllBookmarks{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Confirmation" message:@"Are you sure to delete all the bookmarks?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok",nil];
    alert.delegate=self;
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==1){
        [BookmarksHelper removeAllBookmarksInType:nil type:lang];
        [self removeRemoveAll];
        [webv stringByEvaluatingJavaScriptFromString:@"removedAllBookmarks();"];
    }
}

-(void)setInBM:(BOOL)inbm{
    isInBM=inbm;
}

-(void)setNeedFocusSearch{
    needFS=YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"Glossary";
    webv.mediaPlaybackRequiresUserAction=NO;
    webv.scrollView.bounces=NO;
    webv.keyboardDisplayRequiresUserAction=NO;
    [webv loadRequest:[NSURLRequest requestWithURL:[[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"web/glossary" ofType:@"html"]]]];
    nrbm=NO;
    
    showTips=NO;
    if([DeviceAPI isFileExist:@"gltips" isDocument:YES type:@"json"]==NO){
        showTips=YES;
        NSString *usedtPath=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/gltips.json"];
        [DeviceAPI writeStringToFile:@"yes" path:usedtPath];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    GDetailsVC *vc=(GDetailsVC*)[segue destinationViewController];
    [vc setIndex:toIndexDic lan:lang gvc:self];
}

@end
