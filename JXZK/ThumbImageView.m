//
//  ThumbImageView.m
//  JXZK
//
//  Created by mac on 13-4-19.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ThumbImageView.h"

@implementation ThumbImageView
@synthesize delegate;
@synthesize FileName;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.tag == 2) {
        return;
    }
    
    
    if (self.tag == -2) {
        if ([delegate respondsToSelector:@selector(thumbPPTImageClicked:)])
        {
            [delegate thumbPPTImageClicked:self.FileName];
        }
    }
    else if (self.tag == -1) {//点击的是视频图片
        if ([delegate respondsToSelector:@selector(thumbMovieImageClicked:)])
        {
            [delegate thumbMovieImageClicked:self.FileName];
        }
    }
    else if ([delegate respondsToSelector:@selector(thumbImageViewStartedTracking:)]) {
        [delegate thumbImageViewStartedTracking:self.tag];
    }
}

@end
