/**
 -  BKCustomNavigation.m
 -  BKSDK
 -  Created by HY on 16/12/22.
 -  Copyright © 2016年 BaByKingdom. All rights reserved.
 -  自定义的导航条view，可实现多种样式，支持nav左右两边显示一个或者两个按钮的情况
 */

#import "BKCustomNavigation.h"

#define DEF_SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width

@implementation BKCustomNavigation
 
#pragma mark - 自定义一个分割线放到导航条上
- (void)addBottomLineView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 62, [UIScreen mainScreen].bounds.size.width, 2)];
    view.backgroundColor = [UIColor redColor];
    [self addSubview:view];
}


#pragma mark - 1:自定义导航栏 左边是一个图片按钮，右边是一个文字按钮
- (instancetype)initWithNavOne:(NSString *)title bgColor:(UIColor *)bgColor leftBtnImage:(UIImage *)leftImage rightBtnTitle:(NSString *)rightTitle leftBlock:(ItemBlock)leftBlock rightBlock:(ItemBlock)rightBlock {
    if (self = [super initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, 64)]) {
        [self addleftButtonWithImage:leftImage leftBlock:leftBlock];
        [self addrightButtonWithImage:nil title:rightTitle  rightBlock:rightBlock];
        [self addTitleLabel:title];
        self.backgroundColor = bgColor;
    }
    return self;
}


#pragma mark - 2:自定义导航栏 左右两边边都是一个图片按钮
- (instancetype)initWithNavTwo:(NSString *)title bgColor:(UIColor *)bgColor leftBtnImage:(UIImage *)leftImage rightBtnImage:(UIImage *)rightImage leftBlock:(ItemBlock)leftBlock rightBlock:(ItemBlock)rightBlock {
    if (self = [super initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, 64)]) {
        [self addleftButtonWithImage:leftImage leftBlock:leftBlock];
        [self addrightButtonWithImage:rightImage rightBlock:rightBlock];
        [self addTitleLabel:title];
        self.backgroundColor = bgColor;
    }
    return self;
}


#pragma mark - 自定义导航栏 左右两边都有一个按钮，并且可以设置文字和图片
- (instancetype)initWithNavThree:(NSString *)title bgColor:(UIColor *)bgColor leftBtnImage:(UIImage *)leftImage leftBtnTitle:(NSString *)leftBtnTitle  rigthBtnTitle:(NSString *)rightBtnTitle  rightBtnImage:(UIImage *)rightImage leftBlock:(ItemBlock)leftBlock rightBlock:(ItemBlock)rightBlock {
    if (self = [super initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, 64)]) {
        [self addleftButtonWithImage:leftImage title:leftBtnTitle  leftBlock:leftBlock];
        [self addrightButtonWithImage:rightImage title:rightBtnTitle  rightBlock:rightBlock];
        [self addTitleLabel:title];
        self.backgroundColor = bgColor;
    }
    return self;
}


#pragma mark -  4:自定义导航栏 左边设置一个按钮，右边可以设置两个按钮
- (instancetype)initWithNavFour:(NSString *)title bgColor:(UIColor *)bgColor leftBtnImage:(UIImage *)leftImage  rightBtnImage2:(UIImage *)rightImage2 rightBtnImage:(UIImage *)rightBtnImage leftBlock:(ItemBlock)leftBlock  rightBlock2:(ItemBlock)rightBlock2 rightBlock:(ItemBlock)rightBlock {
    
    if (self = [super initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, 64)]) {
        [self addrightButtonWithImage:rightBtnImage image2:rightImage2 rightBlock:rightBlock rightBlock2:rightBlock2];
        [self addleftButtonWithImage:leftImage image2:nil leftBlock:leftBlock leftBlock2:nil];
        [self addTitleLabel:title];
        self.backgroundColor = bgColor;
    }
    return self;
}


