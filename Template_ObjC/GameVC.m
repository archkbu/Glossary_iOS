//
//  GameVC.m
//  LSHK
//
//  Created by Kwok Ho FUNG on 18/11/2015.
//  Copyright © 2015 ULIP. All rights reserved.
//

#import "GameVC.h"

@interface GameVC ()

@end

@implementation GameVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"Game";
    [self.navigationController.navigationBar setHidden:NO];
    
    isEng=YES;
    subfield=@"all";
    webv.mediaPlaybackRequiresUserAction=NO;
    webv.scrollView.bounces=NO;
    [webv loadRequest:[NSURLRequest requestWithURL:[[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"web/game" ofType:@"html"]]]];
    
    showTips=NO;
    if([DeviceAPI isFileExist:@"gatips" isDocument:YES type:@"json"]==NO){
        showTips=YES;
        NSString *usedtPath=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/gatips.json"];
        [DeviceAPI writeStringToFile:@"yes" path:usedtPath];
    }
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if(webView==webv){
        NSString *link=[[[request URL]absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        if([link hasSuffix:@"tomu://"]){
            NSString *lang=@"eng";
            if(!isEng)lang=@"chi";
            NSString *lang2=@"English";
            if(!isEng)lang2=@"Chinese";
            int co=(int)[(NSArray*)[BookmarksHelper getBookmarks:nil type:lang] count];
            if(![subfield isEqualToString:@"bookmarked"] || (co>=10 && [subfield isEqualToString:@"bookmarked"])){
                mctt=0;
                [self performSegueWithIdentifier:@"toPlayVC" sender:self];
            }else [DeviceAPI showAlert:[NSString stringWithFormat:@"You need at least 10 bookmarked %@ terms to play the game. Please bookmark more terms and try again.",lang2] alertMsg:nil alertCancelBtn:@"OK"];
        }else if([link hasSuffix:@"tott://"]){
            NSString *lang=@"eng";
            if(!isEng)lang=@"chi";
            NSString *lang2=@"English";
            if(!isEng)lang2=@"Chinese";
            int co=(int)[(NSArray*)[BookmarksHelper getBookmarks:nil type:lang] count];
            if(![subfield isEqualToString:@"bookmarked"] || (co>=10 && [subfield isEqualToString:@"bookmarked"])){
                mctt=1;
                [self performSegueWithIdentifier:@"toPlayVC" sender:self];
            }else [DeviceAPI showAlert:[NSString stringWithFormat:@"You need at least 10 bookmarked %@ terms to play the game. Please bookmark more terms and try again.",lang2] alertMsg:nil alertCancelBtn:@"OK"];
        }else if([link hasSuffix:@"seteng://"])isEng=YES;
        else if([link hasSuffix:@"setchi://"])isEng=NO;
        else if([link hasPrefix:@"setsubfield://"])
            subfield=[link stringByReplacingOccurrencesOfString:@"setsubfield://" withString:@""];
    }
    return YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    if(showTips)[webv stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"show_tips(true);"]];
    else [webv stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"show_tips(false);"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    PlayVC *vc=(PlayVC*)[segue destinationViewController];
    [vc setGameModeTo:mctt];
    [vc setLangToEng:isEng];
    [vc setSubfield:subfield];
}

@end
