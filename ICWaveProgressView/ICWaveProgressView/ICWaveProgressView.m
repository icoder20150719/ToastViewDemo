//
//  ICWaveProgressView.m
//  LayerDemo
//
//  Created by xiongan on 2017/11/18.
//  Copyright © 2017年 xiongan. All rights reserved.
//

#define DefaultFrontWaveColor [UIColor colorWithRed:34/255.0 green:116/255.0 blue:210/255.0 alpha:1]
#define DefaultBackWaveColor [UIColor colorWithRed:34/255.0 green:116/255.0 blue:210/255.0 alpha:0.3]
#import "ICWaveProgressView.h"
@interface ICWaveProgressView ()
@property (nonatomic,assign)CGFloat yHeight;
@property (nonatomic,assign)CGFloat offset;
@property (nonatomic,assign)BOOL start;
@property (nonatomic,strong)CAShapeLayer *frontWaveLayer;
@property (nonatomic,strong)CAShapeLayer *backWaveLayer;

@end
@implementation ICWaveProgressView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = MIN(frame.size.width, frame.size.height) * 0.5;
        self.layer.masksToBounds = YES;
        self.layer.borderColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:248/255.0 alpha:1].CGColor;
        self.layer.borderWidth = 5.0f;
        self.frontWaveLayer.fillColor = DefaultFrontWaveColor.CGColor;
        self.backWaveLayer.fillColor = DefaultBackWaveColor.CGColor;
        self.waveHeight = 5.0;
        self.yHeight = self.bounds.size.height;
        self.speed=1.0;
        [self.layer addSublayer:self.frontWaveLayer];
        if (!self.isShowSingleWave) {
            [self.layer addSublayer:self.backWaveLayer];
        }
        [self addSubview:self.progressLabel];
    }
    return self;
}
-(CAShapeLayer *)frontWaveLayer {
    if (!_frontWaveLayer) {
        _frontWaveLayer = [CAShapeLayer layer];
        _frontWaveLayer.bounds = self.bounds;
        _frontWaveLayer.anchorPoint = CGPointZero;
        _frontWaveLayer.position = CGPointMake(0, 0);
        _frontWaveLayer.path = [self frontLayerPath];
    }
    return _frontWaveLayer;
}

