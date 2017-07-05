//
//  YRAdsTipView.h
//  YRYZ
//
//  Created by 21.5 on 16/9/8.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YRAdsTipView : UIView

- (instancetype)initWithFrame:(CGRect)frame;
@property (nonatomic,strong)UIImageView * firstImage;
@property (nonatomic,strong)UIImageView * secondImage;
@property (nonatomic,strong)UILabel * firstLable;
@property (nonatomic,strong)UILabel * secondLable;
@property (nonatomic,strong)NSString * firstText;
@property (nonatomic,strong)NSString * secondText;

@end
