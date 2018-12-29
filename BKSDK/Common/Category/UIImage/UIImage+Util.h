/**
 -  UIImage+Util.h
 -  BKSDK
 -  Created by HY on 16/11/18.
 -  Copyright © 2016年 BaByKingdom. All rights reserved.
 -  扩充UIImage的方法，对image进行调整到正确方向处理，使用UIImageJPEGRepresentation方法添加压缩系数来压缩图片，压缩图片到指定尺寸大小。
 */

#import <UIKit/UIKit.h>

@interface UIImage (Util)


/**
 *  @brief  ##调整图片方向，以UIImageOrientationUp为正确图片方向
 *  这里是利用了UIImage中的drawInRect方法，它会将图像绘制到画布上，并且已经考虑好了图像的方向
 *  @return 返回调整为正确方法的图片
 */
- (UIImage *)normalizedImageOrientation;


/**
 如果图片超过额定值,则压缩图片,否则返回原对象

 @return 压缩好的图片
 */
- (UIImage *)compressedImage;


/**
 等比例缩放图片

 @param size 需要缩放到的图片大小
 @return 缩放后的图片
 */
- (UIImage *)scaleToSize:(CGSize)size;


/**
 调整图片像素

 @return 返回调整好像素的图片
 */
- (UIImage *)scalingImageByRatio;


/**
 根据宽度来重新绘制图片

 @param width 指定图片宽度

 @return 返回指定宽度的图片
 */
- (UIImage *)compressedImage:(float)width;


/**
 缩放到指定尺寸,缩放后图像会填满到指定尺寸

 @param size 指定尺寸
 @return 指定尺寸的图片
 */
- (UIImage*)scaleFillToSize:(CGSize)size;
@end
