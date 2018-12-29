/**
 -  BKMenuViewController.m
 -  BKSDK
 -  Created by HY on 16/12/29.
 -  Copyright © 2016年 BaByKingdom. All rights reserved.
 */

#define NavigationBar_HEIGHT 44
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kWidth(R) (R)*(kScreenWidth)/320
#define KDuration 0.3  //切换页面的时间,默认为0.3

#import "BKMenuSelectButton.h"
#import "BKMenuViewController.h"
static const CGFloat originalTopViewHeight=50;
static const CGFloat originalChildVcViewHeight=50;

@interface BKMenuViewController();
@property (nonatomic, assign) CGFloat                  topViewHeight;
@property (nonatomic, assign) CGFloat                  topViewWidth;
@property (nonatomic, assign) CGFloat                  topViewX;
@property (nonatomic, assign) CGFloat                  topViewY;

@property (nonatomic, assign) CGFloat                  childVcViewHeight;
@property (nonatomic, assign) CGFloat                  childVcViewWidth;
@property (nonatomic, assign) CGFloat                  childVcViewX;
@property (nonatomic, assign) CGFloat                  childVcViewY;

///装子控制器容器
@property (nonatomic ,weak  ) UIView                   *animationChangeView;
@property (nonatomic ,weak  ) UIViewController         *showVC;
@property (nonatomic ,strong) UIViewController         *contentVC;
@property (nonatomic, assign) int                      index;
@property (nonatomic, assign) NSInteger                newindex;
@property (nonatomic, assign) NSInteger                oldindex;
@property (nonatomic, assign) int                      titleIndex;
@property (nonatomic, assign) int                      titleCompareIndex;
@property (nonatomic, strong) NSMutableArray           *titleIndexArr;
@property (nonatomic, strong) NSMutableArray           *titleArr;
@property (nonatomic, assign) int                      btnIndex;

///顶部容器
@property (nonatomic, weak  ) UIView                   *viewTop;
@property (nonatomic, strong) UISwipeGestureRecognizer *recognizerLeft;
@property (nonatomic, strong) UISwipeGestureRecognizer *recognizerRight;

@end

typedef enum{
    BKMenuSelectButtonTypeHeadFirst,
    BKMenuSelectButtonTypeHeadSecond,
    BKMenuSelectButtonTypeHeadThird,
    BKMenuSelectButtonTypeHeadFourth,
    BKMenuSelectButtonTypeHeadFifth,
    BKMenuSelectButtonTypeHeadSixth,
    BKMenuSelectButtonTypeHeadSeventh,
    BKMenuSelectButtonTypeHeadEighth,
    BKMenuSelectButtonTypeHeadNinth
} BKMenuSelectButtonType;

@implementation BKMenuViewController

/**
 *  开始BKMenuViewControllerUI绘制,必须实现！
 */
-(void)setupBKMenuViewControllerUI{
    
    [self setupContentVC];
    [self setupChildViewController];
    [self setupbtnSelectIndex:0];//默认选择第一个按钮
}

#pragma mark - 设置frame
- (CGFloat)setupTopViewHeight {
    return originalTopViewHeight;
}

- (CGFloat)setupTopViewWidth {
    return self.frame.size.width;
}

- (CGFloat)setupTopViewX {
    return 0;
}

- (CGFloat)setupTopViewY {
    return 0;
}

- (CGFloat)setupChildVcViewHeight {
    return self.frame.size.height;
}

- (CGFloat)setupChildVcViewWidth {
    return self.frame.size.width;
}

- (CGFloat)setupChildVcViewX {
    return 0;
}

- (CGFloat)setupChildVcViewY {
    return  originalChildVcViewHeight;
}


#pragma mark - 初始化
- (NSMutableArray *)titleIndexArr {
    if (!_titleIndexArr) {
        _titleIndexArr=[NSMutableArray array];
    }
    return _titleIndexArr;
}

- (NSMutableArray *)titleArr {
    if (!_titleArr) {
        _titleArr=[NSMutableArray array];
    }
    return _titleArr;
}

