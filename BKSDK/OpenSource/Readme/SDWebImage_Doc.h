/**
 -  SDWebImage_Doc.h
 -  BKSDK
 -  Created by HY on 16/11/30.
 -  Copyright © 2016年 BaByKingdom. All rights reserved.
 -  文件标示：https://github.com/rs/SDWebImage
 -  内容摘要：可以为‘UIImageView’,‘UIButton’,‘MKAnnotationView‘，添加web图像和缓存管理
 -  当前版本：3.8
 
 
 ##使用方法：
     
     #import <SDWebImage/UIImageView+WebCache.h>
     ...
 
     [imageView sd_setImageWithURL:[NSURL URLWithString:@"http://www.domain.com/path/to/image.jpg"]
     placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
 
     [imageView sd_setImageWithURL:[NSURL URLWithString:@"https://graph.facebook.com/olivier.poitrey/picture"]
     placeholderImage:[UIImage imageNamed:@"avatar-placeholder.png"]
     options:SDWebImageRefreshCached];
 
 */

#import <Foundation/Foundation.h>

@protocol SDWebImage_Doc <NSObject>

@end
