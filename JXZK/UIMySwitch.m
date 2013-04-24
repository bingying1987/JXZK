//
//  UIMySwitch.m
//  JXZK
//
//  Created by mac on 13-4-22.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "UIMySwitch.h"

@implementation UIMySwitch

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.onTintColor = [UIColor blackColor];
        self.tintColor = [UIColor yellowColor];
        self.thumbTintColor = [UIColor orangeColor];
        self.backgroundColor = [UIColor clearColor];
        self.opaque = 0.6;
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}


@end
