//
//  ViewController.m
//  WaveAnimation
//
//  Created by ZK on 16/2/19.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import "ViewController.h"

#define kPulseAnimation @"kPulseAnimation"

@interface ViewController ()

@property (nonatomic, strong) UIButton *button;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:18 / 255.0 green:17 / 255.0 blue:35 / 255.0 alpha:1];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 85, 85)];
    button.backgroundColor = [UIColor colorWithRed:64 / 255.0 green:185 / 255.0 blue:216 / 255.0 alpha:1];
    button.center = self.view.center;
    button.layer.cornerRadius = button.bounds.size.width / 2;
    [button addTarget:self action:@selector(modifyAnimationStatus:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    self.button = button;
    
    [self waveAnimationLayerWithView:self.button diameter:160 duration:1.2];
    [self waveAnimationLayerWithView:self.button diameter:115 duration:1.2];
}

//diameter 扩散的大小
- (CALayer *)waveAnimationLayerWithView:(UIView *)view diameter:(CGFloat)diameter duration:(CGFloat)duration {
    CALayer *waveLayer = [CALayer layer];
    waveLayer.bounds = CGRectMake(0, 0, diameter, diameter);
    waveLayer.cornerRadius = diameter / 2; //设置圆角变为圆形
    waveLayer.position = view.center;
    waveLayer.backgroundColor = [[UIColor colorWithRed:64 / 255.0 green:185 / 255.0 blue:216 / 255.0 alpha:1] CGColor];
    [view.superview.layer insertSublayer:waveLayer below:view.layer];//把扩散层放到播放按钮下面
    
    CAAnimationGroup * animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = duration;
    animationGroup.repeatCount = INFINITY; //重复无限次
    animationGroup.removedOnCompletion = NO;
    
    CAMediaTimingFunction *defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    animationGroup.timingFunction = defaultCurve;
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
    scaleAnimation.fromValue = @0.7; //开始的大小
    scaleAnimation.toValue = @1.0; //最后的大小
    scaleAnimation.duration = duration;
    scaleAnimation.removedOnCompletion = NO;
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = @0.4; //开始的大小
    opacityAnimation.toValue = @0.0; //最后的大小
    opacityAnimation.duration = duration;
    opacityAnimation.removedOnCompletion = NO;
    
    animationGroup.animations = @[scaleAnimation, opacityAnimation];
    [waveLayer addAnimation:animationGroup forKey:kPulseAnimation];
    
    return waveLayer;
}

- (void)modifyAnimationStatus:(UIButton *)button {
    BOOL isAnimating = NO;
    NSArray *layerArr = [NSArray arrayWithArray:button.superview.layer.sublayers];
    
    for (CALayer *layer in layerArr) {
        if ([layer.animationKeys containsObject:kPulseAnimation]) {
            isAnimating = YES;
            [layer removeAllAnimations];
            [layer removeFromSuperlayer];
        }
    }
    
    if (!isAnimating) {
        [self waveAnimationLayerWithView:self.button diameter:160 duration:1.2];
        [self waveAnimationLayerWithView:self.button diameter:115 duration:1.2];
    }
}
















/**
 *  另一种波浪动画，供参考
 */

- (void)waveAnimation {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    button.backgroundColor = [UIColor redColor];
    button.center = self.view.center;
    button.layer.cornerRadius = 50;
    [self.view addSubview:button];
    
    /*--------------- 扩散动画 ---------------*/
    CALayer *spreadLayer = [CALayer layer];
    CGFloat diameter =60 * 3;  //扩散的大小
    spreadLayer.bounds = CGRectMake(0, 0, diameter, diameter);
    spreadLayer.cornerRadius =90; //设置圆角变为圆形
    spreadLayer.position =button.center;
    spreadLayer.backgroundColor = [[UIColor blueColor] CGColor];
    [self.view.layer insertSublayer:spreadLayer below:button.layer];//把扩散层放到播放按钮下面
    
    CAMediaTimingFunction *defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    CAAnimationGroup * animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = 3;
    animationGroup.repeatCount = INFINITY;//重复无限次
    animationGroup.removedOnCompletion =NO;
    animationGroup.timingFunction = defaultCurve;
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
    scaleAnimation.fromValue = @0.3;//开始的大小
    scaleAnimation.toValue = @1.0;//最后的大小
    scaleAnimation.duration = 3;
    
    CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.duration = 3;
    opacityAnimation.values = @[@0.4, @0.45,@0];
    opacityAnimation.keyTimes =@[@0, @0.2,@1];
    opacityAnimation.removedOnCompletion =NO;
    animationGroup.animations = @[scaleAnimation, opacityAnimation];
    [spreadLayer addAnimation:animationGroup forKey:@"pulse"];
}

@end
