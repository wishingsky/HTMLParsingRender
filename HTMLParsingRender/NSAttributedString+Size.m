//
//  NSAttributedString+Size.m
//  Pods
//
//  Created by weixiaoyun on 16/4/21.
//
//

#import "NSAttributedString+Size.h"
#import <DTCoreText/DTCoreText.h>

@implementation NSAttributedString (Size)

/**
 *  获取attributedString的高度
 *
 *  @param attributedString
 *
 *  @return
 */
- (CGFloat)attributedStringHeightWithMaxWidth:(CGFloat)maxWidth
{
    DTCoreTextLayouter *layouter = [[DTCoreTextLayouter alloc] initWithAttributedString:self];
    
    CGRect maxRect = CGRectMake(0, 0, maxWidth, CGFLOAT_HEIGHT_UNKNOWN);
    NSRange entireString = NSMakeRange(0, [self length]);
    DTCoreTextLayoutFrame *layoutFrame = [layouter layoutFrameWithRect:maxRect range:entireString];
    
    CGSize sizeNeeded = [layoutFrame frame].size;
    
    return ceilf(sizeNeeded.height);
}
@end
