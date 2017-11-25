//
//  ICPageView.m
//  ICPageView
//
//  Created by andy  on 15/12/29.
//  Copyright © 2015年 andy . All rights reserved.
//

#define MAX_SECTION 100
#define DEFULAT_PAGETIME 5
const double MaxSCale = 2.0 ; //最大缩放比例
const double MinScale = 1.0 ; //最小缩放比例


#import "ICPageView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <MBProgressHUD/MBProgressHUD.h>


@interface PageViewCell : UICollectionViewCell
@property (nonatomic, strong) id <PageViewImageItemProtocol>imageItem;
@property (nonatomic,assign) CGFloat totalScale;
@property (weak , nonatomic)  UIImageView *imageView;
@property (strong , nonatomic)  UIPinchGestureRecognizer *pinch;

@end

@interface PageViewCell()
@property(nonatomic,strong) NSCache *imageCache;
@end
@implementation PageViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self =[super initWithFrame:frame];
    if (self) {
        UIImageView *img = [[UIImageView alloc] init];
        [self.contentView addSubview:img];
        self.imageView = img;
        self.imageCache = [[NSCache alloc]init];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(removeCached) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        [self setUpImageFrame:CGRectMake((screenSize.width - 400 )*0.5, (screenSize.height - 400 )*0.5, 400, 400)];
    }
    
    return self;
}

-(void)setImageItem:(id<PageViewImageItemProtocol>)imageItem {
    _imageItem = imageItem;
    self.totalScale = 1.0;
    if(!self.pinch){
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
        self.pinch = pinch;
        [self.imageView addGestureRecognizer:pinch];
        self.imageView.userInteractionEnabled = YES;
    }
    [self settingData];
}
- (void)pinch:(UIPinchGestureRecognizer *)recognizer{
    
    CGFloat scale = recognizer.scale;
    
    //放大情况
    if(scale > 1.0){
        if(self.totalScale >= MaxSCale) return;
    }
    
    //缩小情况
    if (scale < 1.0) {
        if (self.totalScale <= MinScale) return;
    }
    
    self.imageView.transform = CGAffineTransformScale(self.imageView.transform, scale, scale);
    self.totalScale *=scale;
    recognizer.scale = 1.0;
    
}


-(void)removeCached{
    [self.imageCache removeAllObjects];
}


#pragma mark 给子控件赋值
-(void)settingData {
    [[self viewWithTag:1001]removeFromSuperview];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.tag = 1001;
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.label.text = @"Loading";
    [self.imageView sd_setImageWithURL:[_imageItem imageUrl] placeholderImage:[UIImage imageNamed:[_imageItem imagePlaceholder]] options:SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        hud.progress = expectedSize / receivedSize;
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [hud hideAnimated:YES];
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        CGSize imageSize ;
        if (image.size.width > screenSize.width) {
            imageSize = CGSizeMake(screenSize.width, screenSize.height * (image.size.width / screenSize.width));
        }else if (image.size.height > screenSize.height){
            imageSize = CGSizeMake(screenSize.width * (image.size.height / screenSize.height),screenSize.height );
        }else {
            imageSize = image.size;
        }
        [self setUpImageFrame:CGRectMake((screenSize.width - imageSize.width )*0.5, (screenSize.height - imageSize.height )*0.5, imageSize.width, imageSize.height)];
    }];
}

#pragma mark 设置子控件的frame
- (void)setUpImageFrame:(CGRect)rect {
    [UIView animateWithDuration:0.35 animations:^{
        self.imageView.frame  = rect;
    }];
}
@end

@interface ICPageView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic , strong) UICollectionView *collectionView;
@property (nonatomic , strong) UIPageControl *pageControl;
@property (nonatomic , strong) NSTimer *timer;
@property (nonatomic , assign) NSInteger numberOfPageView;

@end


@implementation ICPageView


-(void)willMoveToWindow:(UIWindow *)newWindow
{
    [self setUpView];
}

static NSString *CELLID = @"ID_CELL";

