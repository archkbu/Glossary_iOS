//  Created by Dave Fung.
//  Copyright (c) 2015 Hong Kong Baptist University. All rights reserved.

#import "SnapScreenVC.h"

@interface SnapScreenVC ()

@end

@implementation SnapScreenVC

-(void)toNextPage{
    if([DeviceAPI isFirstTimeUse])[self performSegueWithIdentifier:@"splashToWtaVC" sender:self];
    else [self performSegueWithIdentifier:@"splashToHome" sender:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:YES];
    webv.scrollView.bounces=NO;
    [webv loadRequest:[NSURLRequest requestWithURL:[[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"snapscreen_web/index" ofType:@"html"]]]];
    webv.mediaPlaybackRequiresUserAction=NO;
    [NSTimer scheduledTimerWithTimeInterval:6 target:self selector:@selector(toNextPage) userInfo:nil repeats:NO];
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