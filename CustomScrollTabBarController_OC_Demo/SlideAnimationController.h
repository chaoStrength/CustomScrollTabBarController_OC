//
//  SlideAnimationController.h
//  CustomScrollTabBarController_OC_Demo
//
//  Created by chao on 2017/11/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 切换tab的方向
typedef NS_ENUM(NSInteger, TabOperationDirection) {
    TabOperationDirectionLeft = 0,
    TabOperationDirectionRight = 1
};

@interface SlideAnimationController : NSObject <UIViewControllerAnimatedTransitioning>

/**
 * 初始化
 * @param direction 方向
 */
- (instancetype)initWithOperationDirection:(TabOperationDirection)direction;

@end

NS_ASSUME_NONNULL_END
