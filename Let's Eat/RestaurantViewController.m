//
//  RestaurantViewController.m
//  Let's Eat
//
//  Created by Ryan Kass on 3/26/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import "RestaurantViewController.h"
#import "Graphics.h"

@interface RestaurantViewController ()
@property (strong, nonatomic) IBOutlet UIBarButtonItem *rightBar;
@property (strong, nonatomic) IBOutlet UIWebView *yelpView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *ind;
@property (strong, nonatomic) UIButton* back;
@end

@implementation RestaurantViewController
@synthesize yelpView;
@synthesize restaurant, back;
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.yelpView.scalesPageToFit = YES;
    NSURL *url = [NSURL URLWithString:self.restaurant.url];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.yelpView loadRequest:requestObj];
    self.yelpView.delegate = self;
    UIImage *backImg = [UIImage imageNamed:@"BackBrownCarrot"];
    //UIImage* homeImg = [Graphics makeThumbnailOfSize:bigImage size:CGSizeMake(37,22)];
    self.back = [UIButton buttonWithType:UIButtonTypeCustom];
    self.back.bounds = CGRectMake( 0, 0, backImg.size.width, backImg.size.height );
    [self.back setImage:backImg forState:UIControlStateNormal];
    UIBarButtonItem* backItem = [[UIBarButtonItem alloc] initWithCustomView:self.back];
    [self.back addTarget:self action:@selector(backPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = backItem;
    self.rightBar.tintColor = [Graphics colorWithHexString:@"b8a37e"];
    [self.ind startAnimating];
//ny additional setup after loading the view.
}/*
-(void)webViewDidStartLoad:(UIWebView *)webView{
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('app-pitch').style.display = 'none'"];
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('search-bar').style.display = 'none'"];
}*/
- (IBAction)pop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)backPressed:(UIBarButtonItem*)sender{
    if ([self.yelpView canGoBack])
        [self.yelpView goBack];
    else
        [self.navigationController popViewControllerAnimated:YES];
}

-(void)editPage:(bool)finished
{
    if (finished){
        [self.ind stopAnimating];
        [self.ind removeFromSuperview];
    }
    [self.yelpView stringByEvaluatingJavaScriptFromString:@"document.getElementById('app-pitch').style.display = 'none'"];
    NSString *exists = [self.yelpView stringByEvaluatingJavaScriptFromString:@"document.getElementById('search-bar')!=null;"];
    if ([exists isEqualToString:@"true"]){
        [self.yelpView stringByEvaluatingJavaScriptFromString:@"document.getElementById('search-bar').style.display = 'none'"];
         self.yelpView.scrollView.contentOffset = CGPointMake(0,-18);

    }
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self editPage:NO];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self editPage:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