-(CAShapeLayer *)backWaveLayer{
    if (!_backWaveLayer) {
        _backWaveLayer = [CAShapeLayer layer];
        _backWaveLayer.bounds = self.bounds;
        _backWaveLayer.position = CGPointMake(0, 0);
        _backWaveLayer.anchorPoint = CGPointZero;
        _backWaveLayer.path = [self backLayerPath];
    }
    return _backWaveLayer;
}
- (CGPathRef)frontLayerPath {
    
    CGFloat w = self.bounds.size.width;
    CGFloat h = self.bounds.size.height;
    UIBezierPath *bezierFristWave = [UIBezierPath bezierPath];
    CGFloat waveHeight = 5 ;
    CGMutablePathRef pathRef = CGPathCreateMutable();
    CGFloat startOffY = 0;
    CGFloat orignOffY = 0;
    CGPathMoveToPoint(pathRef, NULL, 0, startOffY);
    
    [bezierFristWave moveToPoint:CGPointMake(0, startOffY)];
    for (CGFloat i = 0.f; i <= w * 2; i++) {
        orignOffY = waveHeight * sinf(2 * M_PI /w * i) ;
        [bezierFristWave addLineToPoint:CGPointMake(i, orignOffY)];
    }
    [bezierFristWave addLineToPoint:CGPointMake(w * 2, orignOffY)];
    [bezierFristWave addLineToPoint:CGPointMake(w * 2, h)];
    [bezierFristWave addLineToPoint:CGPointMake(0, h)];
    [bezierFristWave addLineToPoint:CGPointMake(0, startOffY)];
    [bezierFristWave closePath];
    return bezierFristWave.CGPath;
}
- (CGPathRef)backLayerPath {
    
    CGFloat w = self.bounds.size.width;
    CGFloat h = self.bounds.size.height;
    UIBezierPath *bezierFristWave = [UIBezierPath bezierPath];
    CGFloat waveHeight = 5 ;
    CGMutablePathRef pathRef = CGPathCreateMutable();
    CGFloat startOffY = 0.0;
    CGFloat orignOffY = 0.0;
    CGPathMoveToPoint(pathRef, NULL, 0, startOffY);
    
    [bezierFristWave moveToPoint:CGPointMake(0, startOffY)];
    for (CGFloat i = 0.f; i <= w * 2; i++) {
        orignOffY = waveHeight * cosf(2 * M_PI /w * i) ;
        [bezierFristWave addLineToPoint:CGPointMake(i, orignOffY)];
    }
    [bezierFristWave addLineToPoint:CGPointMake(w * 2, orignOffY)];
    [bezierFristWave addLineToPoint:CGPointMake(w * 2, h)];
    [bezierFristWave addLineToPoint:CGPointMake(0, h)];
    [bezierFristWave addLineToPoint:CGPointMake(0, startOffY)];
    [bezierFristWave closePath];
    return bezierFristWave.CGPath;
}
-(UILabel *)progressLabel {
    if (!_progressLabel) {
        _progressLabel=[[UILabel alloc] init];
        _progressLabel.text=@"";
        _progressLabel.frame=CGRectMake(0, 0, self.bounds.size.width, 30);
        _progressLabel.center = self.center;
        _progressLabel.font=[UIFont systemFontOfSize:18];
        _progressLabel.textColor=[UIColor colorWithWhite:0 alpha:1];
        _progressLabel.textAlignment=1;
    }
    return _progressLabel;
   
}

-(void)setProgress:(CGFloat)progress {
    if(progress < 0 || progress >1){
        return;
    }
    _progress = progress;
    self.progressLabel.text = [NSString stringWithFormat:@"%ld%%",[[NSNumber numberWithFloat:progress * 100] integerValue]];
    self.progressLabel.textColor = [UIColor colorWithWhite:progress*1.8 alpha:1];
    self.yHeight = self.bounds.size.height * (1 - progress);
    if (self.firstWaveColor.CGColor) {
        self.frontWaveLayer.fillColor = self.firstWaveColor.CGColor;
    }
    if (self.secondWaveColor.CGColor) {
        self.backWaveLayer.fillColor = self.secondWaveColor.CGColor;
    }
    [self.frontWaveLayer setValue:@(self.yHeight) forKeyPath:@"position.y"];
    [self.backWaveLayer setValue:@(self.yHeight) forKeyPath:@"position.y"];
    if (!self.start) {
        [self startWaveAnimation];
    }
}
#pragma mark -- 开始波动动画
- (void)startWaveAnimation {
    self.start = YES;

    [self waveAnimationForCoreAnimation];
}
- (void)waveAnimationForCoreAnimation {
    CGFloat w = self.bounds.size.width;
    // 说明这个动画对象要对CALayer的position属性执行动画
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    anim.duration = 2 / self.speed;
    anim.fromValue = @(0);
    anim.toValue =@(-w);
    anim.repeatCount = MAXFLOAT;
    anim.fillMode = kCAFillModeForwards;
    [self.frontWaveLayer addAnimation:anim forKey:@"translation.x"];
    //第二个波纹
    if (!self.isShowSingleWave) {
        [self.backWaveLayer addAnimation:anim forKey:@"translate"];
    }
}
-(void)dealloc {
    if (_frontWaveLayer) {
        [_frontWaveLayer removeFromSuperlayer];
        _frontWaveLayer = nil;
    }
    
    if (_backWaveLayer) {
        [_backWaveLayer removeFromSuperlayer];
        _backWaveLayer = nil;
    }
}

@end
