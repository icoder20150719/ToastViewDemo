//
//  ViewController.m
//  ToastView
//
//  Created by xiongan on 2017/11/22.
//  Copyright © 2017年 xiongan. All rights reserved.
//

#import "ViewController.h"
#import "XKSToastView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    XKSToastView *view = [[XKSToastView alloc]initWithTitle:@"宝盾保护中"];
    view.frame = CGRectMake(0 , 0, 200, 200);
    view.center = (CGPoint){self.view.center.x ,self.view.center.y-100};
    [self.view addSubview:view];
    
    
    XKSToastView *view1 = [[XKSToastView alloc]initWithTitle:@"宝盾保护中"];
    view1.frame = CGRectMake(0 , 0, 200, 200);
    view1.center = (CGPoint){self.view.center.x ,self.view.center.y+200};
    [self.view addSubview:view1];
    
    
    XKSToastView *view2 = [[XKSToastView alloc]initWithTitle:@"宝盾保护中"];
    view2.frame = CGRectMake(0 , 0, 200, 200);
    view2.center = (CGPoint){self.view.center.x-220 ,self.view.center.y+200};
    [self.view addSubview:view2];
    
    
    XKSToastView *view3 = [[XKSToastView alloc]initWithTitle:@"宝盾保护中"];
    view3.frame = CGRectMake(0 , 0, 200, 200);
    view3.center = (CGPoint){self.view.center.x-220 ,self.view.center.y-100};
    [self.view addSubview:view3];
    
    
    XKSToastView *view4 = [[XKSToastView alloc]initWithTitle:@"宝盾保护中"];
    view4.frame = CGRectMake(0 , 0, 200, 200);
    view4.center = (CGPoint){self.view.center.x+220 ,self.view.center.y-100};
    [self.view addSubview:view4];
    
    XKSToastView *view5 = [[XKSToastView alloc]initWithTitle:@"宝盾保护中"];
    view5.frame = CGRectMake(0 , 0, 200, 200);
    view5.center = (CGPoint){self.view.center.x+220 ,self.view.center.y+200};
    [self.view addSubview:view5];
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
