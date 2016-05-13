//
//  HtmlView.h
//  Pods
//
//  Created by weixiaoyun on 16/4/19.
//
//

#import <UIKit/UIKit.h>
#import <DTCoreText/DTCoreText.h>
#import "TextAttachment.h"
#import "AudioAttachment.h"
#import "ImageAttachment.h"
#import "NSAttributedString+Size.h"

typedef UIView * (^CustomImageView)(NSString *imageURL, CGRect frame);
typedef UIView * (^CustomAudioView)(NSString *audioURL, NSTimeInterval duration, CGRect frame);
typedef UIView * (^CustomTextView)(NSAttributedString *attributedString, CGRect frame);

typedef void (^DidDrawLayout)();

@interface HtmlView : UIView<DTAttributedTextContentViewDelegate>

@property (nonatomic, copy) CustomImageView customImageView;
@property (nonatomic, copy) CustomAudioView customAudioView;
@property (nonatomic, copy) CustomTextView customTextView;
@property (nonatomic, copy) DidDrawLayout didDrawLayout;


- (void)bindHtmlString:(NSString*)htmlString;

/**
 *  高度小于一屏时居中显示
 *
 */
- (void)updateTextViewFrame;

@end
