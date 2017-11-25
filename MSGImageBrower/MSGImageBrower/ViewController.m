//
//  ViewController.m
//  MSGImageBrower
//
//  Created by xiongan on 16/11/15.
//  Copyright © 2016年 承道. All rights reserved.
//

#import "ViewController.h"
#import "MSGImageBrowerVc.h"
#import <UIImageView+WebCache.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView.tag = 0;
    self.imageView2.tag = 1;
    self.imageView3.tag = 2;
    //小图
    NSArray *smallImages = @[
    @"http://ww4.sinaimg.cn/or360/4a8ba3e3gw1f7cwzwo2bnj21kw1kwgql.jpg",
    @"http://ww4.sinaimg.cn/or360/4a8ba3e3gw1f7cwzvmb0oj21kw1kwgqn.jpg",
    @"http://ww4.sinaimg.cn/or360/4a8ba3e3gw1f7cwzyuzhwj21kw1kwq70.jpg",
                             ];
       NSURL *url = [NSURL URLWithString:@"http://ww4.sinaimg.cn/woriginal/4a8ba3e3gw1f7cwzvmb0oj21kw1kwgqn.jpg"];
    [self.imageView sd_setImageWithURL:url placeholderImage:nil];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addbrView:)];
    [self.imageView addGestureRecognizer:tap];
    
    NSURL *url2 = [NSURL URLWithString:@"http://ww4.sinaimg.cn/woriginal/4a8ba3e3gw1f7cwzwo2bnj21kw1kwgql.jpg"];
    NSURL *url3 = [NSURL URLWithString:@"http://ww4.sinaimg.cn/woriginal/4a8ba3e3gw1f7cwzyuzhwj21kw1kwq70.jpg"];
    
    [self.imageView2 sd_setImageWithURL:url2 placeholderImage:nil];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addbrView:)];
    [self.imageView2 addGestureRecognizer:tap2];
    
    [self.imageView3 sd_setImageWithURL:url3 placeholderImage:nil];
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addbrView:)];
    [self.imageView3 addGestureRecognizer:tap3];
    
}
- (void)addbrView:(UITapGestureRecognizer *)tap
{
    MSGImageBrowerVc *brVc = [[MSGImageBrowerVc alloc]init];
    brVc.currentIndex = tap.view.tag;
    //大图
    NSArray *bigImages = @[
                           @"http://img.htmleaf.com/1505/images-zoom-demo.jpg",
                           @"http://www.57zxw.com/uploads/allimg/161128/10401J012_0.png",
                           @"http://s3.51cto.com/wyfs02/M00/41/00/wKiom1PP2HHzezCFAAX4ru3jTgo138.jpg",
                           ];
    brVc.browerImages = bigImages;
    brVc.sourceImage = [(UIImageView *)tap.view image];
    brVc.sourceFrame = tap.view.frame;
    [brVc show];
//    [self addChildViewController:brVc];
//    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.99 initialSpringVelocity:9 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        self.imageView.center = self.view.center;
//        self.imageView.transform = CGAffineTransformScale(self.imageView.transform, 400.0/self.imageView.frame.size.width, 400.0/self.imageView.frame.size.height);
//
//    } completion:^(BOOL finished) {
//        self.imageView.transform = CGAffineTransformIdentity ;
//        [self.view addSubview:brVc.view];
//
//    }];

}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
//    [self presentViewController:brVc animated:YES completion:nil];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