-(void)setUpView
{
    
    NSAssert(self.dataSource, @"dataSource must be non-nil");
    NSAssert([self.dataSource respondsToSelector:@selector(numberOfPageView)], @"dataSource imageItemForPageViewAtIndex: must be non-nil");
    NSAssert([self.dataSource respondsToSelector:@selector(imageItemForPageViewAtIndex:)], @"dataSource imageItemForPageViewAtIndex: must be non-nil");
    NSInteger numberOfPageView = [self.dataSource numberOfPageView];
    _numberOfPageView = numberOfPageView;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 0;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) collectionViewLayout:flowLayout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.pagingEnabled = YES;
    collectionView.backgroundColor = [UIColor clearColor];
    [self addSubview:collectionView];
    
    _collectionView = collectionView;
    
    [self.collectionView registerClass:[PageViewCell class] forCellWithReuseIdentifier:CELLID];
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:MAX_SECTION/2] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height - 20);
    pageControl.bounds = CGRectMake(0, 0, 150, 40);
    pageControl.pageIndicatorTintColor = self.pageIndicatorTintColor ?self.pageIndicatorTintColor:[UIColor whiteColor];
    pageControl.currentPageIndicatorTintColor = self.pageIndicatorTintColor ?self.currentPageIndicatorTintColor:[UIColor redColor];
    pageControl.enabled = NO;
    pageControl.numberOfPages = _numberOfPageView;
    
    [self addSubview:pageControl];
    
    _pageControl=pageControl;
    
    [self addTimer];

}
-(void)reloadData
{
    
    NSAssert(self.dataSource, @"dataSource must be non-nil");
    NSAssert([self.dataSource respondsToSelector:@selector(numberOfPageView)], @"dataSource imageItemForPageViewAtIndex: must be non-nil");
    NSAssert([self.dataSource respondsToSelector:@selector(imageItemForPageViewAtIndex:)], @"dataSource imageItemForPageViewAtIndex: must be non-nil");
    NSInteger numberOfPageView = [self.dataSource numberOfPageView];
    _numberOfPageView = numberOfPageView;
    _pageControl.numberOfPages = _numberOfPageView;
    [_collectionView reloadData];
    [self addTimer];
}

- (void)pageViewScrollToIndex:(NSInteger )index {
    NSIndexPath *currentIndexPath = [[self.collectionView indexPathsForVisibleItems] lastObject];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:currentIndexPath.section] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

#pragma mark 添加定时器
-(void) addTimer{
    
    if (self.cancelAutoPage)return;//取消自动翻页
    [self removeTimer];//添加之前移除以前的
    NSTimer *timer;
    if (self.pageTime == 0) {
        timer = [NSTimer scheduledTimerWithTimeInterval:DEFULAT_PAGETIME target:self selector:@selector(nextpage) userInfo:nil repeats:YES];
    }else{
       timer = [NSTimer scheduledTimerWithTimeInterval:self.pageTime target:self selector:@selector(nextpage) userInfo:nil repeats:YES];
    }
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.timer = timer ;
    
}

#pragma mark 删除定时器
-(void) removeTimer{
    [self.timer invalidate];
    self.timer = nil;
}
-(void)setCancelAutoPage:(BOOL)cancelAutoPage
{
    _cancelAutoPage = cancelAutoPage;
    [self removeTimer];
    
}

-(void) nextpage{
    NSIndexPath *currentIndexPath = [[self.collectionView indexPathsForVisibleItems] lastObject];
    NSLog(@"%ld-%ld",currentIndexPath.section,currentIndexPath.row);
    NSIndexPath *currentIndexPathReset = [NSIndexPath indexPathForItem:currentIndexPath.item inSection:MAX_SECTION / 2];
    [self.collectionView scrollToItemAtIndexPath:currentIndexPathReset atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    
    NSInteger nextItem = currentIndexPathReset.item + 1;
    NSInteger nextSection = currentIndexPathReset.section;
    if (nextItem == self.numberOfPageView) {
        nextItem = 0;
        nextSection ++;
    }
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:nextItem inSection:nextSection];
    
    [self.collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}

#pragma mark- UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return MAX_SECTION;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.numberOfPageView;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PageViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELLID forIndexPath:indexPath];
    if(!cell){
        cell = [[PageViewCell alloc] init];
    }
    cell.imageItem = [self.dataSource imageItemForPageViewAtIndex:indexPath.item];
    return cell;
}



-(void) scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self removeTimer];
    
}
#pragma mark 当用户停止的时候调用
-(void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [self addTimer];
    
}


#pragma mark 设置页码
-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    int page = (int) (scrollView.contentOffset.x / scrollView.frame.size.width + 0.5)%self.numberOfPageView;
    self.pageControl.currentPage = page;
}

//结束拖拽
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([self.delegate respondsToSelector:@selector(pageViewDidDragToIndex:)]) {
        [self.delegate pageViewDidDragToIndex:self.pageControl.currentPage];
    }
    
}
//点击
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(pageViewDidTapIndex:)]) {
        [self.delegate pageViewDidTapIndex:indexPath.item];
    }

}

@end
