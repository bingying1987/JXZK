//
//  iCarouselViewController.h
//  JXZK
//
//  Created by mac on 13-4-25.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
@interface iCarouselViewController : UIViewController<iCarouselDataSource,iCarouselDelegate>
@property (strong, nonatomic) IBOutlet iCarousel *carousel;
@property (weak, nonatomic) IBOutlet UISlider *arcSlider;
@property (weak, nonatomic) IBOutlet UISlider *radiusSlider;
@property (weak, nonatomic) IBOutlet UISlider *titltSlider;
@property (weak, nonatomic) IBOutlet UISlider *spaceingSlider;

- (IBAction)reloadCarousel;
@end
