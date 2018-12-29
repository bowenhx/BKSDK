/**
 -  BKCleanCache.m
 -  BKMobile
 -  Created by HY on 16/12/15.
 -  Copyright © 2016年 com.mobile-kingdom.bkapps. All rights reserved.
 */

#import "BKCleanCache.h"

@implementation BKCleanCache

#pragma mark - 清理缓存文件

+ (void)trimCacheDirByPath:(NSString *)filePath isAll:(BOOL)isAll {
    //limit number of files by deleting the oldest ones.
    //creation date used to see age of file
    //modification date used to see staleness of file - how long since last used.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
      
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *file;
        NSDirectoryEnumerator *dirEnum = [fileManager enumeratorAtPath:filePath];
        NSMutableArray* fileAges = [NSMutableArray arrayWithCapacity:BKDiskCacheAgeLimit]; //used to sort files by age
        int  thisDirFileCount=0;
        int  deletedCount=0;
        long deletedBytes=0;
        // this loop is the slow part, which is why this whole method is run on a separate thread.
        while ((file = [dirEnum nextObject])) {
            NSString* filename = [filePath stringByAppendingPathComponent:file];
            //如果isAll == YES，清除全部缓存
            if (isAll) {
                NSError* errAll=nil;
                [fileManager removeItemAtPath:filename error:&errAll];
                if (errAll==nil) {
                    deletedCount++;
                }
                continue;
            }
            //根据缓存文件个数和缓存时间来清理缓存
            NSError* e;
            NSDictionary* fsAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:filename error:&e];
            double ageSeconds = -1* [[fsAttributes fileModificationDate] timeIntervalSinceNow];
            unsigned long long filesize = [fsAttributes fileSize];
            if (ageSeconds > BKDiskCacheAgeLimit && BKDiskCacheAgeLimit > 0) {
                //old files get deleted right away
                NSError* err = nil;
                [fileManager removeItemAtPath:filename error:&err];
                if (err == nil) {
                    deletedCount++;
                    deletedBytes += filesize;
                }
            } else {
                //files that are not too old are going to be counted and sorted by age
                thisDirFileCount++;
                //a holder of filename, age, and size, for sorting names by file age
                NSArray* fileAge = [NSArray arrayWithObjects:
                                    [NSNumber numberWithDouble:ageSeconds],
                                    filename,
                                    [NSNumber numberWithLongLong:filesize],nil];
                [fileAges addObject:fileAge];
            }
        }
        
        if (thisDirFileCount >= BKDiskCacheCountLimit && BKDiskCacheCountLimit > 0) {
            //thisDirFileCount is still over the limit (even if some old files were deleted)
            //so now have to delete the oldest files. Behavoir of cache will be FIFO or LRU depending on cache policy readsUpdateFileDate
            [fileAges sortUsingFunction:fileAgeCompareFunction context:nil]; //sorted from oldest to youngest
            
            NSUInteger index = [fileAges count] - 1;
            //delete files until 20% under file count.
            while (thisDirFileCount > (BKDiskCacheCountLimit*0.8) && index > 0) {
                NSError* err=nil;
                NSArray* fileAgeObj = [fileAges objectAtIndex:index];
                NSString* filename = [fileAgeObj objectAtIndex:1];
                //NSLog(@"deleting %@",filename);
                [fileManager removeItemAtPath:filename error:&err];
                if (err==nil) {
                    thisDirFileCount--;
                    NSNumber* filesize = [fileAgeObj objectAtIndex:2];
                    deletedCount++;
                    deletedBytes += [filesize longValue];
                }
                index--;
            }
        }
        NSLog(@"cache file trimed %i files and size %ld", deletedCount, deletedBytes);
    });
}

NSInteger fileAgeCompareFunction(id obj1, id obj2, void *context) {
    NSNumber* age1 = [(NSArray*)obj1 objectAtIndex:0];
    NSNumber* age2 = [(NSArray*)obj2 objectAtIndex:0];
    return [age1 compare:age2];
}


@end
