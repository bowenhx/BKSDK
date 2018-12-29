/**
 -  HTHorizontalSelectionList_Doc.h
 -  BKSDK
 -  Created by HY on 16/11/30.
 -  Copyright © 2016年 BaByKingdom. All rights reserved.
 -  文件标示：https://github.com/hightower/HTHorizontalSelectionList
 -  内容摘要：主要实现了一个横向滚动的选择列表视图，可以用于代替UISegmentedControl，支持delegate和dataSource方法，用于板块列表页面
 -  当前版本：0.5
 
 
 ##使用方法：
 
    1：导入
        #import <HTHorizontalSelectionList/HTHorizontalSelectionList.h>
 
    2：使用方法：
         @interface CarListViewController () <HTHorizontalSelectionListDataSource, HTHorizontalSelectionListDelegate>
         
         @property (nonatomic, strong) HTHorizontalSelectionList *selectionList;
         @property (nonatomic, strong) NSArray *carMakes;
         
         @end
         
         @implementation CarListViewController
         
         - (void)viewDidLoad {
             [super viewDidLoad];
             
             self.selectionList = [[HTHorizontalSelectionList alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
             selectionList.delegate = self;
             selectionList.dataSource = self;
             selectionList.selectionIdicatorAnimationMode = HTHorizontalSelectionIndicatorAnimationModeLightBounce;
             selectionList.selectionIndicatorColor = [UIColor colorNavBg];
             [selectionList setTitleColor:[UIColor redC olor] forState:UIControlStateHighlighted];
             [selectionList setTitleFont:[UIFont systemFontOfSize:15] forState:UIControlStateNormal];
             [selectionList setTitleFont:[UIFont boldSystemFontOfSize:15] forState:UIControlStateSelected];
             [selectionList setTitleFont:[UIFont boldSystemFontOfSize:15] forState:UIControlStateHighlighted];
     
             self.carMakes = @[@"ALL CARS",
                             @"AUDI",
                             @"BITTER",
                             @"BMW",
                             @"BÜSSING",
                             @"GUMPERT",
                             @"MAN"];
         }
         
         #pragma mark - HTHorizontalSelectionListDataSource Protocol Methods
         
         - (NSInteger)numberOfItemsInSelectionList:(HTHorizontalSelectionList *)selectionList {
             return self.carMakes.count;
         }
         
         - (NSString *)selectionList:(HTHorizontalSelectionList *)selectionList titleForItemWithIndex:(NSInteger)index {
             return self.carMakes[index];
         }
         
         #pragma mark - HTHorizontalSelectionListDelegate Protocol Methods
         
         - (void)selectionList:(HTHorizontalSelectionList *)selectionList didSelectButtonWithIndex:(NSInteger)index {
             // update the view for the corresponding index
         }
  
 */

#import <Foundation/Foundation.h>

@protocol HTHorizontalSelectionList_Doc <NSObject>

@end
