/**
 -  MJRefresh_Doc.h
 -  BKSDK
 -  Created by HY on 16/11/30.
 -  Copyright © 2016年 BaByKingdom. All rights reserved.
 -  文件标示：https://github.com/CoderMJLee/MJRefresh
 -  内容摘要：页面刷新，可用于UIScrollView、UITableView、UICollectionView、UIWebView
 -  当前版本：3.1
 
 
 ##使用方法：
 
     01-Default：
         //表头
         self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
         [self.tableView.header beginRefreshing];
         //表尾
         self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
 
 
     02-Animation image：
         //表头
         MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
         [header setImages:idleImages forState:MJRefreshStateIdle];
         [header setImages:pullingImages forState:MJRefreshStatePulling];
         [header setImages:refreshingImages forState:MJRefreshStateRefreshing];
         self.tableView.mj_header = header;
        //表尾
         MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
         [footer setImages:refreshingImages forState:MJRefreshStateRefreshing];
         self.tableView.mj_footer = footer;
 
 
     03-Hide the time
         header.lastUpdatedTimeLabel.hidden = YES;
 
 
     04-Hide status and time
         header.lastUpdatedTimeLabel.hidden = YES;
         header.stateLabel.hidden = YES;
 
 
     05-DIY title
         // Set title
         [header setTitle:@"Pull down to refresh" forState:MJRefreshStateIdle];
         [header setTitle:@"Release to refresh" forState:MJRefreshStatePulling];
         [header setTitle:@"Loading ..." forState:MJRefreshStateRefreshing];
         // Set font
         header.stateLabel.font = [UIFont systemFontOfSize:15];
         header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
         // Set textColor
         header.stateLabel.textColor = [UIColor redColor];
         header.lastUpdatedTimeLabel.textColor = [UIColor blueColor];
 
 
     06-All loaded
         [footer noticeNoMoreData];
 
 
 

 ## UIWebView01-The drop-down refresh
 
         self.webView.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
         }];
     
 
 
 ##UICollectionView01-The pull and drop-down refresh
 
         self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
         }];
         self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
         }];
 
 
 */

#import <Foundation/Foundation.h>

@protocol MJRefresh_Doc <NSObject>

@end
