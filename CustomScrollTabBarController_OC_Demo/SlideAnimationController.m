//
//  SlideAnimationController.m
//  CustomScrollTabBarController_OC_Demo
//
//  Created by chao on 2017/11/5.
//

#import "SlideAnimationController.h"

@interface SlideAnimationController ()

@property (nonatomic, assign) TabOperationDirection direction;

@end

@implementation SlideAnimationController

/**
 * 初始化
 * @param direction 方向
 */
- (instancetype)initWithOperationDirection:(TabOperationDirection)direction {
    if (self = [super init]) {
        _direction = direction;
    }
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.3;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    // 从转场环境transitionContext中获取容器视图
    UIView *containerView = transitionContext.containerView;
    
    // 获取fromVC和toVC
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    if (!fromVC || !toVC) {
        return;
    }
    
    // 获取fromView和toView
    UIView *fromView = fromVC.view;
    UIView *toView = toVC.view;
    
    // 将toView添加到容器视图上
    [containerView addSubview:toView];
    
    // 根据转场类型(push或pop)计算偏移量
    CGFloat translation = containerView.frame.size.width;
    if (_direction == TabOperationDirectionRight) {
        translation = -translation;
    }
    // 计算toView和fromView的偏移变换矩阵
    CGAffineTransform toViewTransform = CGAffineTransformMakeTranslation(-translation, 0.0);
    CGAffineTransform fromViewTransform = CGAffineTransformMakeTranslation(translation, 0.0);
    
    // 设置toView的初始位置
    toView.transform = toViewTransform;
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        // 设置toView和fromView动画的目标位置
        fromView.transform = fromViewTransform;
        toView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        fromView.transform = CGAffineTransformIdentity;
        toView.transform = CGAffineTransformIdentity;
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}

@end
