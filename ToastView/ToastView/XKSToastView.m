//
//  XKSToastView.m
//  ToastView
//
//  Created by xiongan on 2017/11/22.
//  Copyright © 2017年 xiongan. All rights reserved.
//

#import "XKSToastView.h"

@interface XKSToastView ()

@property (nonatomic ,weak)CAShapeLayer *logoLayer;
@property (nonatomic ,weak)CALayer *replicatorLayer;
@property (nonatomic ,weak)UILabel *titleLable;
@property (nonatomic ,weak)UIView *animationContentView;

@end

@implementation XKSToastView


- (instancetype)initWithTitle:(NSString *)title {
    if(self = [super init]){
        self.title = title;
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        [self setup];
    }
    return self;
}
- (void)setup {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [self.layer addSublayer:shapeLayer];
    self.logoLayer.bounds = CGRectMake(0, 0, 100, 100);
    _logoLayer = shapeLayer;
    [self logoDraw];
    
    UILabel *titleLable = [UILabel new];
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.backgroundColor = [UIColor clearColor];
    titleLable.textColor = [UIColor whiteColor];
    titleLable.font = [UIFont boldSystemFontOfSize:22];
    titleLable.text = self.title;
    [self addSubview:titleLable];
    _titleLable = titleLable;
    
    UIView *contentView = [UIView new];
    [self addSubview:contentView];
    _animationContentView = contentView;
    _replicatorLayer =  [self replicatorLayer_Wave];
    [self.layer addSublayer:self.replicatorLayer];
}