/**
 *  只要一步：设置添加控制器，只用加添就进入主控制器，就会动态的生成选择按钮，默认最大为九个
 */
- (void)setupChildViewController {
    NSMutableArray *arr=  [self.delegate totalControllerInBKMenuViewController:self];
    
    for (UIViewController *vc in arr) {
        [self.contentVC addChildViewController:vc];
        if (vc.title) {
            NSString *eachTitle=vc.title;
            [self.titleArr addObject:eachTitle];
            [self.titleIndexArr addObject:[NSNumber numberWithInt:(self.titleIndex)]];
        }
        self.titleIndex++;
    }
    
    self.index=(int)self.contentVC.childViewControllers.count;
    [self setupContentView];
}

/**
 *  顶部选择按钮属性统一设置,默认
 *
 *    优先级小于单个设置
 */
- (void)setupAllBtnState:(BKMenuSelectButton *)btn {
    btn.labName.text=@"默认标题";
    btn.labName.font=[UIFont systemFontOfSize:14];
}

/**
 *  其他设置
 */
- (void)setupContentVC {
    UIViewController *contentVC=[[UIViewController alloc]init];
    [self addSubview:contentVC.view];
    self.contentVC=contentVC;
    self.contentVC.view.frame=CGRectMake(0, 0,self.frame.size.width, self.frame.size.height);
}

- (void)setupContentView {
    [self setupViewTopContent];
    [self setupEachBtnContent];
    [self setupViewUnderContent];
    [self setupContentViewContent];
}

- (void)setupViewTopContent {
    self.topViewHeight=[self setupTopViewHeight];
    self.topViewWidth = [self setupTopViewWidth];
    self.topViewX=[self setupTopViewX];
    self.topViewY=[self setupTopViewY];
    
    UIView *viewTop=[[UIView alloc]initWithFrame:CGRectMake(_topViewX, _topViewY, _topViewWidth, _topViewHeight)];
    viewTop.backgroundColor=[UIColor whiteColor];
    [self addSubview:viewTop];
    viewTop.layer.cornerRadius=self.topViewCornerRadius?self.topViewCornerRadius:0;
    self.viewTop=viewTop;
}

