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
    if ([delegate respondsToSelector:@selector(thumbImageViewStartedTracking:)]) {
        [delegate thumbImageViewStartedTracking:self.tag];
    }
}

@end
