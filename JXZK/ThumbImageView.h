//
//  ThumbImageView.h
//  JXZK
//
//  Created by mac on 13-4-19.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ThumbImageViewDelegate;
@interface ThumbImageView : UIImageView
{
    id <ThumbImageViewDelegate> delegate;
}

@property (nonatomic,readwrite) id <ThumbImageViewDelegate> delegate;

@end

@protocol ThumbImageViewDelegate <NSObject>

@optional
- (void)thumbImageViewStartedTracking:(NSInteger) iIndex;

@end