#pragma mark - 5:自定义导航栏 左右两边都可设置两个按钮
- (instancetype)initWithNavFive:(NSString *)title bgColor:(UIColor *)bgColor leftBtnImage:(UIImage *)leftImage leftBtnImage2:(UIImage *)leftBtnImage2 rightBtnImage2:(UIImage *)rightBtnImage2 rightBtnImage:(UIImage *)rightBtnImage leftBlock:(ItemBlock)leftBlock leftBlock2:(ItemBlock)leftBlock2 rightBlock2:(ItemBlock)rightBlock2 rightBlock:(ItemBlock)rightBlock {
    if (self = [super initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, 64)]) {
        [self addrightButtonWithImage:rightBtnImage image2:rightBtnImage2 rightBlock:rightBlock rightBlock2:rightBlock2];
        [self addleftButtonWithImage:leftImage image2:leftBtnImage2 leftBlock:leftBlock leftBlock2:leftBlock2];
        [self addTitleLabel:title];
        self.backgroundColor = bgColor;
    }
    return self;
}


/**
 *  添加自定义 TabBar 的 title
 */
- (void)addTitleLabel:(NSString *)title {
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 20, DEF_SCREEN_WIDTH - 40 * 2, 44)];
    _titleLabel.text = title;
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont boldSystemFontOfSize:16];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
}


- (void)addleftButtonWithImage:(UIImage *)image leftBlock:(ItemBlock)leftBlock {
    __weak typeof(self) weakSelf = self;

    _leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(12, 34, 18, 18)];
    [_leftBtn setBackgroundImage:image forState:UIControlStateNormal];
    
    _clearView_left = [[UIView alloc] initWithFrame:CGRectMake(0, 22, 40, 40)];
    _clearView_left.backgroundColor = [UIColor clearColor];
    _clearView_left.userInteractionEnabled = YES;
    
    [_clearView_left setTapActionBlock:^{
        if (image && leftBlock) {
            [UIView animateWithDuration:0.1 animations:^{
                weakSelf.leftBtn.alpha = 0.6;
            } completion:^(BOOL finished) {
                weakSelf.leftBtn.alpha = 1;
            }];
            leftBlock();
        }
    }];
    
    [self addSubview:_leftBtn];
    [self addSubview:_clearView_left];
}


- (void)addrightButtonWithImage:(UIImage *)image rightBlock:(ItemBlock)rightBlock {
    __weak typeof(self) weakSelf = self;
    _rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(DEF_SCREEN_WIDTH - 30, 34, 18, 18)];
    [_rightBtn setBackgroundImage:image forState:UIControlStateNormal];
    
    _clearView_right = [[UIView alloc] initWithFrame:CGRectMake(DEF_SCREEN_WIDTH - 40, 22, 40, 40)];
    _clearView_right.backgroundColor = [UIColor clearColor];
    _clearView_right.userInteractionEnabled = YES;
    
    [_clearView_right setTapActionBlock:^{
        if (image && rightBlock) {
            [UIView animateWithDuration:0.1 animations:^{
              weakSelf.rightBtn.alpha = 0.6;
            } completion:^(BOOL finished) {
                weakSelf.rightBtn.alpha = 1;
            }];
            rightBlock();
        }
    }];
    
    [self addSubview:_rightBtn];
    [self addSubview:_clearView_right];
}


