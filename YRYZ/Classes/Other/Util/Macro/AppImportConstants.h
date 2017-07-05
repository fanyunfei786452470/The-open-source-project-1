
#ifndef yryz_AppImportConstants_h
#define yryz_AppImportConstants_h



#import "AppImportConstants.h"
#import "ThirdPartyConstants.h"
#import "NotificationConstants.h"

// RAC
#import <ReactiveCocoa/RACEXTKeyPathCoding.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>

#import <Masonry.h>
#import "YYKit.h"

#import "MJRefresh.h"
#import "MJExtension.h"

#import "UIColor+Helper.h"
#import "UIImage+Extension.h"

#import "Category.h"
#import "YRAlertView.h"


#import "BaseModel.h"
#import "UITextView+Placeholder.h"
#import "YRHttpRequest.h"


#import "YRUserInfoManager.h"
#import "UIScrollView+EmptyDataSet.h"


#import "JPUSHService.h"
#import "NSArray+YRInfo.h"

#import "YRYYCache.h"

//修饰符  __weak  /  __unsafe_unretained
#if __has_feature(objc_arc_weak)
#define _WEAK __weak
#else
#define _WEAK __unsafe_unretained
#endif

//  id / instancetype
#if __has_feature(objc_instancetype)
#define INSTANCETYPE instancetype
#else
#define INSTANCETYPE id
#endif


//strong / retain
#if __has_feature(objc_arc)
#define STRONG strong
#else
#define STRONG retain
#endif

//assign / unsafe_unretained / weak
#if __has_feature(objc_arc_weak)
#define WEAK weak
#elif __has_feature(objc_arc)
#define WEAK unsafe_unretained
#else
#define WEAK assign
#endif

#define AFNETWORKING_ALLOW_INVALID_SSL_CERTIFICATES

#ifdef DEBUG
#define DLog( s, ... ) NSLog( @"<%@:(%d)>: %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define DLog( s, ... )
#endif


// 系统控件默认高度
#define STATUSBARHEIGHT       (20.0f)
#define TOPBARHEIGHT          (([[UIApplication sharedApplication] statusBarOrientation] ==UIInterfaceOrientationLandscapeLeft || [[UIApplication sharedApplication] statusBarOrientation] ==UIInterfaceOrientationLandscapeRight)?32.0f:44.0f)
#define BOTTOMHEIGHT          (49.0f)
#define kNavigationBarHeight    44
#define YRMargin              10


// 当前系统版本
#define SYSTEMVERSION         ([[[UIDevice currentDevice] systemVersion] doubleValue])

#define SCREEN_BOUNDS   [UIScreen mainScreen].bounds
#define SCREEN_WIDTH    ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT   ([UIScreen mainScreen].bounds.size.height)
#define kKeyWindow [UIApplication sharedApplication].keyWindow


#define YRRectMake(left,top,width,height) CGRectMake((left)*SCREEN_WIDTH/320,SCREEN_HEIGHT==480?(top):(top)*SCREEN_HEIGHT/568,(width)*SCREEN_WIDTH/320,SCREEN_HEIGHT==480?(height):(height)*SCREEN_HEIGHT/568)

#define YRSizeMake(width,height) CGSizeMake((width)*SCREEN_WIDTH/320,SCREEN_HEIGHT==480?(height):(height)*SCREEN_HEIGHT/568)

#define SCREEN_POINT (float)SCREEN_WIDTH/375.f
#define SCREEN_H_POINT (float)SCREEN_HEIGHT/667.f

#define YRSCREEN_POINT (float)SCREEN_WIDTH/320.f
#define YRSCREEN_H_POINT (float)SCREEN_HEIGHT/568.f


#define CJSizeMake(width,height) CGSizeMake((width)*(SCREEN_POINT),(height)*(SCREEN_H_POINT))

#define CJRectMake(left,top,width,height) CGRectMake((left)*(SCREEN_POINT),(top)*(SCREEN_H_POINT),(width)*(SCREEN_POINT),(height)*(SCREEN_H_POINT))


#define kDevice_Is_iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define kDevice_Is_iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define kDevice_Is_iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)


#define dispatch_main_sync_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_sync(dispatch_get_main_queue(), block);\
}


#define dispatch_main_async_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}



//https://github.com/sunnyxx/TodoMacro
// 转成字符串
#define STRINGIFY(S) #S
// 需要解两次才解开的宏
#define DEFER_STRINGIFY(S) STRINGIFY(S)
#define PRAGMA_MESSAGE(MSG) _Pragma(STRINGIFY(message(MSG)))
// 为warning增加更多信息
#define FORMATTED_MESSAGE(MSG) "[TODO-" DEFER_STRINGIFY(__COUNTER__) "] " MSG " \n" DEFER_STRINGIFY(__FILE__) " line " DEFER_STRINGIFY(__LINE__)
// 使宏前面可以加@
#define KEYWORDIFY try {} @catch (...) {}
// 最终使用的宏
#define TODO(MSG) KEYWORDIFY PRAGMA_MESSAGE(FORMATTED_MESSAGE(MSG))

#endif
