//
//  ViewController.m
//  03-GET-Range
//
//  Created by qingyun on 15/7/30.
//  Copyright (c) 2015年 河南青云信息技术有限公司. All rights reserved.
//

#import "ViewController.h"

// 205*154

#define kImgURLStr  @"http://img1.3lian.com/img2012/2/0226/32/54.png"

@interface ViewController () <NSURLConnectionDataDelegate>
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) NSMutableData *imgData;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _imgView = [[UIImageView alloc] init];
    _imgView.backgroundColor = [UIColor lightGrayColor];
    
    // frame
    [self fetchAndSetImageFrame];
    
    [self.view addSubview:_imgView];
}
- (IBAction)downloadImage:(UIButton *)sender {
    NSURL *url = [NSURL URLWithString:kImgURLStr];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 请求时，不能使用缓存，否则就会返回206
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    [connection start];
}

#pragma mark - connection data delegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if (httpResponse.statusCode != 200) {
        [connection cancel];
        NSLog(@">>>%@", [NSHTTPURLResponse localizedStringForStatusCode:httpResponse.statusCode]);
        return;
    }
    
    _imgData = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_imgData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"%@", _imgData);
    _imgView.image = [UIImage imageWithData:_imgData];
}

- (void)fetchAndSetImageFrame
{
    NSURL *url = [NSURL URLWithString:kImgURLStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    // 设置range字段
    // Range:bytes=begin-end
    // PNG 16-23 大小 w h
    [request setValue:@"bytes=16-23" forHTTPHeaderField:@"Range"];
    

//    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];

    NSURLResponse *response;
    NSError *error;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error) {
        NSLog(@"%@", error);
        return;
    }
    
    CGSize size = pngImgSizeWithData(data);
    NSLog(@"%@", NSStringFromCGSize(size));
    
    _imgView.frame = CGRectMake(0, 0, size.width, size.height);
    _imgView.center = self.view.center;
}

CGSize pngImgSizeWithData(NSData *data)
{
   // NSLog(@"%@", data);
    
    int w1 = 0, w2 = 0, w3 = 0, w4 = 0;
    
    [data getBytes:&w1 range:NSMakeRange(0, 1)];
    [data getBytes:&w2 range:NSMakeRange(1, 1)];
    [data getBytes:&w3 range:NSMakeRange(2, 1)];
    [data getBytes:&w4 range:NSMakeRange(3, 1)];
    
    int w = (w1<<24) + (w2<<16) + (w3<<8) +w4;

    int h1 = 0, h2 = 0, h3 = 0, h4 = 0;
    
    [data getBytes:&h1 range:NSMakeRange(4, 1)];
    [data getBytes:&h2 range:NSMakeRange(5, 1)];
    [data getBytes:&h3 range:NSMakeRange(6, 1)];
    [data getBytes:&h4 range:NSMakeRange(7, 1)];
    
    int h = (h1<<24) + (h2<<16) + (h3<<8) +h4;
    
    return CGSizeMake(w, h);
}

@end