- (void)setupEachBtnContent {
    if (self.contentVC.childViewControllers.count>9) {
        return;
    } else {
        for (int i=0; i<self.contentVC.childViewControllers.count; i++) {
            switch (i) {
                case 0:
                {
                    BKMenuSelectButton *topViewFirstbtn=[[BKMenuSelectButton alloc]initWithFrame:CGRectMake(0,0, (_topViewWidth)/self.contentVC.childViewControllers.count, _topViewHeight)];
                    topViewFirstbtn.tag=BKMenuSelectButtonTypeHeadFirst;
                    topViewFirstbtn.selectedColor = self.btnSelectColor;
                    topViewFirstbtn.notSelectedColor = self.btnUnSelectColor;
                    self.topViewFirstbtn=topViewFirstbtn;
                    [self setupBtnContentState:self.topViewFirstbtn index:i];
                }
                    break;
                case 1:
                {
                    BKMenuSelectButton *topViewSecondbtn=[[BKMenuSelectButton alloc]initWithFrame:CGRectMake((_topViewWidth)/self.contentVC.childViewControllers.count*i,0, (_topViewWidth)/self.contentVC.childViewControllers.count, _topViewHeight)];
                    topViewSecondbtn.tag=BKMenuSelectButtonTypeHeadSecond;
                    topViewSecondbtn.selectedColor = self.btnSelectColor;
                    topViewSecondbtn.notSelectedColor = self.btnUnSelectColor;
                    self.topViewSecondbtn=topViewSecondbtn;
                    [self setupBtnContentState:self.topViewSecondbtn  index:i];
                }
                    break;
                case 2:
                {
                    BKMenuSelectButton *topViewThirdbtn=[[BKMenuSelectButton alloc]initWithFrame:CGRectMake((_topViewWidth)/self.contentVC.childViewControllers.count*i,0, (_topViewWidth)/self.contentVC.childViewControllers.count, _topViewHeight)];
                    topViewThirdbtn.tag=BKMenuSelectButtonTypeHeadThird;
                    topViewThirdbtn.selectedColor = self.btnSelectColor;
                    topViewThirdbtn.notSelectedColor = self.btnUnSelectColor;
                    self.topViewThirdbtn=topViewThirdbtn;
                    [self setupBtnContentState:self.topViewThirdbtn index:i];

                }
                    break;
                case 3:
                {
                    BKMenuSelectButton *topViewFourthbtn=[[BKMenuSelectButton alloc]initWithFrame:CGRectMake((_topViewWidth)/self.contentVC.childViewControllers.count*i,0, (_topViewWidth)/self.contentVC.childViewControllers.count, _topViewHeight)];
                    topViewFourthbtn.tag=BKMenuSelectButtonTypeHeadFourth;
                    topViewFourthbtn.selectedColor = self.btnSelectColor;
                    topViewFourthbtn.notSelectedColor = self.btnUnSelectColor;
                    self.topViewFourthbtn=topViewFourthbtn;
                    [self setupBtnContentState:self.topViewFourthbtn index:i];
                }
                    break;
                case 4:
                {
                    BKMenuSelectButton *topViewFifthbtn=[[BKMenuSelectButton alloc]initWithFrame:CGRectMake((_topViewWidth)/self.contentVC.childViewControllers.count*i,0, (_topViewWidth)/self.contentVC.childViewControllers.count, _topViewHeight)];
                    topViewFifthbtn.tag=BKMenuSelectButtonTypeHeadFifth;
                    topViewFifthbtn.selectedColor = self.btnSelectColor;
                    topViewFifthbtn.notSelectedColor = self.btnUnSelectColor;
                    self.topViewFifthbtn=topViewFifthbtn;
                    [self setupBtnContentState:self.topViewFifthbtn index:i];
                }
                    break;
                case 5:
                {
                    BKMenuSelectButton *topViewSixthbtn=[[BKMenuSelectButton alloc]initWithFrame:CGRectMake((_topViewWidth)/self.contentVC.childViewControllers.count*i,0, (_topViewWidth)/self.contentVC.childViewControllers.count, _topViewHeight)];
                    topViewSixthbtn.tag=BKMenuSelectButtonTypeHeadSixth;
                    topViewSixthbtn.selectedColor = self.btnSelectColor;
                    topViewSixthbtn.notSelectedColor = self.btnUnSelectColor;
                    self.topViewSixthbtn=topViewSixthbtn;
                    [self setupBtnContentState:self.topViewSixthbtn index:i];
                }
                    break;
                case 6:
                {
                    BKMenuSelectButton *topViewSeventhbtn=[[BKMenuSelectButton alloc]initWithFrame:CGRectMake((_topViewWidth)/self.contentVC.childViewControllers.count*i,0, (_topViewWidth)/self.contentVC.childViewControllers.count, _topViewHeight)];
                    topViewSeventhbtn.tag=BKMenuSelectButtonTypeHeadSeventh;
                    topViewSeventhbtn.selectedColor = self.topViewSeventhbtn.notSelectedColor = self.btnUnSelectColor;
                    self.topViewSeventhbtn=topViewSeventhbtn;
                    [self setupBtnContentState:self.topViewSeventhbtn index:i];
                }
                    break;
                case 7:
                {
                    BKMenuSelectButton *topViewEighthbtn=[[BKMenuSelectButton alloc]initWithFrame:CGRectMake((_topViewWidth)/self.contentVC.childViewControllers.count*i,0, (_topViewWidth)/self.contentVC.childViewControllers.count, _topViewHeight)];
                    topViewEighthbtn.tag=BKMenuSelectButtonTypeHeadEighth;
                    topViewEighthbtn.selectedColor = self.btnSelectColor;
                    topViewEighthbtn.notSelectedColor = self.btnUnSelectColor;
                    self.topViewEighthbtn=topViewEighthbtn;
                    [self setupBtnContentState:self.topViewEighthbtn index:i];
                }
                    break;
                case 8:
                {
                    BKMenuSelectButton *topViewNinthbtn=[[BKMenuSelectButton alloc]initWithFrame:CGRectMake((_topViewWidth)/self.contentVC.childViewControllers.count*i,0, (_topViewWidth)/self.contentVC.childViewControllers.count, _topViewHeight)];
                    topViewNinthbtn.tag=BKMenuSelectButtonTypeHeadNinth;
                    topViewNinthbtn.selectedColor = self.btnSelectColor;
                    topViewNinthbtn.notSelectedColor = self.btnUnSelectColor;
                    self.topViewNinthbtn=topViewNinthbtn;
                    [self setupBtnContentState:self.topViewNinthbtn index:i];
                }
                    break;
                    
            }}
    }
    
}

