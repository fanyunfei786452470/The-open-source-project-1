//
//  YRAdsTipView.m
//  YRYZ
//
//  Created by 21.5 on 16/9/8.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRAdsTipView.h"

#import <Masonry.h>
@implementation YRAdsTipView

- (instancetype)initWithFrame:(CGRect)frame{

    self= [super initWithFrame:frame];
    if (self) {
        
        [self addView];
        [self setFrame];
        self.backgroundColor = RGB_COLOR(240, 240, 240);
    }
    return self;
}

#pragma make -getter

- (void)addView{

        [self addSubview:self.firstImage];
        [self addSubview:self.secondImage];
        [self addSubview:self.firstLable];
        [self addSubview:self.secondLable];

}

#pragma mark - setter 

- (UIImageView *)firstImage{

    if (!_firstImage) {
        _firstImage = [[UIImageView alloc]init];
        [_firstImage setImage:[UIImage imageNamed:@"1"]];

    }
    return _firstImage;
}

- (UIImageView *)secondImage{

    if (!_secondImage) {
        _secondImage = [[UIImageView alloc]init];
        [_secondImage setImage:[UIImage imageNamed:@"2"]];
    
    }
    return _secondImage;
}

- (UILabel *)firstLable{

    if (!_firstLable) {
        _firstLable = [[UILabel alloc]init];
        _firstLable.textColor = RGB_COLOR(153, 153, 153);
        [_firstLable setFont:[UIFont systemFontOfSize:12]];
    }
    return _firstLable;
}
- (UILabel *)secondLable{
 
    if (!_secondLable) {
        _secondLable = [[UILabel alloc]init];
        _secondLable.textColor = RGB_COLOR(153, 153, 153);
        [_secondLable setFont:[UIFont systemFontOfSize:12]];
    }
    return _secondLable;
}

#pragma make -getter
- (void)setFrame{

    [self.firstImage mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(6.5);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    [self.firstLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.firstImage.mas_right).offset(5);
        make.top.mas_equalTo(self.firstImage.mas_top);
        make.height.mas_equalTo(self.firstImage.mas_height);
        make.width.mas_equalTo((SCREEN_WIDTH - 50));
    }];
    [self.secondImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.firstImage.mas_left);
        make.top.mas_equalTo(self.firstImage.mas_bottom).offset(6.5);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    [self.secondLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.secondImage.mas_right).offset(5);
        make.top.mas_equalTo(self.secondImage.mas_top);
        make.height.mas_equalTo(self.secondImage.mas_height);
        make.width.mas_equalTo((SCREEN_WIDTH - 50));
    }];

    
}

#pragma mark - getText

- (void)setFirstText:(NSString *)firstText{
    
    self.firstLable.text = firstText;
}
- (void)setSecondText:(NSString *)secondText{

    self.secondLable.text = secondText;
}

@end
