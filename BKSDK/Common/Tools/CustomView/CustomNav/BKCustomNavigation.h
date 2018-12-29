/**
 -  BKCustomNavigation.h
 -  BKSDK
 -  Created by HY on 16/12/22.
 -  Copyright © 2016年 BaByKingdom. All rights reserved.
 -  自定义的导航条view，可实现多种样式，支持nav左右两边显示一个或者两个按钮的情况
 
 使用示例：
        CustomNavigation *nav = [[CustomNavigation alloc] initWithNavThree:@"首页"
                                                                   bgColor:CustomNavBgColor
                                                              leftBtnImage:nil
                                                              leftBtnTitle:@"左边按钮"
                                                             rigthBtnTitle:@"右边按钮"
                                                             rightBtnImage:nil
                                                                 leftBlock:^{
                                                                     NSLog(@"left");
                                                                 }
                                                                rightBlock:^{
                                                                    NSLog(@"right");
                                                                }];
        [self.view addSubview:nav];

 */


#import <UIKit/UIKit.h>
#import "UIView+TapBlock.h"

//导航条背景颜色
#define CustomNavBgColor      [UIColor colorWithRed:96/255.0 green:204/255.0 blue:215/255.0 alpha:1]

//导航条左边返回按钮图片
#define CustomNavBarBackImage [UIImage imageNamed:@"nav_back"]

typedef void(^ItemBlock)(void);

@class BKCustomNavigation;

@interface BKCustomNavigation : UIView


/**
 *  在导航栏上添加一个分割线view
 */
- (void)addBottomLineView;


/**
 *  CustomTabBar leftItem
 */
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *leftBtn2;


/**
 *  CustomTabBar rightItem
 */
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIButton *rightBtn2;


/**
 *  CustomTabBar title
 */
@property (nonatomic, strong) UILabel *titleLabel;


/**
 *  增大 item 的可触控范围 View
 */
@property (nonatomic, strong) UIView *clearView_left;
@property (nonatomic, strong) UIView *clearView_left2;


/**
 *  增大 item 的可触控范围 View
 */
@property (nonatomic, strong) UIView *clearView_right;
@property (nonatomic, strong) UIView *clearView_right2;


/**
 *  左边 button 的 title
 */
@property (nonatomic, strong) UILabel *leftLabel;


/**
 *  右边 button 的 title
 */
@property (nonatomic, strong) UILabel *rightLabel;


/**
 *  1:自定义导航栏 左边一个图片，右边一个文字
 *
 *  @param  title        导航条中间标题
 *  @param  bgColor      导航条背景色
 *  @param  leftImage    左边图片
 *  @param  rightTitle   右边文字
 *  @param  leftBlock    leftItem click Block
 *  @param  rightBlock   rightItem click Block
 *
 *  @return 自定义的导航条view，左边一个图片，右边一个文字
 */
- (instancetype)initWithNavOne:(NSString *)title bgColor:(UIColor *)bgColor leftBtnImage:(UIImage *)leftImage rightBtnTitle:(NSString *)rightTitle leftBlock:(ItemBlock)leftBlock rightBlock:(ItemBlock)rightBlock;


/**
 *  2:自定义导航栏 左右两边边都是一个图片按钮
 *
 *  @param  title        导航条中间标题
 *  @param  bgColor      导航条背景色
 *  @param  leftImage    左边图片
 *  @param  rightImage   右边图片
 *  @param  leftBlock    leftItem click Block
 *  @param  rightBlock   rightItem click Block
 *
 *  @return 自定义的导航条view，左右两边边都是一个图片按钮
 */
- (instancetype)initWithNavTwo:(NSString *)title bgColor:(UIColor *)bgColor leftBtnImage:(UIImage *)leftImage rightBtnImage:(UIImage *)rightImage leftBlock:(ItemBlock)leftBlock rightBlock:(ItemBlock)rightBlock ;


/**
 *  3:自定义导航栏 左右两边都有一个按钮，并且可以设置文字和图片
 *
 *  @param title            导航条中间标题
 *  @param bgColor          导航条背景色
 *  @param leftImage        左边 button UIImage
 *  @param leftBtnTitle     左边 button title
 *  @param rightBtnTitle    右边 button title
 *  @param rightImage       右边 button UIImage
 *  @param leftBlock        leftItem click Block
 *  @param rightBlock       leftItem click Block
 *
 *  @return  自定义的导航条view
 */
- (instancetype)initWithNavThree:(NSString *)title bgColor:(UIColor *)bgColor leftBtnImage:(UIImage *)leftImage leftBtnTitle:(NSString *)leftBtnTitle  rigthBtnTitle:(NSString *)rightBtnTitle  rightBtnImage:(UIImage *)rightImage leftBlock:(ItemBlock)leftBlock rightBlock:(ItemBlock)rightBlock;


/**
 *  4:自定义导航栏 左边设置一个按钮，右边可以设置两个按钮
 *
 *  @param title            导航条中间标题
 *  @param bgColor          导航条背景色
 *  @param leftImage        左边图片
 *  @param rightImage2      右边图片
 *  @param rightBtnImage    右边图片
 *  @param leftBlock        左边 click Block
 *  @param rightBlock       右边 click Block
 *  @param rightBlock2      右边 click Block
 *
 *  @return  自定义的导航条view
 */
- (instancetype)initWithNavFour:(NSString *)title bgColor:(UIColor *)bgColor leftBtnImage:(UIImage *)leftImage  rightBtnImage2:(UIImage *)rightImage2 rightBtnImage:(UIImage *)rightBtnImage leftBlock:(ItemBlock)leftBlock  rightBlock2:(ItemBlock)rightBlock2 rightBlock:(ItemBlock)rightBlock;


/**
 *  5:自定义导航栏 左右两边都可设置两个按钮
 *
 *  @param title            导航条中间标题
 *  @param bgColor          导航条背景色
 *  @param leftImage        左边图片
 *  @param leftBtnImage2    左边图片
 *  @param rightImage2      右边图片
 *  @param rightBtnImage    右边图片
 *  @param leftBlock        左边 click Block
 *  @param leftBlock2       左边 click Block
 *  @param rightBlock2      右边 click Block
 *  @param rightBlock       右边 click Block
 *
 *  @return  自定义的导航条view
 */
- (instancetype)initWithNavFive:(NSString *)title bgColor:(UIColor *)bgColor leftBtnImage:(UIImage *)leftImage leftBtnImage2:(UIImage *)leftBtnImage2 rightBtnImage2:(UIImage *)rightImage2 rightBtnImage:(UIImage *)rightBtnImage leftBlock:(ItemBlock)leftBlock leftBlock2:(ItemBlock)leftBlock2 rightBlock2:(ItemBlock)rightBlock2 rightBlock:(ItemBlock)rightBlock;

@end
