//
//  TabBarVCDelegate.h
//  CustomScrollTabBarController_OC_Demo
//
//  Created by chao on 2017/11/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TabBarVCDelegate : NSObject <UITabBarControllerDelegate>

@property (nonatomic, assign) BOOL interactive;// 是否交互，用于标识

@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactionController;// 交互控制器

@end

NS_ASSUME_NONNULL_END