- (void)addrightButtonWithImage:(UIImage *)image image2:(UIImage *)image2 rightBlock:(ItemBlock)rightBlock rightBlock2:(ItemBlock)rightBlock2 {
    __weak typeof(self) weakSelf = self;
    _rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(DEF_SCREEN_WIDTH - 30, 34, 18, 18)];
    [_rightBtn setImage:image forState:UIControlStateNormal];
    
    _rightBtn2 = [[UIButton alloc] initWithFrame:CGRectMake(DEF_SCREEN_WIDTH - 30 - 22 - 18,CGRectGetMinY(_rightBtn.frame), 18, 18)];
    [_rightBtn2 setImage:image2 forState:UIControlStateNormal];
    _clearView_right = [[UIView alloc] initWithFrame:CGRectMake(DEF_SCREEN_WIDTH - 30 - 11, 22, 41, 40)];
    _clearView_right.backgroundColor = [UIColor clearColor];
    _clearView_right.userInteractionEnabled = YES;
    
    [_clearView_right setTapActionBlock:^{
        if ((image && rightBlock)) {
            [UIView animateWithDuration:0.1 animations:^{
                weakSelf.rightBtn.alpha = 0.6;
            } completion:^(BOOL finished) {
                weakSelf.rightBtn.alpha = 1;
            }];
            rightBlock();
        }
    }];
    
    _clearView_right2 = [[UIView alloc] initWithFrame:CGRectMake(DEF_SCREEN_WIDTH - 12 - 18*2 - 22 - 12, CGRectGetMinY(_clearView_right.frame), _clearView_right.frame.size.width, _clearView_right.frame.size.height)];
    _clearView_right2.backgroundColor = [UIColor clearColor];
    _clearView_right2.userInteractionEnabled = YES;
    [_clearView_right2 setTapActionBlock:^{
        if ((image2 && rightBlock2)) {
            [UIView animateWithDuration:0.1 animations:^{
                weakSelf.rightBtn2.alpha = 0.6;
            } completion:^(BOOL finished) {
                weakSelf.rightBtn2.alpha = 1;
            }];
            rightBlock2();
        }

    }];
    [self addSubview:_rightBtn];
    [self addSubview:_rightBtn2];
    [self addSubview:_clearView_right];
    [self addSubview:_clearView_right2];
}


- (void)addleftButtonWithImage:(UIImage *)image image2:(UIImage *)image2 leftBlock:(ItemBlock)leftBlock leftBlock2:(ItemBlock)leftBlock2 {
    __weak typeof(self) weakSelf = self;
    _leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(12, 34, 18, 18)];
    [_leftBtn setImage:image forState:UIControlStateNormal];
    _leftBtn2 = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_leftBtn.frame) + 22, 34, 18, _leftBtn.frame.size.height)];
    [_leftBtn2 setImage:image2 forState:UIControlStateNormal];
    _clearView_left = [[UIView alloc] initWithFrame:CGRectMake(0, 22, 30 + 11, 40)];
    _clearView_left.backgroundColor = [UIColor clearColor];
    _clearView_left.userInteractionEnabled = YES;
    
    [_clearView_left setTapActionBlock:^{
        if ((image && leftBlock)) {
            [UIView animateWithDuration:0.1 animations:^{
                weakSelf.leftBtn.alpha = 0.6;
            } completion:^(BOOL finished) {
                weakSelf.leftBtn.alpha = 1;
            }];
            leftBlock();
        }
    }];
    _clearView_left2 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_clearView_left.frame), CGRectGetMinY(_clearView_left.frame), _clearView_left.frame.size.width, _clearView_left.frame.size.height)];
    _clearView_left2.backgroundColor = [UIColor clearColor];
    _clearView_left2.userInteractionEnabled = YES;
    
    [_clearView_left2 setTapActionBlock:^{
        if ((image2 && leftBlock2)) {
            [UIView animateWithDuration:0.1 animations:^{
                weakSelf.leftBtn2.alpha = 0.6;
            } completion:^(BOOL finished) {
                weakSelf.leftBtn2.alpha = 1;
            }];
            leftBlock2();
        }
    }];
    [self addSubview:_leftBtn];
    [self addSubview:_leftBtn2];
    [self addSubview:_clearView_left];
    [self addSubview:_clearView_left2];
}


/**
 *  leftItem + title
 */
- (void)addleftButtonWithImage:(UIImage *)image title:(NSString *)title  leftBlock:(ItemBlock)leftBlock {
    __weak typeof(self) weakSelf = self;
    _leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(12, 34, 18, 18)];
    [_leftBtn setBackgroundImage:image forState:UIControlStateNormal];
    CGSize templeftBtnTitleSize = [self sizeForNoticeTitle:title font:[UIFont systemFontOfSize:16]];
    _leftLabel = [[UILabel alloc] initWithFrame:CGRectMake((image) ? CGRectGetMaxX(_leftBtn.frame) : 12, CGRectGetMinY(_leftBtn.frame), templeftBtnTitleSize.width, _leftBtn.frame.size.height)];
    _leftLabel.text = title;
    _leftLabel.adjustsFontSizeToFitWidth = YES;
    _leftLabel.textColor = [UIColor whiteColor];;
    _clearView_left = [[UIView alloc] initWithFrame:CGRectMake(0, 22, 30 + templeftBtnTitleSize.width, 40)];
    _clearView_left.backgroundColor = [UIColor clearColor];
    _clearView_left.userInteractionEnabled = YES;
    
    [_clearView_left setTapActionBlock:^{
        if ((image && leftBlock) || title) {
            [UIView animateWithDuration:0.1 animations:^{
                weakSelf.leftLabel.alpha = 0.6f;
                weakSelf.leftBtn.alpha = 0.6;
            } completion:^(BOOL finished) {
                weakSelf.leftLabel.alpha = 1.0f;
                weakSelf.leftBtn.alpha = 1;
            }];
            leftBlock();
        }
    }];
    [self addSubview:_leftLabel];
    [self addSubview:_leftBtn];
    [self addSubview:_clearView_left];
}


