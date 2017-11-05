//
//  TabBarVCDelegate.m
//  CustomScrollTabBarController_OC_Demo
//
//  Created by chao on 2017/11/5.
//

#import "TabBarVCDelegate.h"
#import "SlideAnimationController.h"

@implementation TabBarVCDelegate

- (instancetype)init {
    if (self = [super init]) {
        _interactive = false;
        _interactionController = [[UIPercentDrivenInteractiveTransition alloc] init];
    }
    return self;
}

#pragma mark - UITabBarControllerDelegate
- (id<UIViewControllerAnimatedTransitioning>)tabBarController:(UITabBarController *)tabBarController animationControllerForTransitionFromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    NSInteger fromIndex = [tabBarController.viewControllers indexOfObject:fromVC];
    NSInteger toIndex = [tabBarController.viewControllers indexOfObject:toVC];
    
    TabOperationDirection direction = toIndex < fromIndex? TabOperationDirectionLeft : TabOperationDirectionRight;
    return [[SlideAnimationController alloc] initWithOperationDirection:direction];
}

- (id<UIViewControllerInteractiveTransitioning>)tabBarController:(UITabBarController *)tabBarController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    return _interactive? self.interactionController : nil;
}

@end
