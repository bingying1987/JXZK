//
//  ViewController.m
//  JXZK
//
//  Created by mac on 13-4-19.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ViewController.h"

#define THUMB_HEIGHT 110
#define THUMB_V_PADDING 30
#define THUMB_H_PADDING 30
#define CREDIT_LABEL_HEIGHT 20
#define AUTOSCROLL_THRESHOLD 30

@interface ViewController ()
{
    NSString* _currentMediaName;
    NSString* _currentPPT;
}
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
    //[__scrollTabButtonList setClipsToBounds:NO];
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


- (void)initMoviePictures
{
    picArray = [[NSMutableArray alloc] initWithCapacity:10];
    picFileNameArray = [[NSMutableArray alloc] initWithCapacity:10];
    NSString* dirPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSLog(dirPath,nil);
    
    
    //NSString *documentsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    //NSArray *dirContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDir error:nil];
    //NSArray *onlyPics = [dirContents filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self ENDSWITH '.jpg'"]];
    
    
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    NSArray* tempArray = [fileMgr contentsOfDirectoryAtPath:dirPath error:nil];//得到所有文件
    NSArray *onlyPics = [tempArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self ENDSWITH '.jpg'"]];
    for(NSString* fileName in onlyPics)
    {
        BOOL flag = YES;
        NSString* fullPath = [dirPath stringByAppendingPathComponent:fileName];
        if ([fileMgr fileExistsAtPath:fullPath isDirectory:&flag]) {
            if (!flag) {
                [picArray addObject:fullPath];
                [picFileNameArray addObject:fileName];
            }
        }
    }

}

#define THUMB_H1_PADDING 20
#define THUMB_V1_PADDING 20
#define THUMB_WIDTH 200
- (void)createMediaPictureScrollView
{
    if ([picArray count] <= 0) {
        return;
    }
    int yPostion = THUMB_V1_PADDING;
    //[__picScrollView setClipsToBounds:NO];
    for (int j = 0;j < [picArray count];j++) {
        NSString* imagePath = [picArray objectAtIndex:j];
        UIImage *thumbImage = [UIImage imageWithContentsOfFile:imagePath];
        if (thumbImage) {
            ThumbImageView *thumbView = [[ThumbImageView alloc] initWithImage:thumbImage];
            thumbView.delegate = self;
            thumbView.tag = -1;//-1表示 是视频图片滚动视图里的图片
            thumbView.FileName = [picFileNameArray objectAtIndex:j];
            [thumbView setExclusiveTouch:YES];
            [thumbView setUserInteractionEnabled:YES];
            CGRect frame = [thumbView frame];
            frame.origin.y = yPostion;
            frame.origin.x = THUMB_H1_PADDING + 100 * (j % 2) + THUMB_H1_PADDING * (j % 2);
            [thumbView setFrame:frame];
            [__picScrollView addSubview:thumbView];
            if (j % 2 == 1) {
                yPostion += frame.size.height + THUMB_V1_PADDING;
            }
        }
    }
    float scrollViewWidth = THUMB_WIDTH + THUMB_H1_PADDING * 3;
    if ([picArray count] % 2 != 0) {
        yPostion = yPostion + 100 + THUMB_V1_PADDING;
    }
    [__picScrollView setContentSize:CGSizeMake(scrollViewWidth, yPostion)];
}



- (void)initPPTPictures
{
    pptArray = [[NSMutableArray alloc] initWithCapacity:10];
    pptFileNameArray = [[NSMutableArray alloc] initWithCapacity:10];
    NSString* dirPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSLog(dirPath,nil);
    
    
    //NSString *documentsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    //NSArray *dirContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDir error:nil];
    //NSArray *onlyPics = [dirContents filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self ENDSWITH '.jpg'"]];
    
    
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    NSArray* tempArray = [fileMgr contentsOfDirectoryAtPath:dirPath error:nil];//得到所有文件
    NSArray *onlyPics = [tempArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self ENDSWITH '.png'"]];
    for(NSString* fileName in onlyPics)
    {
        BOOL flag = YES;
        NSString* fullPath = [dirPath stringByAppendingPathComponent:fileName];
        if ([fileMgr fileExistsAtPath:fullPath isDirectory:&flag]) {
            if (!flag) {
                [pptArray addObject:fullPath];
                [pptFileNameArray addObject:fileName];
            }
        }
    }
    
}

- (void)createPPTPictureScrollView
{
    if ([pptArray count] <= 0) {
        return;
    }
    int yPostion = THUMB_V1_PADDING;
    //[__picScrollView setClipsToBounds:NO];
    for (int j = 0;j < [pptArray count];j++) {
        NSString* imagePath = [pptArray objectAtIndex:j];
        UIImage *thumbImage = [UIImage imageWithContentsOfFile:imagePath];
        if (thumbImage) {
            ThumbImageView *thumbView = [[ThumbImageView alloc] initWithImage:thumbImage];
            thumbView.delegate = self;
            thumbView.tag = -2;//-2表示 是PPT图片滚动视图里的图片
            thumbView.FileName = [pptFileNameArray objectAtIndex:j];
            [thumbView setExclusiveTouch:YES];
            [thumbView setUserInteractionEnabled:YES];
            CGRect frame = [thumbView frame];
            frame.origin.y = yPostion;
            frame.origin.x = THUMB_H1_PADDING + 100 * (j % 2) + THUMB_H1_PADDING * (j % 2);
            [thumbView setFrame:frame];
            [__pptScrollView addSubview:thumbView];
            if (j % 2 == 1) {
                yPostion += frame.size.height + THUMB_V1_PADDING;
            }
        }
    }
    float scrollViewWidth = THUMB_WIDTH + THUMB_H1_PADDING * 3;
    if ([pptArray count] % 2 != 0) {
        yPostion = yPostion + 100 + THUMB_V1_PADDING;
    }
    [__pptScrollView setContentSize:CGSizeMake(scrollViewWidth, yPostion)];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    _currentIndex = 0;
    [self createThumbScrollView];
    [self initMoviePictures];
    [self createMediaPictureScrollView];
    [self initPPTPictures];
    [self createPPTPictureScrollView];
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
        [__scrollTabButtonList setFrame:CGRectMake(0, 648, 1024, 120)];
    }
    else
    {
        [__scrollTabButtonList setFrame:CGRectMake(0, 768, 1024, 120)];
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

- (void)thumbMovieImageClicked:(NSString*) PicName;
{
    NSString* string1 = @".jpg";
    NSRange range = [PicName rangeOfString:string1];
    NSString* string2 = [PicName substringToIndex:range.location];//提取到影片名字
    _currentMediaName = string2;
    __label.text = [NSString stringWithFormat:@"当前选中:  %@",string2];
    return;
    /*
    range = [PicName rangeOfString:@"3D"];
    
    NSString *pstr;
    if (range.location != NSNotFound) {//是3D影片
        pstr = @"http://192.168.1.100/HisanVideo/VideoOpenActive?stereo=2&file=D:/Video/";
    }
    else
    {
        pstr = @"http://192.168.1.100/HisanVideo/VideoOpen?file=D:/Video/";
    }
    
    pstr = [pstr stringByAppendingString:string2];
    const char *str3 = pstr.UTF8String;
    NSString *str2 = [NSString stringWithUTF8String:str3];
    NSLog(str2,0);
    str2 = [str2 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//这一步完成转码
    NSURL* url = [NSURL URLWithString:str2];
    
    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:3];
    NSData* urlData;
    NSError* error;
    NSURLResponse* response;
    urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    */
}

- (void)thumbPPTImageClicked:(NSString*) pptName;
{
    NSString* string1 = @".png";
    NSRange range = [pptName rangeOfString:string1];
    NSString* string2 = [pptName substringToIndex:range.location];//提取到ppt名字
    _currentPPT = string2;
    __label.text = [NSString stringWithFormat:@"当前选中:  %@",string2];
    return;

    
    
    /*
    NSString *pstr = [NSString stringWithFormat:@"http://192.168.1.100/HisanCapture/CaptureOpenPPT?fileName=%@",string2];
    const char *str3 = pstr.UTF8String;
    NSString *str2 = [NSString stringWithUTF8String:str3];
    NSLog(str2,0);
    str2 = [str2 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//这一步完成转码
    NSURL* url = [NSURL URLWithString:str2];
    
    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:3];
    NSData* urlData;
    NSError* error;
    NSURLResponse* response;
    urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    */
}

- (IBAction)PlayMedia:(id)sender {
    if (_currentMediaName == nil) {
        return;
    }
    
    NSRange range = [_currentMediaName rangeOfString:@"3D"];
    
    NSString *pstr;
    if (range.location != NSNotFound) {//是3D影片
        pstr = @"http://192.168.1.100/HisanVideo/VideoOpenActive?stereo=2&file=D:/Video/";
    }
    else
    {
        pstr = @"http://192.168.1.100/HisanVideo/VideoOpen?file=D:/Video/";
    }
    
    pstr = [pstr stringByAppendingString:_currentMediaName];
    const char *str3 = pstr.UTF8String;
    NSString *str2 = [NSString stringWithUTF8String:str3];
    NSLog(str2,0);
    str2 = [str2 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//这一步完成转码
    NSURL* url = [NSURL URLWithString:str2];
    
    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:3];
    NSData* urlData;
    NSError* error;
    NSURLResponse* response;
    urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];

}

- (IBAction)PauseMedia:(id)sender {
    NSString* str = @"http://192.168.1.100/HisanVideo/VideoPlayOrPause";
    NSLog(str,nil);
    NSURL* url = [NSURL URLWithString:str];
    
    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:3];
    
    NSData* urlData;
    NSError* error;
    NSURLResponse* response;
    urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
}

- (IBAction)StopMedia:(id)sender {
    NSString* str = @"http://192.168.1.100/HisanVideo/VideoClose";
    NSLog(str,nil);
    NSURL* url = [NSURL URLWithString:str];
    
    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:3];
    
    NSData* urlData;
    NSError* error;
    NSURLResponse* response;
    urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
}

