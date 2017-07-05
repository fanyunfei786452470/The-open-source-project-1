//
//  YRRedAdsPaymentModel.h
//  YRYZ
//
//  Created by 21.5 on 16/9/13.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "BaseModel.h"

@interface YRRedAdsPaymentModel : BaseModel

@property (nonatomic,copy)NSString * adsTitle;//广告标题
@property (nonatomic,copy)NSString * adsSmallPic;//列表小图片地址
@property (nonatomic,assign)NSInteger picCount;//图片的数量
@property (nonatomic,copy)NSString * content;//广告主题内容
@property (nonatomic,assign)NSInteger  adsType;// 广告类型
@property (nonatomic,assign)NSInteger  payDays;//购买的天数
@property (nonatomic,copy)NSString *  wishUpData;//期望上架时间
@property (nonatomic,copy)NSString * phone;//广告联系方式
@property (nonatomic,copy)NSString * adsInfoPath;//视频广告地址
@property (nonatomic,copy)NSString * adsDesc;//广告简介
@end