//设置
- (void)setupViewUnderContent {
    self.viewUnder=[[UIView alloc]initWithFrame:CGRectMake(0, (_topViewHeight)-2, (_topViewWidth)/self.contentVC.childViewControllers.count, 2)];
    self.viewUnder.backgroundColor = self.btnSelectColor?self.btnSelectColor:MENU_DEF_COLOR;    [self.viewTop addSubview:_viewUnder];
}

- (void)setupContentViewContent {
    self.childVcViewHeight=[self setupChildVcViewHeight];
    self.childVcViewWidth= [self setupChildVcViewWidth];
    self.childVcViewX=[self setupChildVcViewX];
    self.childVcViewY=[self setupChildVcViewY];

     UIView *animationChangeView=[[UIView alloc]initWithFrame:CGRectMake(self.childVcViewX,self.childVcViewY, self.childVcViewWidth,_childVcViewHeight)];
    [self.contentVC.view addSubview:animationChangeView];
    self.animationChangeView =animationChangeView;

    if (self.contentVC.childViewControllers.count==0||self.contentVC.childViewControllers.count>9) {
        [self removeFromSuperview];
        
    } else {
        self.showVC=self.contentVC.childViewControllers[0];
        self.contentVC.childViewControllers[0].view.frame=self.animationChangeView.bounds;
        self.showVC.view.frame=self.animationChangeView.bounds;
        [self.animationChangeView addSubview:self.showVC.view];
        if (self.showVC.title) {
            self.topViewFirstbtn.labName.text=self.showVC.title;
        }
        [self.topViewFirstbtn setState:YES];
        
        [self setupShowVcRecognizer];
    }
}

- (void)setupBtnContentState:(BKMenuSelectButton *)btn index:(int)index {
    [self setupAllBtnState:btn];
    for (NSNumber *titleIndex in self.titleIndexArr) {
        
        if (index ==[titleIndex intValue]) {
            btn.labName.text=self.titleArr[self.titleCompareIndex];
            self.titleCompareIndex++;
        }
    }
    
    [btn addTarget:self action:@selector(btnHeadClickType:) forControlEvents:UIControlEventTouchUpInside];
    [self.viewTop addSubview:btn];
}

- (void)underViewMoveTo:(int)index {
    [UIView animateWithDuration:KDuration animations:^{
        self.viewUnder.frame=CGRectMake(index *((_topViewWidth)/self.index), (_topViewHeight)-2, (_topViewWidth)/self.index, 2);
    }];
}