- (IBAction)OpenPPT:(id)sender {
    if (_currentPPT == nil) {
        return;
    }
    
    NSString *pstr = [NSString stringWithFormat:@"http://192.168.1.100/HisanCapture/CaptureOpenPPT?fileName=%@",_currentPPT];
    const char *str3 = pstr.UTF8String;
    NSString *str2 = [NSString stringWithUTF8String:str3];
    NSLog(str2,0);
    str2 = [str2 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//这一步完成转码
    NSURL* url = [NSURL URLWithString:str2];
    
    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:3];
    NSData* urlData;
    NSError* error;
    NSURLResponse* response;
    urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
}

- (IBAction)pptUp:(id)sender {
    if (_currentPPT == nil) {
        return;
    }
    
    NSString *pstr = @"http://融合器IP/HisanCapture/ CaptureOperate?op=101";
    const char *str3 = pstr.UTF8String;
    NSString *str2 = [NSString stringWithUTF8String:str3];
    NSLog(str2,0);
    str2 = [str2 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//这一步完成转码
    NSURL* url = [NSURL URLWithString:str2];
    
    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:3];
    NSData* urlData;
    NSError* error;
    NSURLResponse* response;
    urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
}

- (IBAction)pptDown:(id)sender {
    if (_currentPPT == nil) {
        return;
    }
    
    NSString *pstr = @"http://融合器IP/HisanCapture/ CaptureOperate?op=102";
    const char *str3 = pstr.UTF8String;
    NSString *str2 = [NSString stringWithUTF8String:str3];
    NSLog(str2,0);
    str2 = [str2 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//这一步完成转码
    NSURL* url = [NSURL URLWithString:str2];
    
    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:3];
    NSData* urlData;
    NSError* error;
    NSURLResponse* response;
    urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
}
@end
