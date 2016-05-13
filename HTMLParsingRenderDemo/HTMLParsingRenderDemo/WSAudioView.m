//
//  WSAudioView.m
//  Pods
//
//  Created by weixiaoyun on 16/4/19.
//
//

#import "WSAudioView.h"

@interface WSAudioView ()


@end

@implementation WSAudioView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.layer.cornerRadius = 4.0;
    self.layer.masksToBounds = YES;
    
}

- (IBAction)play:(id)sender {
    NSLog(@"======play=======");
}
@end
