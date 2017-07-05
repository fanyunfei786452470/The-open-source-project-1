//
//  YRCircleEarningsView.h
//  YRYZ
//
//  Created by 21.5 on 16/9/22.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YRCircleListModel.h"
@protocol YRCircleEarningsViewDelegate <NSObject>
//邀请
- (void)invitateRransmitcircle:(YRCircleListModel*)circle;

@end
@interface YRCircleEarningsView : UIView
@property (strong,nonatomic)YRCircleListModel* circleModel;
@property(nonatomic,weak)id<YRCircleEarningsViewDelegate>delegate;
/**
 *  带NavigationBar呈现方法：
 *  @param info        使用一登登录后回调的Info，广告视窗的title会根据Info内容使用不同的文案，传入的内容为用户回调信息的persona部分
 *  @param image       开发者的广告图
 *  @param color       弹出视窗的边框颜色
 *
 */

//- (void)showWithFaceInfo: (NSDictionary *)info advertisementImage: (UIImage *)image borderColor: (UIColor *)color;


//不带NavigationBar呈现方法：
- (void)showWithFaceInfo: (NSDictionary *)info advertisementImage: (UIImage *)image borderColor: (UIColor *)color circle:(YRCircleListModel *)circle;
@end