-(void)logoDraw {
    CGFloat outSideRadius = 40;
    CGFloat margin = 8;
    //1、创建动画贝塞尔路径
    //外圆
    CGPoint outSideCenter = self.center;
    CGFloat outSideRadiusHalf = outSideRadius / 2;
    CGPoint leftCenter = (CGPoint){outSideCenter.x - outSideRadiusHalf,outSideCenter.y};
    CGPoint rightCenter = (CGPoint){outSideCenter.x + outSideRadiusHalf,outSideCenter.y};
    
    CGFloat smallRadius = outSideRadiusHalf - margin/2.0;
    CGFloat bigRadius = outSideRadiusHalf + margin/2.0;
    
    CGFloat litterRadius = margin / 2;
    CGPoint rbLitterCenter = (CGPoint){outSideCenter.x+outSideRadiusHalf,outSideCenter.y+outSideRadiusHalf};
    CGPoint ltLitterCenter = (CGPoint){outSideCenter.x-outSideRadiusHalf,outSideCenter.y-outSideRadiusHalf};
    CGPoint lbrLitterCenter = (CGPoint){leftCenter.x+ sqrt(outSideRadiusHalf*outSideRadiusHalf/2) ,leftCenter.y+sqrt(outSideRadiusHalf*outSideRadiusHalf/2)};
    
    CGPoint lblLitterCenter = (CGPoint){leftCenter.x,leftCenter.y+outSideRadiusHalf};
    CGPoint rtlLitterCenter = (CGPoint){rightCenter.x- sqrt(outSideRadiusHalf*outSideRadiusHalf/2) ,leftCenter.y-sqrt(outSideRadiusHalf*outSideRadiusHalf/2)};
    
    CGPoint rtrLitterCenter = (CGPoint){rightCenter.x,leftCenter.y-outSideRadiusHalf};
    
    UIBezierPath *bigCriclePath = [UIBezierPath bezierPathWithArcCenter:outSideCenter radius:outSideRadius startAngle:0 endAngle:-2*M_PI clockwise:NO];
    
    UIBezierPath *innerPath = [UIBezierPath bezierPath];
    [innerPath addArcWithCenter:leftCenter radius:smallRadius startAngle:-M_PI_2 endAngle:0 clockwise:YES];
    
    [innerPath addArcWithCenter:rightCenter radius:bigRadius startAngle:-M_PI endAngle:-M_PI-M_PI_2 clockwise:NO];
    
    [innerPath addArcWithCenter:rbLitterCenter radius:litterRadius startAngle:M_PI_2 endAngle:-M_PI_2 clockwise:NO];
    
    [innerPath addArcWithCenter:rightCenter radius:smallRadius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
    
    [innerPath addArcWithCenter:leftCenter radius:bigRadius startAngle:0 endAngle:-M_PI_2 clockwise:NO];
    
    [innerPath addArcWithCenter:ltLitterCenter radius:litterRadius startAngle:-M_PI_2 endAngle:M_PI_2 clockwise:NO];
    
    //左下角和右上角的形状
    //左下角
    UIBezierPath *leftBottomBigCriclePath = [UIBezierPath bezierPathWithArcCenter:leftCenter radius:bigRadius startAngle:M_PI_2 endAngle:M_PI_4 clockwise:NO];
    [leftBottomBigCriclePath addArcWithCenter:lbrLitterCenter radius:litterRadius startAngle:M_PI_4 endAngle:-M_PI_2-M_PI_4 clockwise:NO];
    [leftBottomBigCriclePath addArcWithCenter:leftCenter radius:smallRadius startAngle:M_PI_4 endAngle:M_PI_2 clockwise:YES];
    [leftBottomBigCriclePath addArcWithCenter:lblLitterCenter radius:litterRadius startAngle: M_PI+M_PI_2 endAngle:M_PI_2 clockwise:NO];
    //右上角
    UIBezierPath *rightTopBigCriclePath = [UIBezierPath bezierPathWithArcCenter:rightCenter radius:bigRadius startAngle:-M_PI_2-M_PI_4 endAngle:-M_PI_2 clockwise:YES];
    
    [rightTopBigCriclePath addArcWithCenter:rtrLitterCenter radius:litterRadius startAngle:-M_PI_2 endAngle:M_PI_2 clockwise:YES];
    [rightTopBigCriclePath addArcWithCenter:rightCenter radius:smallRadius startAngle:-M_PI_2 endAngle:-M_PI_2-M_PI_4 clockwise:NO];
    [rightTopBigCriclePath addArcWithCenter:rtlLitterCenter radius:litterRadius startAngle:M_PI_4 endAngle:M_PI+M_PI_4  clockwise:YES];
    
    
    CAShapeLayer *outsideLayer = [self shapeLayerWithPath:bigCriclePath ];
    CAShapeLayer *innerLayer = [self shapeLayerWithPath:innerPath ];
    innerLayer.fillColor = [UIColor whiteColor].CGColor;
    innerLayer.strokeColor = [UIColor blackColor].CGColor;
    CAShapeLayer *leftBottomLayer = [self shapeLayerWithPath:leftBottomBigCriclePath ];
    leftBottomLayer.fillColor = [UIColor whiteColor].CGColor;
    leftBottomLayer.strokeColor = [UIColor blackColor].CGColor;
    CAShapeLayer *rightTopLayer = [self shapeLayerWithPath:rightTopBigCriclePath ];
    rightTopLayer.fillColor = [UIColor whiteColor].CGColor;
    rightTopLayer.strokeColor = [UIColor blackColor].CGColor;
    [self.logoLayer addSublayer:outsideLayer];
    [outsideLayer addSublayer:innerLayer];
    [outsideLayer addSublayer:leftBottomLayer];
    [outsideLayer addSublayer:rightTopLayer];
    
}

- (CAShapeLayer *)shapeLayerWithPath:(UIBezierPath *)path{
    
    CAShapeLayer *layer = [[CAShapeLayer alloc]init];
    layer.path = path.CGPath;
    layer.frame = self.logoLayer.bounds;
    layer.strokeColor = [UIColor whiteColor].CGColor ;//边沿线色
    layer.fillColor = [UIColor blackColor].CGColor ;//填充色
    layer.lineJoin = kCALineJoinMiter;//线拐点的类型
    layer.lineCap = kCALineCapSquare;//线终点
    //线条宽度
    layer.lineWidth = 2;
    //起始和终止
    layer.strokeStart = 0.0;
    layer.strokeEnd = 1.0;
    return layer;
}
- (CABasicAnimation *)hiddenAnimation {
    //opacity
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"fillColor"];
    animation.fromValue = (__bridge id _Nullable)[UIColor colorWithWhite:0.2 alpha:1].CGColor;
    animation.toValue =(__bridge id _Nullable)[UIColor colorWithWhite:1 alpha:1].CGColor;
    animation.repeatCount = MAXFLOAT;
    animation.fillMode = kCAFillModeForwards;
//    animation.removedOnCompletion = YES;
    animation.duration = 0.6;
    return  animation;
}

- (CALayer *)replicatorLayer_Wave{
    CGFloat radius = 10;
    CAShapeLayer *shape = [CAShapeLayer layer];
    shape.frame = CGRectMake(0,0, radius, radius);
    shape.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, radius, radius)].CGPath;
    shape.fillColor = [UIColor colorWithWhite:0.2 alpha:1].CGColor;
    [shape addAnimation:[self hiddenAnimation] forKey:@"scaleAnimation"];
    
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    replicatorLayer.bounds = CGRectMake(0, 0, 80, 20);
    replicatorLayer.instanceDelay = 0.2;
    replicatorLayer.instanceCount = 3;
//    replicatorLayer.backgroundColor = [UIColor redColor].CGColor;
    replicatorLayer.instanceTransform = CATransform3DMakeTranslation(35,0,0);
    [replicatorLayer addSublayer:shape];
    return replicatorLayer;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    
    self.logoLayer.position = CGPointMake(self.frame.size.width * 0.5, 55);
    self.replicatorLayer.position = CGPointMake(self.frame.size.width * 0.5, 170);
    self.titleLable.frame = CGRectMake(10, 120, self.frame.size.width - 20, 20);
    
    
    
}
@end













