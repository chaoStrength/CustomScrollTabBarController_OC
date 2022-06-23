//
//  ScrollTabBarController.m
//  CustomScrollTabBarController_OC_Demo
//
//  Created by chao on 2017/11/5.
//

#import "ScrollTabBarController.h"
#import "WeChatViewController.h"
#import "ContactsViewController.h"
#import "DiscoverViewController.h"
#import "MeViewController.h"
#import "TabBarVCDelegate.h"

@interface ScrollTabBarController ()

@property (nonatomic, strong) NSArray<NSString *> *itemNames; // itme的名字数组
@property (nonatomic, strong) NSArray<NSString *> *imageNames;// 图片名字数组
@property (nonatomic, strong) NSArray<NSString *> *vcNames;   // 视图控制器名字数组
@property (nonatomic, strong) NSDictionary *normalAttribute;  // 普通状态属性字典
@property (nonatomic, strong) NSDictionary *selectedAttribute;// 选择状态属性字典

@property (nonatomic, strong) TabBarVCDelegate *tabBarVCDelegate;// 转场代理，主要为了保持强引用

@end

@implementation ScrollTabBarController

- (instancetype)init {
    if (self = [super init]) {
        _vcNames = @[@"WeChatViewController", @"ContactsViewController", @"DiscoverViewController", @"MeViewController"];
        _itemNames = @[@"WeChat", @"Contacts", @"Discover", @"Me"];
        _imageNames = @[@"tabbar_wechat_", @"tabbar_contacts_", @"tabbar_discover_", @"tabbar_me_"];
        UIColor *nromalColor = [UIColor colorWithRed:146 / 255.0 green:146 / 255.0 blue:146 / 255.0 alpha:1.0];
        UIColor *selectedColor = [UIColor colorWithRed:31 / 255.0 green:185 / 255.0 blue:34 / 255.0 alpha:1.0];
        _normalAttribute = @{NSFontAttributeName:[UIFont systemFontOfSize:10.0], NSForegroundColorAttributeName:nromalColor};
        _selectedAttribute = @{NSFontAttributeName:[UIFont systemFontOfSize:10.0], NSForegroundColorAttributeName:selectedColor};
        
        // 创建视图控制器
        [self setupViewControllers];
        
        // 创建转场代理，为了保持强引用，因此创建了一个属性持有该代理
        _tabBarVCDelegate = [[TabBarVCDelegate alloc] init];
        // 设置当前控制器的代理为我们自己定义的专场代理
        self.delegate = _tabBarVCDelegate;
        
        // 为当前控制器的view添加平移手势
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
        [self.view addGestureRecognizer:panGesture];
    }
    return self;
}

/**
 *  创建视图控制器，即加载tab底部的4个视图控制器
 */
- (void)setupViewControllers {
    NSMutableArray<UIViewController *> *vcs = [[NSMutableArray alloc] init];
    for (int i = 0; i < _vcNames.count; ++i) {
        UIViewController *vc = [[NSClassFromString(_vcNames[i]) alloc] init];
        [vc.tabBarItem setTitle:_itemNames[i]];
        [vc.tabBarItem setTitleTextAttributes:_normalAttribute forState:UIControlStateNormal];
        [vc.tabBarItem setTitleTextAttributes:_selectedAttribute forState:UIControlStateSelected];
        [vc.tabBarItem setImage:[[UIImage imageNamed:[NSString stringWithFormat:@"%@normal", _imageNames[i]]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [vc.tabBarItem setSelectedImage:[[UIImage imageNamed:[NSString stringWithFormat:@"%@selected", _imageNames[i]]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [vcs addObject:vc];
    }
    // 设置tab底部的4个视图控制器
    [self setViewControllers:vcs];
    
    if (@available(iOS 13.0, *)) {
        [[UITabBar appearance] setTintColor:_selectedAttribute[NSForegroundColorAttributeName]];
        [[UITabBar appearance] setUnselectedItemTintColor:_normalAttribute[NSForegroundColorAttributeName]];
    }
    if (@available(iOS 15.0, *)) {
        UITabBarAppearance *appearance = [[UITabBarAppearance alloc] init];
        appearance.backgroundColor = UIColor.whiteColor;
        self.tabBar.scrollEdgeAppearance = appearance;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Action
- (void)panGestureRecognizer:(UIPanGestureRecognizer *)gesture {
    // 获取滑动的水平偏移量
    CGFloat translationX = fabs([gesture translationInView:gesture.view].x);
    // 计算完成的百分比
    CGFloat percent = translationX / self.view.bounds.size.width;
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            self.tabBarVCDelegate.interactive = true;
            CGFloat velocityX = [gesture velocityInView:self.view].x;
            // 如果自右往左滑动
            if (velocityX < 0.0) {
                if (self.selectedIndex < self.viewControllers.count - 1) {
                    self.selectedIndex += 1;
                }
            } else {
            // 否则，自左往右滑动
                if (self.selectedIndex > 0) {
                    self.selectedIndex -= 1;
                }
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            // 更新转场进度
            [self.tabBarVCDelegate.interactionController updateInteractiveTransition:percent];
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded: {
            if (percent > 0.15) {
                self.tabBarVCDelegate.interactionController.completionSpeed = 0.99;
                [self.tabBarVCDelegate.interactionController finishInteractiveTransition];
            } else {
                self.tabBarVCDelegate.interactionController.completionSpeed = 0.99;
                [self.tabBarVCDelegate.interactionController cancelInteractiveTransition];
            }
            self.tabBarVCDelegate.interactive = false;
            break;
        }
        default:
            break;
    }
}

@end
