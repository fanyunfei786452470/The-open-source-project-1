//
//  YRCountdownView.m
//  YRYZ
//
//  Created by Sean on 16/8/10.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRCountdownView.h"
#import <Masonry.h>
#import <TYAttributedLabel.h>

@interface YRCountdownView ()

@property (nonatomic,strong) NSMutableArray *array;

@property (nonatomic,strong) NSTimer *time;
@end


@implementation YRCountdownView


- (instancetype)init
{
    self = [super init];
    if (self) {
        _num = 10;
        [self configUI];
    }
    return self;
}
- (void)configUI{
    UILabel *label = [[UILabel alloc]init];
    label.text = @"开奖倒计时";
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.width.equalTo(self);
        make.height.mas_equalTo(20);
        make.centerX.equalTo(self);
        
    }];
    TYAttributedLabel *image = [[TYAttributedLabel alloc]init];
    image.backgroundColor = [UIColor clearColor];
    NSInteger ten = _num%10;
    NSInteger ones = _num/10;
    NSString *first = [NSString stringWithFormat:@"yr_%ld_timer",ten];
    NSString *second = [NSString stringWithFormat:@"yr_%ld_timer",ones];
    
    UIImageView *one = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"yr_0_timer"]];
     UIImageView *two = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"yr_0_timer"]];
    UIImageView *mao = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"yr_mao_timer"]];
    mao.size = CGSizeMake(5, 25);
     UIImageView *three = [[UIImageView alloc]initWithImage:[UIImage imageNamed:second]];
     UIImageView *four = [[UIImageView alloc]initWithImage:[UIImage imageNamed:first]];
    [self.array addObject:three];
    [self.array addObject:four];
    
        [image appendView:one];
        [image appendText:@" "];
        [image appendView:two];
        [image appendText:@" "];
        [image addSubview:mao];
       [image appendText:@"    "];
     image.textAlignment = kCTTextAlignmentCenter;
    image.font = [UIFont boldSystemFontOfSize:20];
        [image appendView:three];
        [image appendText:@" "];
        [image appendView:four];
        
     [self addSubview:image];
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.top.equalTo(label.mas_bottom);
            make.bottom.equalTo(self.mas_bottom);
        }];
    
    [mao mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(image);
        make.top.equalTo(image.mas_top).mas_offset(10);
        make.size.mas_equalTo(YRSizeMake(5, 15));
    }];
    
    
    [self startAnim];
    
}

- (void)startAnim{
    self.num--;
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(animation) userInfo:self repeats:YES];
    _time = timer;
    
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}
- (void)animation{
    

    NSInteger ten = _num%10;
    NSInteger ones = _num/10;

    NSString *second = [NSString stringWithFormat:@"yr_%ld_timer",ten];
    

    if (ten==9&&self.num>0) {
        UIImageView *image1 = self.array[0];
        NSString *first = [NSString stringWithFormat:@"yr_%ld_timer",ones];
        image1.image = [UIImage imageNamed:first];
        
        CATransition *anim = [CATransition animation];
        
        anim.type = @"cube";
  
        anim.duration = 0.5;
        
        [image1.layer addAnimation:anim forKey:nil];
    }
    
    UIImageView *image2 = self.array[1];
    
    image2.image = [UIImage imageNamed:second];
    
    CATransition *anim = [CATransition animation];
    
    anim.type = @"cube";

    anim.duration = 0.5;
    
    [image2.layer addAnimation:anim forKey:nil];
    if (_num==0) {
        [_time setFireDate:[NSDate distantFuture]];
        self.mytime(YES);
    }
   self.num--;
    
    
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (NSMutableArray *)array
{
    if (!_array) {
        _array = [[NSMutableArray alloc]init];
    }
    return _array;
}

@end