- (void)addrightButtonWithImage:(UIImage *)image title:(NSString *)title rightBlock:(ItemBlock)rightBlock {
    __weak typeof(self) weakSelf = self;
    _rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(DEF_SCREEN_WIDTH - 30, 34, 18, 18)];
    [_rightBtn setBackgroundImage:image forState:UIControlStateNormal];
    CGSize temprightBtnTitleSize = [self sizeForNoticeTitle:title font:[UIFont systemFontOfSize:16]];
    _rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(image ? (CGRectGetMinX(_rightBtn.frame) - temprightBtnTitleSize.width) : (DEF_SCREEN_WIDTH - 12 - temprightBtnTitleSize.width), 19, temprightBtnTitleSize.width, 44)];
    _rightLabel.text = title;
    _rightLabel.adjustsFontSizeToFitWidth = YES;
    _rightLabel.textColor = [UIColor whiteColor];
    _clearView_right = [[UIView alloc] initWithFrame:CGRectMake(DEF_SCREEN_WIDTH - 30 - temprightBtnTitleSize.width, 22, 33 + temprightBtnTitleSize.width, 40)];
    _clearView_right.backgroundColor = [UIColor clearColor];
    _clearView_right.userInteractionEnabled = YES;
    
    [_clearView_right setTapActionBlock:^{
        if ((image && rightBlock) || title) {
            [UIView animateWithDuration:0.1 animations:^{
                weakSelf.rightLabel.alpha = 0.6f;
                weakSelf.rightBtn.alpha = 0.6;
            } completion:^(BOOL finished) {
                weakSelf.rightLabel.alpha = 1.0f;
                weakSelf.rightBtn.alpha = 1;
            }];
            rightBlock();
        }
    }];
    [self addSubview:_rightLabel];
    [self addSubview:_rightBtn];
    [self addSubview:_clearView_right];
}


/**
 *  字符串获取属性
 *  @param text 文本
 *  @param font 字号
 *
 *  @return size
 */
- (CGSize)sizeForNoticeTitle:(NSString*)text font:(UIFont*)font {
    CGRect screen = [UIScreen mainScreen].bounds;
    CGFloat maxWidth = screen.size.width;
    CGSize maxSize = CGSizeMake(maxWidth, CGFLOAT_MAX);
    
    CGSize textSize = CGSizeZero;
    // iOS7以后使用boundingRectWithSize，之前使用sizeWithFont
    if ([text respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        // 多行必需使用NSStringDrawingUsesLineFragmentOrigin，网上有人说不是用NSStringDrawingUsesFontLeading计算结果不对
        NSStringDrawingOptions opts = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        [style setLineBreakMode:NSLineBreakByCharWrapping];
        NSDictionary *attributes = @{ NSFontAttributeName : font, NSParagraphStyleAttributeName : style };
        CGRect rect = [text boundingRectWithSize:maxSize
                                         options:opts
                                      attributes:attributes
                                         context:nil];
        textSize = rect.size;
    } else {
//        textSize = [text sizeWithFont:font constrainedToSize:maxSize lineBreakMode:NSLineBreakByCharWrapping];
        
        NSDictionary *attribute = @{NSFontAttributeName:font};
        textSize = [text boundingRectWithSize:maxSize options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    }
    return textSize;
}


@end
