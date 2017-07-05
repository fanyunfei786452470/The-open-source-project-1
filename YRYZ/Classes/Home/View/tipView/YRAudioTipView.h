//
//  YRAudioTipView.h
//  YRYZ
//
//  Created by 21.5 on 16/9/13.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YRAudioTipView : UIView

- (instancetype)initWithFrame:(CGRect)frame;
@property (nonatomic,strong)UIImageView * firstImage;
@property (nonatomic,strong)UIImageView * secondImage;
@property (nonatomic,strong)UILabel * firstLable;
@property (nonatomic,strong)UILabel * secondLable;
@property (nonatomic,strong)NSString * firstText;
@property (nonatomic,strong)NSString * secondText;
@property (nonatomic,strong)UIImageView * thirdImage;
@property (nonatomic,strong)UILabel * thirdLable;
@property (nonatomic,strong)NSString * thirdText;

@end