- (void)setupbtnSelectIndex:(int)btnSelectIndex {
    switch (btnSelectIndex) {
        case BKMenuSelectButtonTypeHeadFirst:
        {
            [self setupBtnState];
            [self.topViewFirstbtn setState:YES];
            [self underViewMoveTo:0];
        }
            break;
        case BKMenuSelectButtonTypeHeadSecond:
        {
            [self setupBtnState];
            [self.topViewSecondbtn setState:YES];
            [self underViewMoveTo:1];
        }
            break;
        case BKMenuSelectButtonTypeHeadThird:
        {
            [self setupBtnState];
            [self.topViewThirdbtn setState:YES];
            [self underViewMoveTo:2];
        }
            break;
        case BKMenuSelectButtonTypeHeadFourth:
        {
            [self setupBtnState];
            [self.topViewFourthbtn setState:YES];
            [self underViewMoveTo:3];
        }
            break;
        case BKMenuSelectButtonTypeHeadFifth:
        {
            [self setupBtnState];
            [self.topViewFifthbtn setState:YES];
            [self underViewMoveTo:4];
        }
            break;
        case BKMenuSelectButtonTypeHeadSixth:
        {
            [self setupBtnState];
            [self.topViewSixthbtn setState:YES];
            [self underViewMoveTo:5];
        }
            break;
        case BKMenuSelectButtonTypeHeadSeventh:
        {
            [self setupBtnState];
            [self.topViewSeventhbtn setState:YES];
            [self underViewMoveTo:6];
        }
            break;
        case BKMenuSelectButtonTypeHeadEighth:
        {
            [self setupBtnState];
            [self.topViewEighthbtn setState:YES];
            [self underViewMoveTo:7];
        }
            break;
        case BKMenuSelectButtonTypeHeadNinth:
        {
            [self setupBtnState];
            [self.topViewNinthbtn setState:YES];
            [self underViewMoveTo:8];
        }
            break;
    }

}

- (void)btnHeadClickType:(BKMenuSelectButton *)btn {
    self.btnIndex=(int)btn.tag;
    [self.showVC.view removeFromSuperview];
    self.newindex=[btn.superview.subviews indexOfObject:btn];
    self.oldindex=[self.contentVC.childViewControllers indexOfObject:self.showVC];
    self.showVC=self.contentVC.childViewControllers[self.newindex];
    self.showVC.view.frame=self.animationChangeView.bounds;
    [self.animationChangeView addSubview:self.showVC.view];
    [self setupShowVcRecognizer];
    [self setupActionState:self.isCloseAnimation];
    [self setupbtnSelectIndex:(int)btn.tag];
}

//手势初始化
- (void)setupShowVcRecognizer {
    if (self.isCloseSwipeGesture) {

    } else {
        self.recognizerLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
        [self.recognizerLeft  setDirection:(UISwipeGestureRecognizerDirectionLeft)];
        [self.showVC.view addGestureRecognizer:self.recognizerLeft ];
        self.recognizerRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
        
        [self.recognizerRight  setDirection:(UISwipeGestureRecognizerDirectionRight)];
        [self.showVC.view addGestureRecognizer:self.recognizerRight ];
    }
}

//手势实现内容
- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer {
    //如果往右滑
    if (recognizer.direction==UISwipeGestureRecognizerDirectionRight) {
        self.btnIndex--;
        self.newindex--;
        if (self.newindex<0) {
            self.newindex=0;
        }
        if (self.btnIndex<0) {
            self.btnIndex=0;
            
        } else {
            [self.showVC.view removeFromSuperview];
            self.oldindex=[self.contentVC.childViewControllers indexOfObject:self.showVC];
            self.showVC=self.contentVC.childViewControllers[((self.btnIndex)?(self.btnIndex):0)];
            self.showVC.view.frame=self.animationChangeView.bounds;
            [self.animationChangeView addSubview:self.showVC.view];
            [self setupShowVcRecognizer];
            
            [self setupbtnSelectIndex:self.btnIndex];
            [self setupActionState:self.isCloseAnimation];
            // NSLog(@"%d --left",self.btnIndex);
        }
    }

    //如果往左滑
    if(recognizer.direction==UISwipeGestureRecognizerDirectionLeft) {
        
        self.btnIndex++;
        self.newindex++;
        if (self.newindex>self.contentVC.childViewControllers.count-1) {
            self.newindex=(int)self.contentVC.childViewControllers.count-1;
        } if (self.btnIndex>self.contentVC.childViewControllers.count-1) {
            self.btnIndex=(int)self.contentVC.childViewControllers.count-1;
        } else {
            [self.showVC.view removeFromSuperview];
            self.oldindex=[self.contentVC.childViewControllers indexOfObject:self.showVC];
            self.showVC=self.contentVC.childViewControllers[((self.btnIndex)?(self.btnIndex):0)];
            self.showVC.view.frame=self.animationChangeView.bounds;
            [self.animationChangeView addSubview:self.showVC.view];
            [self setupShowVcRecognizer];
            
            [self setupbtnSelectIndex:self.btnIndex];
            [self setupActionState:self.isCloseAnimation];
            //  NSLog(@"%d --rigth",self.btnIndex);
        }
    }
}

