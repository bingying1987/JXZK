//
//  ViewController.h
//  JXZK
//
//  Created by mac on 13-4-19.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThumbImageView.h"
@interface ViewController : UIViewController<ThumbImageViewDelegate>
{
    NSInteger _currentIndex;
}
@property (weak, nonatomic) IBOutlet UIScrollView *_scrollTabButtonList;


@end
