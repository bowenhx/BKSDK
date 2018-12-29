/**
 -  BKMenuViewController.h
 -  BKSDK
 -  Created by HY on 16/12/29.
 -  Copyright © 2016年 BaByKingdom. All rights reserved.
 -  适用于当前页面多个view滑动切换效果。

 #使用方法：
 
    - (void)viewDidLoad {
        [super viewDidLoad];
 
        //第一步：初始化BKMenuViewController，把其加入当前控制器view中
        BKMenuViewController *menuVc=[[BKMenuViewController alloc]init];
        //menuVc.isCloseSwipeGesture = YES;                 //可选择是否关闭页面滑动切换手势
        //menuVc.btnSelectColor = [UIColor yellowColor];    //可自定义选中颜色
        menuVc.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [self.view addSubview:menuVc];
        self.menuVc=menuVc;
 
        //第二步：设置BKMenuViewController的代理
        self.menuVc.delegate=self;
 
        //第三步： 开始BKMenuViewControllerUI绘制,必须实现！
        [self.menuVc setupBKMenuViewControllerUI];
        
        //设置顶部view的title
        [self setupSingleButton];
 
        //初次进入页面，默认显示第一个view，如果需要显示非第一个view，这里要设置一下
        [self.menuVc btnHeadClickType:self.menuVc.topViewSecondbtn];
    }
     

    //单个设置(可选),可以在这里单独设置title ： 通过menuVc找到对应的单个顶部button，从左到右如,topViewFirstbtn，topViewSecondbtn,topViewThirdbtn,以此类推;

    -(void)setupSingleButton{
        //  优先级最高
        self.menuVc.topViewFirstbtn.labName.text=@"我是第一个";
        self.menuVc.topViewSecondbtn.labName.text=@"欢迎第二个";
        self.menuVc.topViewThirdbtn.labName.text=@"第三个";
    }

 
    #pragma mark - BKMenuViewControllerDelegate
    #warning 只要一步且必须实现：传入您的各种控制器，用可变数组封装传入，就会动态的生成，默认最多能传入九个控制器
    //初始化设置
    -(NSMutableArray *)totalControllerInBKMenuViewController:(BKMenuViewController *)menuVc{
        NSMutableArray *controllerMutableArr=[NSMutableArray array];
        //第一种：初始化方式
        [controllerMutableArr addObject:[[OneTableViewController alloc]init]];
        
        //或者：第二种：初始化方式
        TwoTableViewController *mine2= [[TwoTableViewController alloc]init];
        mine2.title=@"欢迎第二个";
        [controllerMutableArr addObject:mine2];
        
        ThreeTableViewController *mine= [[ThreeTableViewController alloc]init];
        mine.title=@"";
        [controllerMutableArr addObject:mine];
        
        return controllerMutableArr;
    }
 */

#import <UIKit/UIKit.h>
#import "BKMenuSelectButton.h"
@class BKMenuViewController;

typedef enum : NSUInteger {
    Fade = 1,                   //淡入淡出
    Push,                       //推挤
    Reveal,                     //揭开
    MoveIn,                     //覆盖
    Cube,                       //立方体
    SuckEffect,                 //吮吸
    OglFlip,                    //翻转
    RippleEffect,               //波纹
    PageCurl,                   //翻页
    PageUnCurl,                 //反翻页
    CameraIrisHollowOpen,       //开镜头
    CameraIrisHollowClose,      //关镜头
    CurlDown,                   //下翻页
    CurlUp,                     //上翻页
    FlipFromLeft,               //左翻转
    FlipFromRight,              //右翻转
    
} AnimationType;


@protocol BKMenuViewControllerDelegate <NSObject>

@required

/**
 *  只要一步：传入您各种的控制器，用可变数组封装传入，就会动态的生成选择按钮，默认最大为九个
 *
 *  @param menuVc 当前的滑动viewController
 *
 *  @return 返回封装您的控制器的可变数组
 */
-(NSMutableArray *)totalControllerInBKMenuViewController:(BKMenuViewController *)menuVc;

@end


@interface BKMenuViewController : UIView

@property (nonatomic, weak) id<BKMenuViewControllerDelegate> delegate;
@property (nonatomic ,retain) UIColor *btnSelectColor;  //按钮选中状态下的颜色
@property (nonatomic ,retain) UIColor *btnUnSelectColor;//按钮在非选中状态下的颜色
@property (nonatomic ,strong) BKMenuSelectButton *topViewFirstbtn;
@property (nonatomic ,strong) BKMenuSelectButton *topViewSecondbtn;
@property (nonatomic ,strong) BKMenuSelectButton *topViewThirdbtn;
@property (nonatomic ,strong) BKMenuSelectButton *topViewFourthbtn;
@property (nonatomic ,strong) BKMenuSelectButton *topViewFifthbtn;
@property (nonatomic ,strong) BKMenuSelectButton *topViewSixthbtn;
@property (nonatomic ,strong) BKMenuSelectButton *topViewSeventhbtn;
@property (nonatomic ,strong) BKMenuSelectButton *topViewEighthbtn;
@property (nonatomic ,strong) BKMenuSelectButton *topViewNinthbtn;

//页面切换的动画效果
@property (nonatomic, assign) AnimationType animationType;
//是否关闭页面切换动画
@property (nonatomic, assign) BOOL          isCloseAnimation;
//底部滑块
@property (nonatomic ,strong) UIView        *viewUnder;
//设置topView圆角
@property (nonatomic, assign) CGFloat       topViewCornerRadius;
//设置动画时间
@property (nonatomic, assign) float         speedTime;
//关闭左右手势滑动功能
@property (nonatomic, assign) BOOL          isCloseSwipeGesture;


/**
 *  开始BKMenuViewControllerUI绘制,必须实现！
 */
-(void)setupBKMenuViewControllerUI;


/**
 *  点击按钮事件，默认点击第一个，如果进入页面点击的非第一个按钮，可在外部调用该方法
 *  @param btn 点击的按钮
 */
-(void)btnHeadClickType:(BKMenuSelectButton *)btn;


@end

