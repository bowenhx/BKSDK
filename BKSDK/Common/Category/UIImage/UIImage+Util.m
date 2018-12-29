/**
 -  UIImage+Util.m
 -  BKSDK
 -  Created by HY on 16/11/18.
 -  Copyright © 2016年 BaByKingdom. All rights reserved.
 */

#import "UIImage+Util.h"

#define IMAGE_BYTE   900000

@implementation UIImage (Util)


#pragma mark - 调整图片方向
- (UIImage *)normalizedImageOrientation {
    if (self.imageOrientation == UIImageOrientationUp) {
        return self;
    }
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    [self drawInRect:(CGRect){0, 0, self.size}];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return normalizedImage;
}


#pragma mark - 如果图片超过额定值,则压缩图片,否则返回原对象
- (UIImage *)compressedImage {
    //将原有图片转换成NSData类型
    NSData *imageData = UIImageJPEGRepresentation(self, 1.0);
    //取出图片文件大小
    NSUInteger dataLength = imageData.length;
    //当图片MB大于指定MB时,压缩图片
    UIImage *newImage = self;
    if (dataLength > IMAGE_BYTE) {
        //压缩图片
        newImage = [newImage scalingImageByRatio];
    }
    return newImage;
}


#pragma mark - 压缩图片到指定尺寸大小，改变大小改变质量，会导致图片模糊
- (UIImage *)scaleToSize:(CGSize)size {
    CGFloat width = CGImageGetWidth(self.CGImage);
    CGFloat height = CGImageGetHeight(self.CGImage);
    
    float verticalRadio = size.height * 1.0 / height;
    float horizontalRadio = size.width * 1.0 / width;
    
    float radio = 1;
    if(verticalRadio > 1 && horizontalRadio > 1) {
        radio = verticalRadio > horizontalRadio ? horizontalRadio : verticalRadio;
    } else {
        radio = verticalRadio < horizontalRadio ? verticalRadio : horizontalRadio;
    }
    
    width = width*radio;
    height = height*radio;
    
    int xPos = (size.width - width) / 2;
    int yPos = (size.height - height) / 2;
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(xPos, yPos, width, height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}


#pragma mark - 调整图片像素
- (UIImage *)scalingImageByRatio {
    UIImage *image = nil;
    if (self.size.width < self.size.height) {
        CGFloat ratio = self.size.height / [UIScreen mainScreen].bounds.size.height;
        CGFloat img_h = self.size.height * ratio;
        CGFloat img_w = self.size.width *ratio;
        if (img_w > [UIScreen mainScreen].bounds.size.width) {
            CGFloat subRatio = 720 / img_w;
            CGFloat subImg_w = img_w * subRatio;
            CGFloat subImg_h = img_h * subRatio;
            
            image = [self imageByScalingAndCroppingForSize:CGSizeMake(subImg_w, subImg_h)];
        } else {
            image = [self imageByScalingAndCroppingForSize:CGSizeMake(img_w, img_h)];
        }
    } else if (self.size.width >= self.size.height ) {
        
        CGFloat ratio = 960 / self.size.width ;
        CGFloat img_h = self.size.height * ratio;
        CGFloat img_w = self.size.width * ratio;
        image = [self imageByScalingAndCroppingForSize:CGSizeMake(img_w, img_h)];
    }
    return image;
}


//根据size，进行图片缩放和裁剪
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize {
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor) {
            scaleFactor = widthFactor; // scale to fit height
        } else {
            scaleFactor = heightFactor; // scale to fit width
        }
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else {
            if (widthFactor < heightFactor) {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
        }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}


#pragma mark - 根据宽度来重新绘制图片
- (UIImage *)compressedImage:(float)width {
    CGSize imageSize = self.size;
    CGFloat imgW = imageSize.width;
    CGFloat imgH = imageSize.height;
    
    if (imgW <= width && imgH <= [UIScreen mainScreen].bounds.size.height) {
        // no need to compress.
        return self;
    }
    
    if (imgW == 0 || imgH == 0) {
        // void zero exception
        return self;
    }
    
    UIImage *newImage = nil;
    CGFloat widthFactor = width / imgW;
    CGFloat heightFactor = [UIScreen mainScreen].bounds.size.height / imgH;
    CGFloat scaleFactor = 0.0;
    
    if (widthFactor > heightFactor) {
        scaleFactor = heightFactor; // scale to fit height
    } else {
        scaleFactor = widthFactor; // scale to fit width
    }
    CGFloat scaledWidth  = imgW * scaleFactor;
    CGFloat scaledHeight = imgH * scaleFactor;
    CGSize targetSize = CGSizeMake(scaledWidth, scaledHeight);
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [self drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage*)scaleFillToSize:(CGSize)size {
    //创建一个bitmap的context
    //并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    //绘制改变大小的图片
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    //从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    //使当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的改变大小后的图片
    return scaledImage;
}

@end
