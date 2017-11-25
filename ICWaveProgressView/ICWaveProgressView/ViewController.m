//
//  ViewController.m
//  ICWaveProgressView
//
//  Created by xiongan on 2017/11/18.
//  Copyright © 2017年 xiongan. All rights reserved.
//

#import "ViewController.h"
#import "ICWaveProgressView.h"

@interface ViewController ()
@property (nonatomic,strong)ICWaveProgressView *progressView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ICWaveProgressView *progressView = [[ICWaveProgressView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    progressView.center = self.view.center;
    progressView.progress = 0.1;
    progressView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:progressView];
    _progressView = progressView;
    [self changeProgress];
}
- (void)changeProgress {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.progressView.progress >0 && self.progressView.progress < 1) {
            self.progressView.progress += 0.01;
            [self changeProgress];
        }
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
