//
//  XKSToastView.h
//  ToastView
//
//  Created by xiongan on 2017/11/22.
//  Copyright © 2017年 xiongan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XKSToastView : UIView

@property (nonatomic ,copy)NSString *title;

- (instancetype)initWithTitle:(NSString *)title;

@end
