//
//  MSGImageBrowerVc.h
//  MSGImageBrower
//
//  Created by xiongan on 16/11/15.
//  Copyright © 2016年 承道. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSGImageBrowerVc : UIViewController
@property (nonatomic,strong) NSArray *browerImages;
@property (nonatomic,assign)NSInteger currentIndex;
@property (nonatomic,assign)CGRect sourceFrame;
@property (nonatomic,weak)UIImage *sourceImage;

- (void)show;
@end
