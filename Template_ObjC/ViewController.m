//  Created by Dave Fung.
//  Copyright (c) 2015 Hong Kong Baptist University. All rights reserved.

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

BOOL isToGL=NO;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"Home";
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationItem setHidesBackButton:YES animated:YES];
    
    webv.mediaPlaybackRequiresUserAction=NO;
    webv.scrollView.bounces=NO;
    [webv loadRequest:[NSURLRequest requestWithURL:[[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"web/home_1" ofType:@"html"]]]];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if(webView==webv){
        NSString* link=[[request URL]absoluteString];
        if([link hasSuffix:@"app://popwta2"])
            [self performSegueWithIdentifier:@"popWta2VC" sender:self];
        else if([link hasSuffix:@"app://popabout2"])
            [self performSegueWithIdentifier:@"popAbout2VC" sender:self];
        else if([link hasSuffix:@"toga://"])
                [self performSegueWithIdentifier:@"HomeToGameVC" sender:self];
        else if([link hasSuffix:@"togl://"]){
            isToGL=YES;
            isInBM=NO;
            [self performSegueWithIdentifier:@"HomeToGlossaryVC" sender:self]; //toMenuVC
        }else if([link hasSuffix:@"tobm://"]){
            isToGL=YES;
            isInBM=YES;
            [self performSegueWithIdentifier:@"HomeToGlossaryVC" sender:self];
        }else if([link hasSuffix:@"tose://"]){
            isToGL=YES;
            isInBM=NO;
            needFS=YES;
            [GlobalValues setIsSearching];
            [self performSegueWithIdentifier:@"HomeToGlossaryVC" sender:self];
        }
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if(isToGL){
        GlossaryVC *vc=(GlossaryVC*)[segue destinationViewController];
        [vc setInBM:isInBM];
        if(needFS)[vc setNeedFocusSearch];
        needFS=NO;
    }
    isToGL=NO;
}

@end
