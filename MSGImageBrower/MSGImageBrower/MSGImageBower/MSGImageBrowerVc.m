//
//  MSGImageBrowerVc.m
//  MSGImageBrower
//
//  Created by xiongan on 16/11/15.
//  Copyright © 2016年 承道. All rights reserved.
//

#import "MSGImageBrowerVc.h"
#import "ICPageView.h"
#import "ICImageItem.h"

@interface MSGImageBrowerVc ()<ICPageViewDelegate,ICPageViewDataSource>

@property (nonatomic,strong) NSArray *images;
@property (nonatomic,weak)ICPageView *pageView ;
@end

@implementation MSGImageBrowerVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    
    NSMutableArray *images = [NSMutableArray array];
    for (int i = 0; i<self.browerImages.count; i++) {
        ICImageItem *item = [[ICImageItem alloc]init];
        item.imageUrl = [NSURL URLWithString:self.browerImages[i]];//网络图片
        item.imagePlaceholder = @"1.png";//占位图
        [images addObject:item];
    }
    _images = images;
    
    
    ICPageView *pageView = [[ICPageView alloc]init];
    pageView.cancelAutoPage = YES;
    pageView.frame = self.view.bounds;
    pageView.center = self.view.center;
    pageView.delegate = self;
    pageView.dataSource = self;
    [self.view addSubview:pageView];
    _pageView = pageView;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [button addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(100, 30, 40, 40);
    [self.view addSubview:button];
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)close {
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (void)show {
    id<UIApplicationDelegate>app = [UIApplication sharedApplication].delegate;
    [[app window].rootViewController addChildViewController:self];
    [[app window].rootViewController.view addSubview:self.view];
    [self beginAnimation];
}

- (void)beginAnimation {
    self.pageView.hidden = YES;
    UIImageView *sourceImageView = [[UIImageView alloc]initWithFrame:self.sourceFrame];
    sourceImageView.image = self.sourceImage;
    [self.view addSubview:sourceImageView];
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1 initialSpringVelocity:15 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        sourceImageView.center = self.view.center;
        sourceImageView.transform = CGAffineTransformScale(sourceImageView.transform, 400.0/sourceImageView.frame.size.width, 400.0/sourceImageView.frame.size.height);
    } completion:^(BOOL finished) {
        sourceImageView.hidden = YES;
        self.pageView.hidden = NO;
    }];
    
    [self.pageView pageViewScrollToIndex:self.currentIndex];
    
}



#pragma mark - ICPageViewDataSource

-(NSInteger)numberOfPageView
{
    return _images.count;
}

//反回的是个模型，模型应该遵循PageViewImageItemProtocol 你可以继承ICImageItem，成为它的子类
-(id<PageViewImageItemProtocol>)imageItemForPageViewAtIndex:(NSInteger)index
{
    return _images[index];
}

#pragma mark - ICPageViewDelegate
-(void)pageViewDidDragToIndex:(NSInteger)index
{
    NSLog(@"pageViewDidDragToIndex %ld",index);
}

-(void)pageViewDidTapIndex:(NSInteger)index
{
    NSLog(@"pageViewDidTapIndex %ld",index);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
