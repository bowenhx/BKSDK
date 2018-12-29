/**
 -  BKMenuSelectButton.m
 -  BKSDK
 -  Created by HY on 16/12/29.
 -  Copyright © 2016年 BaByKingdom. All rights reserved.
 -  多个页面滑动的页面，顶部按钮设置
 */

#import "BKMenuSelectButton.h"

@interface BKMenuSelectButton()

@end

@implementation BKMenuSelectButton


- (instancetype)initWithFrame:(CGRect)frame {
    self=[super initWithFrame:frame];
    if (self) {
        UILabel *labName=[[UILabel alloc]init];
        labName.textAlignment=NSTextAlignmentCenter;
        labName.textColor=MENU_DEF_COLOR;
        labName.font=[UIFont systemFontOfSize:14];
        [self addSubview:labName];
        self.labName=labName;
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    self.labName.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}


- (void)setState:(BOOL)state {
    if (state==YES) {
        self.labName.textColor=self.selectedColor?self.selectedColor:MENU_DEF_COLOR;
        self.userInteractionEnabled=NO;
    }else if(state==NO)
    {
        self.labName.textColor=self.notSelectedColor?self.notSelectedColor:[UIColor grayColor];
        self.userInteractionEnabled=YES;
    }
}


@end

