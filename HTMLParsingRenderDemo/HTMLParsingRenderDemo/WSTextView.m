//
//  WSTextView.m
//  Pods
//
//  Created by weixiaoyun on 16/4/19.
//
//

#import "WSTextView.h"
#import <DTCoreText/DTCoreText.h>

@interface WSTextView ()

@property (strong, nonatomic) IBOutlet DTAttributedLabel *textView;

@end

@implementation WSTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _textView = [[DTAttributedLabel alloc] initWithFrame:self.bounds];
        [self addSubview:_textView];
    }
    return self;
}

- (void)setAttributedString:(NSAttributedString *)attributedString
{
    _textView.attributedString = attributedString;
}

@end
