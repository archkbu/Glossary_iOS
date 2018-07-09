//
//  PlayVC.m
//  LSHK
//
//  Created by Kwok Ho FUNG on 18/11/2015.
//  Copyright © 2015 ULIP. All rights reserved.
//

#import "PlayVC.h"

@interface PlayVC ()

@end

@implementation PlayVC

-(void)setGameModeTo:(int)gm{
    gmode=gm;
}

-(void)setLangToEng:(BOOL)b{
    if(b)lang=@"eng";
    else lang=@"chi";
}

-(void)setSubfield:(NSString*)sf{
    subfield=sf;
}

-(void)newGameWithLevel:(NSNumber*)lv{
    nwlv=lv.intValue;
    [webv stringByEvaluatingJavaScriptFromString:@"location.reload();"];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if(webView==webv){
        NSString *link=[[[request URL]absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        if([link hasPrefix:@"addbm://"]){
            NSDictionary *indexDic2=(NSDictionary*)[DeviceAPI getJSONFromNSURLRequest:request];
            int intKey=[[indexDic2 objectForKey:@"key"] intValue];
            int intData=[[indexDic2 objectForKey:@"data"] intValue];
            //NSLog(@"key=%d, data=%d",intKey,intData);
            NSString *str=[NSString stringWithFormat:@"%d,%d",intKey,intData];
            if([BookmarksHelper isAlreadyAddedToBookmarksWithString:nil stringId:str type:lang]){
                [BookmarksHelper removeBookmarkWithString:nil stringId:str type:lang];
                [webView stringByEvaluatingJavaScriptFromString:@"setBookmarked(false);"];
            }else{
                [BookmarksHelper addBookmarkWithString:nil stringId:str type:lang];
                [webView stringByEvaluatingJavaScriptFromString:@"setBookmarked(true);"];
            }
        }else if([link hasPrefix:@"toresult://"]){
            resultArr=(NSArray*)[DeviceAPI getJSONFromNSURLRequest:request];
            [self performSegueWithIdentifier:@"toResultVC" sender:self];
        }else if([link hasPrefix:@"alemp://"]){
            [DeviceAPI showAlert:@"Please type into the 'Translation' field." alertMsg:nil alertCancelBtn:@"Ok"];
        }
    }
    return YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    //NSLog(@"nwlv: %d",nwlv);
    [webv stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"initGame('%@','%@',%@,%d)",lang,subfield,[BookmarksHelper getBookmarksJSONString:nil],nwlv]];
    if(showTips)[webv stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"show_tips(true);"]];
    else [webv stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"show_tips(false);"]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"Game";
    [self.navigationController.navigationBar setHidden:NO];
    
    webv.mediaPlaybackRequiresUserAction=NO;
    webv.scrollView.bounces=NO;
    if(gmode==0)[webv loadRequest:[NSURLRequest requestWithURL:[[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"web/play_mc" ofType:@"html"]]]];
    else if(gmode==1)[webv loadRequest:[NSURLRequest requestWithURL:[[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"web/play_tt" ofType:@"html"]]]];
    
    showTips=NO;
    nwlv=0;
    if(gmode==0){
        if([DeviceAPI isFileExist:@"pmtips" isDocument:YES type:@"json"]==NO){
            showTips=YES;
            NSString *usedtPath=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/pmtips.json"];
            [DeviceAPI writeStringToFile:@"yes" path:usedtPath];
        }
    }else if(gmode==1){
        if([DeviceAPI isFileExist:@"pttips" isDocument:YES type:@"json"]==NO){
            showTips=YES;
            NSString *usedtPath=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/pttips.json"];
            [DeviceAPI writeStringToFile:@"yes" path:usedtPath];
        }
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationItem setHidesBackButton:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ResultVC *vc=(ResultVC*)[segue destinationViewController];
    if(gmode==0)[vc setResultArr:resultArr isMC:@"true"];
    else if(gmode==1)[vc setResultArr:resultArr isMC:@"false"];
    [vc setFather:self];
}

@end
