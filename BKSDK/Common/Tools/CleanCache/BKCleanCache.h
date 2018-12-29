/**
 -  BKCleanCache.h
 -  BKMobile
 -  Created by HY on 16/12/15.
 -  Copyright © 2016年 com.mobile-kingdom.bkapps. All rights reserved.
 -  根据文件路径，文件名称，最大能包含多少个文件数量，最长缓存多久，来定期清理文件缓存。
 -  如果超出文件限定个数，根据缓存时间先后顺序来删除一部分文件，如果文件超出限定的时长，则超出时长的缓存全部删除
 -  使用方法示例： [BKCleanCache trimCacheDirByPath:BKDiskImageCacheFolder isAll:NO];
 */

#import <Foundation/Foundation.h>
#import "BKSaveData.h" //使用了SaveData中定义的，保存广告图片的文件名 SAVE_IMAGE_CACHE_FOLDER

//定义document路径
#define BTKDoc NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject

//定义磁盘缓存常量
#define BKDiskImageCacheFolder  [BTKDoc stringByAppendingPathComponent:SAVE_IMAGE_CACHE_FOLDER] //缓存图片的文件夹名称

#define BKDiskCacheCountLimit   100         //最大缓存文件个数，100个
#define BKDiskCacheAgeLimit     3600*24*7   //最长缓存时间（秒），一周

@interface BKCleanCache : NSObject

/**
 *  @brief  根据缓存的文件个数，和缓存时长等，清除一部分缓存
 *
 *  @param  filePath 缓存路径
 *  @param  isAll    YES表示清除全部缓存，NO清除部分缓存
 */
+ (void)trimCacheDirByPath:(NSString *)filePath isAll:(BOOL)isAll;


@end
