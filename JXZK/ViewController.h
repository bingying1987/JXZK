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
    NSMutableArray *picArray;
    NSMutableArray *picFileNameArray;
    NSMutableArray *pptArray;
    NSMutableArray *pptFileNameArray;
}
@property (weak, nonatomic) IBOutlet UIScrollView *_scrollTabButtonList;
@property (weak, nonatomic) IBOutlet UIScrollView *_picScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *_pptScrollView;
@property (weak, nonatomic) IBOutlet UILabel *_label;
- (IBAction)PlayMedia:(id)sender;
- (IBAction)PauseMedia:(id)sender;
- (IBAction)StopMedia:(id)sender;
- (IBAction)OpenPPT:(id)sender;
- (IBAction)pptUp:(id)sender;
- (IBAction)pptDown:(id)sender;


@end
