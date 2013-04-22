//
//  ViewController.m
//  JXZK
//
//  Created by mac on 13-4-19.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ViewController.h"

#define THUMB_HEIGHT 150
#define THUMB_V_PADDING 10
#define THUMB_H_PADDING 10
#define CREDIT_LABEL_HEIGHT 20
#define AUTOSCROLL_THRESHOLD 30

@interface ViewController ()
- (NSArray*)imageData;
- (void)createThumbScrollView;
@end

@implementation ViewController


 - (NSArray*)imageData
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ImageData" ofType:@"plist"];
    NSData *plistData = [NSData dataWithContentsOfFile:path];
    NSString *error;
    NSPropertyListFormat format;
    NSArray* imageData = [NSPropertyListSerialization propertyListFromData:plistData mutabilityOption:NSPropertyListImmutable format:&format errorDescription:&error];
    
    if (!imageData) {
        NSLog(@"Failed to read image names");
    }
    return imageData;
}

- (void)createThumbScrollView
{
    [__scrollTabButtonList setClipsToBounds:NO];
    float xPostion = THUMB_H_PADDING;
    int i = 0;
    for (NSDictionary* imageDict in [self imageData]) {
        NSString *name = [imageDict valueForKey:@"name"];
        UIImage *thumbImage = [UIImage imageNamed:name];
        if (thumbImage) {
            ThumbImageView *thumbView = [[ThumbImageView alloc] initWithImage:thumbImage];
            thumbView.delegate = self;
            thumbView.tag = i;
            [thumbView setExclusiveTouch:YES];
            [thumbView setUserInteractionEnabled:YES];
            i++;
            CGRect frame = [thumbView frame];
            frame.origin.y = THUMB_V_PADDING;
            frame.origin.x = xPostion;
            [thumbView setFrame:frame];
            [__scrollTabButtonList addSubview:thumbView];
            xPostion += frame.size.width + THUMB_H_PADDING;
        }
    }
    float scrollViewHeight = THUMB_HEIGHT + THUMB_V_PADDING;
    [__scrollTabButtonList setContentSize:CGSizeMake(xPostion, scrollViewHeight)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _currentIndex = 0;
    [self createThumbScrollView];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showScroolTabButtonList:(BOOL)bShow
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.5];
    if (bShow) {
        [__scrollTabButtonList setFrame:CGRectMake(0, 618, 1024, THUMB_HEIGHT)];
    }
    else
    {
        [__scrollTabButtonList setFrame:CGRectMake(0, 768, 1024, THUMB_HEIGHT)];
    }
    [UIView commitAnimations];

}

- (BOOL)IsTabButtonListIsShow
{
    if (__scrollTabButtonList.frame.origin.y != 768) {
        return YES;
    }else
        return FALSE;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if ([touch tapCount] == 2) {
        if (![self IsTabButtonListIsShow]) {
            [self showScroolTabButtonList:YES];
        }
        else
            [self showScroolTabButtonList:NO];
    
    }
    else if([touch tapCount] == 1)
    {
        if ([self IsTabButtonListIsShow]) {
            [self showScroolTabButtonList:FALSE];
        }
    
    }
}

#define BASEINDEX 100
- (void)changView:(NSInteger)newIndex
{

    NSInteger newViewIndex = [[self.view subviews] indexOfObject:[self.view viewWithTag:newIndex + BASEINDEX]];
    NSInteger oldViewIndex = [[self.view subviews] indexOfObject:[self.view viewWithTag:_currentIndex + BASEINDEX]];
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDuration:1.0];
    srandom(time(0));
    [UIView setAnimationTransition: (rand() % UIViewAnimationTransitionCurlDown) + 1 forView:self.view cache:NO];
    [self.view  exchangeSubviewAtIndex:oldViewIndex withSubviewAtIndex:newViewIndex];
    [UIView commitAnimations];
}

- (void)thumbImageViewStartedTracking:(NSInteger)iIndex
{
    if (iIndex != _currentIndex) {
        [self showScroolTabButtonList:FALSE];
        [self changView:iIndex];
        _currentIndex = iIndex;
    }

}

@end
