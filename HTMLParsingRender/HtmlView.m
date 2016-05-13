//
//  HtmlView.m
//  Pods
//
//  Created by weixiaoyun on 16/4/19.
//
//

#import "HtmlView.h"

static const CGFloat topPadding = 20.0;
static const CGFloat leftPadding = 16.0;

@interface HtmlView ()

@property (nonatomic, strong) DTAttributedTextView *textView;
@property (nonatomic, assign) CGFloat maxWidth;

@end

@implementation HtmlView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		self.backgroundColor = [UIColor whiteColor];
        [DTTextAttachment registerClass:[TextAttachment class] forTagName:@"ws-text"];
        [DTTextAttachment registerClass:[ImageAttachment class] forTagName:@"ws-image"];
        [DTTextAttachment registerClass:[AudioAttachment class] forTagName:@"ws-audio"];
        
        [self setUpTextView];
        _maxWidth = _textView.frame.size.width - leftPadding * 2;
    }
    return self;
}

- (void)setUpTextView {
    _textView = [[DTAttributedTextView alloc] initWithFrame:CGRectMake(0, topPadding, self.frame.size.width, self.frame.size.height - 2 * topPadding)];
	
    _textView.shouldDrawImages = NO;
    _textView.shouldDrawLinks = NO;
    _textView.textDelegate = self;
    _textView.contentInset = UIEdgeInsetsMake(topPadding, leftPadding, topPadding, leftPadding);
    _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;

    [self addSubview:_textView];
}

- (void)bindHtmlString:(NSString*)htmlString
{
    _textView.attributedString = [self _attributedString:htmlString];
}

/**
 *  高度小于一屏时居中显示
 *
 */
- (void)updateTextViewFrame
{
    CGFloat height = [_textView.attributedString attributedStringHeightWithMaxWidth:_maxWidth] + 50;
    if (height < self.frame.size.height) {
        _textView.frame = CGRectMake(_textView.frame.origin.x, (self.frame.size.height - height) / 2, _textView.frame.size.width, height);
    }
}

#pragma mark - Private Method

/**
 *  由html解析生成NSAttributedString
 *
 *  @param htmlString html
 *
 *  @return
 */
- (NSAttributedString *)_attributedString:(NSString *)htmlString
{
    NSData *data = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    
    CGSize maxImageSize = CGSizeMake(_maxWidth, self.bounds.size.height - topPadding * 2);
    
    void (^callBackBlock)(DTHTMLElement *element) = ^(DTHTMLElement *element) {
        
        if ([element.textAttachment isKindOfClass:[DTObjectTextAttachment class]])
        {
            DTObjectTextAttachment *objectAttachment = (DTObjectTextAttachment *)element.textAttachment;
            objectAttachment.childNodes = [element.childNodes copy];

            //由于ws-text, ws-audio标签不会指定宽高，需要在这里计算其实际宽高后赋值给附件，以便coreText在渲染这些自定义的标签对象前知道这些附件占多大空间，让CoreText渲染文字时留出空白
            if ([objectAttachment isKindOfClass:[TextAttachment class]]) {
                
                CGFloat stringHeight = [[self childAttributedStringForAttachment:objectAttachment] attributedStringHeightWithMaxWidth:_maxWidth];
                
                element.textAttachment.originalSize = CGSizeMake(_maxWidth, stringHeight);
                element.textAttachment.displaySize = CGSizeMake(_maxWidth, stringHeight);
            } else if ([element.textAttachment isKindOfClass:[AudioAttachment class]]) {
                
                element.textAttachment.originalSize = CGSizeMake(_maxWidth, 46);
                element.textAttachment.displaySize = CGSizeMake(_maxWidth, 46);
            } else if ([element.textAttachment isKindOfClass:[ImageAttachment class]]) {
                
                CGSize originalSize = CGSizeMake(_maxWidth, (element.textAttachment.originalSize.height/element.textAttachment.originalSize.width)*_maxWidth) ;
                element.textAttachment.originalSize = originalSize;
                element.textAttachment.displaySize = originalSize;
            }
        }
    };


    NSMutableDictionary *options = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithFloat:1.0], NSTextSizeMultiplierDocumentOption,
                                    [NSValue valueWithCGSize:maxImageSize], DTMaxImageSize,
                                    @"Helvetica Neue", DTDefaultFontFamily,
                                    [NSNumber numberWithFloat:16.0], DTDefaultFontSize,
                                    [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0], DTDefaultTextColor,
                                    @"purple", DTDefaultLinkColor,
                                    [NSNumber numberWithFloat:1.5], DTDefaultLineHeightMultiplier,
                                    [self defaultDTCSSStylesheet], DTDefaultStyleSheet,
                                    @"red", DTDefaultLinkHighlightColor,
                                    
                                    callBackBlock, DTWillFlushBlockCallBack, nil];
    
    NSAttributedString *string = [[NSAttributedString alloc] initWithHTMLData:data options:options documentAttributes:NULL];
    
    return string;
}

/**
 *  获取自定义附件所有子节点解析后生成的NSAttributedString
 *
 *  @param objectAttachment 自定义附件
 *
 *  @return 解析后生成的NSAttributedString
 */
- (NSAttributedString*)childAttributedStringForAttachment:(DTObjectTextAttachment*)objectAttachment
{
    NSMutableAttributedString *tmpString = [[NSMutableAttributedString alloc] init];
    for (DTHTMLElement *oneChildElement in objectAttachment.childNodes) {
        [tmpString appendAttributedString:[oneChildElement attributedString]];
    }
    
    return tmpString;
}

/**
 *  获取默认样式表
 *
 *  @return
 */
- (DTCSSStylesheet*)defaultDTCSSStylesheet
{
    NSString *filePath=[[NSBundle mainBundle] pathForResource:@"cssString"ofType:@"txt"];
    NSString *cssString=[[NSString alloc] initWithContentsOfFile:filePath];
    DTCSSStylesheet *defaultSheet = [[DTCSSStylesheet alloc] initWithStyleBlock:cssString];
    
    return defaultSheet;
}

#pragma mark ---- DTAttributedTextContentViewDelegate

- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttachment:(DTTextAttachment *)attachment frame:(CGRect)frame
{
    
    if ([attachment isKindOfClass:[ImageAttachment class]]) {
        
        if (self.customImageView) {
            NSURL *url = (id)attachment.contentURL;
            UIView *imageView = self.customImageView([url absoluteString], frame);

            return imageView;
        }
    } else if ([attachment isKindOfClass:[AudioAttachment class]]) {
        
        if (self.customAudioView) {
            NSURL *audioUrl = (id)attachment.contentURL;
            NSTimeInterval duration = [[attachment.attributes objectForKey:@"duration"] doubleValue];
            UIView *audioView = self.customAudioView([audioUrl absoluteString], duration, frame);

            return audioView;
        }
    } else if ([attachment isKindOfClass:[TextAttachment class]]) {
        TextAttachment *objectAttachment = (TextAttachment*)attachment;
		
        NSAttributedString *attributedString = [self childAttributedStringForAttachment:objectAttachment];
        
        if (self.customTextView) {
            UIView *textView = self.customTextView(attributedString, frame);

            return textView;
        }
    }
    
    return nil;
}

- (void)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView didDrawLayoutFrame:(DTCoreTextLayoutFrame *)layoutFrame inContext:(CGContextRef)context {
    
    if (self.didDrawLayout) {
        self.didDrawLayout();
    }
}

@end
