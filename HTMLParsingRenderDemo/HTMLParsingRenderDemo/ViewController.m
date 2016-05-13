//
//  ViewController.m
//  HTMLParsingRenderDemo
//
//  Created by weixiaoyun on 16/5/13.
//  Copyright © 2016年 wishingsky. All rights reserved.
//

#import "ViewController.h"
#import <HtmlView.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <DTCoreText/DTCoreText.h>
#import "WSTextView.h"
#import "WSAudioView.h"

@interface ViewController ()

@property (nonatomic, strong) HtmlView *htmlView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _htmlView = [[HtmlView alloc] initWithFrame:self.view.bounds];
    _htmlView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    [self.view addSubview:_htmlView];
    
    NSString *readmePath = [[NSBundle mainBundle] pathForResource:@"Test.html" ofType:nil];
    NSString *html = [NSString stringWithContentsOfFile:readmePath encoding:NSUTF8StringEncoding error:NULL];
    
    [_htmlView bindHtmlString:html];
    
    [_htmlView updateTextViewFrame];
    
    _htmlView.didDrawLayout = ^() {
        
    };
    
    
    _htmlView.customImageView = ^(NSString *imageURL, CGRect frame){
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed: @"default"]];
        
        return imageView;
    };
    
    
    __weak typeof(self) weakSelf = self;
    _htmlView.customAudioView = ^(NSString *audioURL, NSTimeInterval duration, CGRect frame){
        
        WSAudioView *audioView = [[NSBundle mainBundle] loadNibNamed:@"WSAudioView" owner:weakSelf options:nil].firstObject;
        audioView.frame = frame;
        audioView.audioUrl = audioURL;
        
        return audioView;
    };
    
    _htmlView.customTextView = ^(NSAttributedString *attributedString, CGRect frame){
        
        WSTextView *textView = [[WSTextView alloc] initWithFrame:frame];
        textView.attributedString = attributedString;
        
        return textView;
    };
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
