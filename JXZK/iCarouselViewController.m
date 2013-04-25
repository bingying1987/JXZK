//
//  iCarouselViewController.m
//  JXZK
//
//  Created by mac on 13-4-25.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "iCarouselViewController.h"

@interface iCarouselViewController ()

@end

@implementation iCarouselViewController
@synthesize carousel;
@synthesize arcSlider;
@synthesize radiusSlider;
@synthesize titltSlider;
@synthesize spaceingSlider;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    carousel.type = iCarouselTypeCoverFlow2;
    [self updateSliders];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateSliders
{
    switch (carousel.type)
    {
        case iCarouselTypeLinear:
        {
            arcSlider.enabled = NO;
        	radiusSlider.enabled = NO;
            titltSlider.enabled = NO;
            spaceingSlider.enabled = YES;
            break;
        }
        case iCarouselTypeCylinder:
        case iCarouselTypeInvertedCylinder:
        case iCarouselTypeRotary:
        case iCarouselTypeInvertedRotary:
        case iCarouselTypeWheel:
        case iCarouselTypeInvertedWheel:
        {
            arcSlider.enabled = YES;
        	radiusSlider.enabled = YES;
            titltSlider.enabled = NO;
            spaceingSlider.enabled = YES;
            break;
        }
        default:
        {
            arcSlider.enabled = NO;
        	radiusSlider.enabled = NO;
            titltSlider.enabled = YES;
            spaceingSlider.enabled = YES;
            break;
        }
    }

}

#pragma mark -
#pragma mark iCarousel methods
- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return 10;//测试10张图片
}

- (UIView*)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    if (view == nil)
    {
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 400.0f, 300.0f)];
        ((UIImageView *)view).image = [UIImage imageNamed:@"online.png"];
        view.contentMode = UIViewContentModeScaleToFill;
    }
    return view;
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    switch (option) {
        case iCarouselOptionWrap:
            return YES;
        case iCarouselOptionArc:
            return 2 * M_PI * arcSlider.value;
        case iCarouselOptionRadius:
            return value * radiusSlider.value;
        case iCarouselOptionTilt:
            return titltSlider.value;
        case iCarouselOptionSpacing:
            return value * spaceingSlider.value;
        default:
            return value;
    }
}

- (IBAction)reloadCarousel
{
    [carousel reloadData];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}
@end
