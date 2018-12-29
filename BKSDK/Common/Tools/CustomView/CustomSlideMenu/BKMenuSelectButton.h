/**
 -  BKMenuSelectButton.h
 -  BKSDK
 -  Created by HY on 16/12/29.
 -  Copyright © 2016年 BaByKingdom. All rights reserved.
 -  多个页面滑动的页面，顶部按钮设置
 */

#import <UIKit/UIKit.h>

#define MENU_DEF_COLOR [UIColor redColor] //默认颜色，title字体颜色

@class BKMenuSelectButton;
@interface BKMenuSelectButton : UIButton

/*************   顶部button具有的公有属性   *****************
 *
 UILabel *labName;           button的文字
 UIColor *selectedColor;     button选中颜色
 UIColor *notSelectedColor   button未选中颜色
 * **********   顶部button具有的公有属性   ****************
 */

@property (nonatomic ,strong) UILabel *labName;
@property (nonatomic ,strong) UIColor *selectedColor;
@property (nonatomic ,strong) UIColor *notSelectedColor;


/**
 设置按钮被选中和非选中下的状态

 @param state Yes：选中状态，不可点击并附选中颜色  No：非选中状态
 */
-(void)setState:(BOOL)state;

@end