- (void)setupBtnState {
    [self.topViewFirstbtn setState:NO];
    [self.topViewSecondbtn setState:NO];
    [self.topViewThirdbtn setState:NO];
    [self.topViewFourthbtn setState:NO];
    [self.topViewFifthbtn setState:NO];
    [self.topViewSixthbtn setState:NO];
    [self.topViewSeventhbtn setState:NO];
    [self.topViewEighthbtn setState:NO];
    [self.topViewNinthbtn setState:NO];
}

- (void)setupActionState:(BOOL)state {
    if (state==YES) {
        //[self.contentView.layer removeAnimationForKey:@"push"];
        [self.animationChangeView.layer removeAllAnimations];
    } else if(state==NO) {
        if (!self.animationType) {
            self.animationType=Push;
        }

        switch (self.animationType) {
            case Fade:
                [self transitionWithType:kCATransitionFade  ForView:self.animationChangeView];
                break;
                
            case Push:
                [self transitionWithType:kCATransitionPush  ForView:self.animationChangeView];
                break;
                
            case Reveal:
                [self transitionWithType:kCATransitionReveal  ForView:self.animationChangeView];
                break;
                
            case MoveIn:
                [self transitionWithType:kCATransitionMoveIn  ForView:self.animationChangeView];
                break;
                
            case Cube:
                [self transitionWithType:@"cube"  ForView:self.animationChangeView];
                break;
                
            case SuckEffect:
                [self transitionWithType:@"suckEffect"  ForView:self.animationChangeView];
                break;
                
            case OglFlip:
                [self transitionWithType:@"oglFlip"  ForView:self.animationChangeView];
                break;
                
            case RippleEffect:
                [self transitionWithType:@"rippleEffect"  ForView:self.animationChangeView];
                break;
                
            case PageCurl:
                [self transitionWithType:@"pageCurl"  ForView:self.animationChangeView];
                break;
                
            case PageUnCurl:
                [self transitionWithType:@"pageUnCurl"  ForView:self.animationChangeView];
                break;
                
            case CameraIrisHollowOpen:
                [self transitionWithType:@"cameraIrisHollowOpen"  ForView:self.animationChangeView];
                break;
                
            case CameraIrisHollowClose:
                [self transitionWithType:@"cameraIrisHollowClose"  ForView:self.animationChangeView];
                break;
            case CurlDown:
                [self animationWithView:self.animationChangeView WithAnimationTransition:UIViewAnimationTransitionCurlDown];
                break;
                
            case CurlUp:
                [self animationWithView:self.animationChangeView WithAnimationTransition:UIViewAnimationTransitionCurlUp];
                break;
                
            case FlipFromLeft:
                [self animationWithView:self.animationChangeView WithAnimationTransition:UIViewAnimationTransitionFlipFromLeft];
                break;
                
            case FlipFromRight:
                [self animationWithView:self.animationChangeView WithAnimationTransition:UIViewAnimationTransitionFlipFromRight];

            default:
                break;
        }
    }
}

- (void)animationWithView:(UIView *)view WithAnimationTransition:(UIViewAnimationTransition)transition {
    [UIView animateWithDuration:self.speedTime?self.speedTime:KDuration animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationTransition:transition forView:view cache:YES];
    }];
}

- (void)transitionWithType:(NSString *)type ForView:(UIView *)view {
    //创建CATransition对象
    CATransition *animation = [CATransition animation];
    //设置运动时间
    animation.duration = self.speedTime?self.speedTime:KDuration;
    //设置运动type
    animation.type = type;
    //设置子类
    animation.subtype = self.newindex>self.oldindex?kCATransitionFromRight:kCATransitionFromLeft;
    //设置运动速度
    animation.timingFunction = UIViewAnimationOptionCurveEaseInOut;
    [view.layer addAnimation:animation forKey:@"animation"];
}

@end



