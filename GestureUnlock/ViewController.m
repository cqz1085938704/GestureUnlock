//
//  ViewController.m
//  GestureUnlock
//
//  Created by Henry on 15/5/11.
//  Copyright (c) 2015年 Henry. All rights reserved.
//

#import "ViewController.h"
#import "CustomView.h"


@interface ViewController ()<CustomViewDelegate>
{
    BOOL flag;
    NSArray *arrS, *arrV;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CustomView *v = [[CustomView alloc] initWithFrame:self.view.frame];
    v.backgroundColor = [UIColor whiteColor];
    v.delegate = self;
    [self.view addSubview:v];
    
    flag = NO;
    
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.apple.com"]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSString *html = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"Apple website:\n%@", html);
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)gestureFinished:(NSArray *)results
{
    if (!flag)
    {
        NSLog(@"set");
        arrS = results;
        flag = YES;
    }
    else
    {
        NSLog(@"validate");
        arrV = results;
        flag = NO;
        
        [self validateP];
    }
}

- (void)validateP
{
    NSString *error = nil;
    
    if ([arrV isEqualToArray:arrS])
    {
        NSLog(@"correct");
        error = @"correct";
    }
    else
    {
        NSLog(@"wrong");
        error = @"wrong";
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:error message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    
    NSLog(@"%@\n%@", arrS, arrV);
}
@end
