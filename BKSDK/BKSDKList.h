/**
 -  BKSDKList.h
 -  BKSDK
 -  Created by HY on 16/11/22.
 -  Copyright © 2016年 BaByKingdom. All rights reserved.
 -  BKSDK所包含的功能列表预览
 
 -  BKSDK添加到项目中的使用说明
    - 1：选中你的工程，点击Add File，找到BKSDK.xcodeproj，加入到你的工程中
    - 2：找到工程中的Build Phases选项下的Target Dependencies，点击“+”，添加BKSDK
    - 3：找到工程中的Build Phases选项下的Link Binary With Libraries，点击“+”，添加BKSDK
    - 4：找到Build Settings选项下的Header Search Paths,添加BKSDK的路径："$(SRCROOT)/../BKSDK",设置为递归查找
    - 5：导入头文件 #import <BKSDK/BKSDK.h> ，就可以使用下面的所有功能
 

 -  # Comment中 网络请求模块
 
 
    1. ## BKNetworking (网络请求)
         -  Get单个请求，
         -  Get单个请求含有进度回调
         -  Get批量请求
         -  Post单个请求
         -  Post单个请求含有进度回调
         -  单个上传图片的任务
         -  批量上传图片的任务
         -  检查网络连接状态
     
     
    2. ## BKNetworkModel (网络模型类)
         -  接收网络请求返回数据的模型类
         -  status  请求状态值，标示请求的成功或失败
         -  data    请求返回的数据
         -  message 请求返回的文字信息
 
     
    3. ## BKNetworkConfig (网络配置)
         -  统一设置网络请求服务器地址及配置参数
         -  baseUrl      请求url中base地址
         -  parameterDic 给url追加参数，比如AppVersion, ApiVersion,等信息
 
 
 
 
 -  # Comment中 常用工具模块
 
 
    1. ## BKDefineFile (宏定义)
         -  获取当前AppDelegate
         -  获取当前版本号
         -  获取屏幕宽高，bounds
         -  定义了所有屏幕尺寸大小
         -  判断手机设备是ipad或iphone
         -  获取view坐标点
         -  判断当前设备的系统版本
         -  定义了设置RGB颜色
         -  定义了弱引用/强引用
         -  只在Debug模式下打印日志
 
 
    2. ## BKTool (工具类)
         -  判断一个字符串是否为整形
         -  判断一个字符串是否为空
         -  判断字符串中是否含有某个字符串
         -  获取url字符串中某个参数所对应的值
         -  将时间戳转化为时间
         -  获取当前时间
         -  将十六进制颜色转换为UIColor对象
         -  特殊字符转意处理，解决了&，%，等特殊字符传递给后台无法识别的问题
         -  计算一个label的高度
         -  从堆栈信息中，定位崩溃的页面方法
         -  根据文件名，获取Caches文件夹下该文件路径
         -  根据文件名，获取Library文件夹下文件路径
         -  获取一个随机颜色
         -  获取当前设备的型号
 
 
    3. ## BKSaveData (数据存取)
         -  使用NSUserDefaults，对NSString，NSUInteger，BOOL，NSArray，NSDictionary进行本地存取操作
         -  使用writeToFile方法，对NSArray，NSDictionary，NSData进行本地的文件读写操作。
 
 
    4. ## BKException (捕获崩溃)
         -  开启一个捕获崩溃异常的方法，当遇到崩溃情况时候，把崩溃信息写到本地
         -  再次打开app会从本地读取崩溃信息文件，然后上传到后台
 
 
    5. ## BKMemoryUsege (内存使用)
         -  在app上方，显示内存，CPU的使用情况
 
 
    6. ## BKCustomNavigation (导航条)
         -  自定义的导航条view，可实现多种样式，支持nav左右两边显示一个或者两个按钮的情况
         -  自定义导航栏 左边一个图片，右边一个文字
         -  自定义导航栏 左右两边边都是一个图片按钮
         -  自定义导航栏 左右两边都有一个按钮，并且可以设置文字和图片
         -  自定义导航栏 左边设置一个按钮，右边可以设置两个按钮
         -  自定义导航栏 左右两边都可设置两个按钮
 
 
    7. ## BKMenuViewController (滑动veiw)
         -  适用于当前页面多个view滑动切换效果
 
 
    8. ## BKCleanCache (清除缓存)
         -  根据文件路径，文件名称，最大能包含多少个文件数量，最长缓存多久，来定期清理文件缓存。
         -  如果超出文件限定个数，根据缓存时间先后顺序来删除一部分文件，如果文件超出限定的时长，则超出时长的缓存全部删除

 
 
 
 -  # Comment中 Category模块
 
 
    1. ## UIImage(Util)
         -  对image进行方向调整，调整到正确方向
         -  使用UIImageJPEGRepresentation方法添加压缩系数来压缩图片
         -  压缩图片到指定尺寸大小
         -  调整图片像素
         -  根据宽度来重新绘制图片
 
     
    2. ## UIWindow(Util)
         -  获取到当前可见的页面
 
 
    3. ## UIView(Util)
         - 简单的获取view的x,y,with,height,centerX,centerY,size
         - CGRectGetWidth  返回view本身的宽度
         - CGRectGetHeight 返回view本身的高度
         - CGRectGetMinY 返回view顶部的坐标
         - CGRectGetMaxY 返回view底部的坐标
         - CGRectGetMinX 返回view左边缘的坐标
         - CGRectGetMaxX 返回view右边缘的坐标
         - CGRectGetMidX 表示得到一个view中心点的X坐标
         - CGRectGetMidY 表示得到一个view中心点的Y坐标
 
 
    4. ## UIView(TapBlock)
         -  简单方便的给veiw添加一个单击事件，使用block回调块处理点击
         -  简单方便的给veiw添加一个长按手势，使用block回调块处理点击
 
 
 
 
 -  # Comment中 第三方模块
 
 
    1. ## AvoidCrash_Doc
         - 防止由于NSArray、NSDictionary、NSString、KVC等问题引起的闪退
 
    2. ## ShareSDK_Doc
         - 用于QQ，微信，微博第三方平台的分享，和一键登录功能
 
    3. ## ZLPhotoLib_Doc
         - 获取本地图片，便于用户浏览选择照片
 
    4. ## AESCrypt_Doc          
         - 使用aes-256-cbc密码和base64编码对数据进行加密解密操作
 
    5. ## Keychain_Doc
         - 存储app的唯一标示符
 
    6. ## YYModel_Doc
         - 字典和模型的相互转换
 
    7. ## MJRefresh_Doc
         - 用于页面的刷新
 
    8. ## SAMTextView_Doc
         - 主要是给UITextView添加一个placeholder属性
 
    9. ## SDWebImage_Doc
         - 可以为‘UIImageView’,‘UIButton’添加web图像和缓存管理
 
   10. ## UMeng_Doc
         - 友盟统计
 
   11. ## Masonry_Doc
         - 一个使用简单方便的页面布局框架
 
   12. ## VponAD_Doc
         - vpon广告，包含banner，全屏，原生广告三种种类
 
   13. ## MBProgressHUD_Doc
         - 用于项目中加载数据时候，显示页面loading指示器
 
   14. ## LGActionSheet_Doc
         - 多样化的定制UIActionSheet弹出视图的UI布局
 
   15. ## UIAlertView+Blocks_Doc
         - 对UIAlertView添加了block块支持，可以直接处理点击事件
 
   17. ## HTHorizontalSelectionList_Doc
         - 主要实现了一个横向滚动的选择列表视图
 
 
 */

#import <Foundation/Foundation.h>

@interface BKSDKList : NSObject


@end
