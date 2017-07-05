//
//  YRTagView.m
//  YRYZ
//
//  Created by 21.5 on 16/9/8.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRTagView.h"

@implementation YRTagView

-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        selectedBtnList = [[NSMutableArray alloc] init];
//        self.clickBackgroundColor = [UIColor whiteColor];
//        self.clickTitleColor = TextColor;
        self.clickArray = nil;
        self.clickbool = YES;
        self.borderSize = 0.5;
        self.clickborderSize =0.5;
    }
    return self;
}

-(void)setTagsFrame:(YRTagFrame *)tagsFrame {
    
    _tagsFrame = tagsFrame;
    NSLog(@"%@",_tagsFrame.UidArray);
    for (NSInteger i=0; i<tagsFrame.tagsArray.count; i++) {
        UIButton *tagsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [tagsBtn setTitle:tagsFrame.tagsArray[i] forState:UIControlStateNormal];
        [tagsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [tagsBtn setTitleColor:[UIColor themeColor] forState:UIControlStateSelected];
        tagsBtn.titleLabel.font = TagTitleFont;
        tagsBtn.tag = [[tagsFrame.UidArray objectAtIndex:i] integerValue];
        [tagsBtn setBackgroundImage:[UIImage imageNamed:@"yr_buttontag_bg"] forState:UIControlStateNormal];
        [tagsBtn setBackgroundImage:[UIImage imageNamed:@"yr_button_selected"] forState:UIControlStateSelected];
        tagsBtn.frame = CGRectFromString(tagsFrame.tagsFrames[i]);
        [tagsBtn addTarget:self action:@selector(TagsBtn:) forControlEvents:UIControlEventTouchDown];
        tagsBtn.enabled = _clickbool;
        [self addSubview:tagsBtn];
    }
    
}

#pragma mark 选中背景颜色
-(void)setClickBackgroundColor:(UIColor *)clickBackgroundColor{
    
    if (_clickBackgroundColor != clickBackgroundColor) {
        _clickBackgroundColor = clickBackgroundColor;
    }
}

#pragma makr 选中字体颜色
-(void)setClickTitleColor:(UIColor *)clickTitleColor{
    
    if (_clickTitleColor != clickTitleColor) {
        _clickTitleColor = clickTitleColor;
    }
}

#pragma makr 能否被选中
-(void)setClickbool:(BOOL)clickbool{
    
    _clickbool = clickbool;
    
}

#pragma makr 未选中边框大小
-(void)setBorderSize:(CGFloat)borderSize{
    
    if (_borderSize!=borderSize) {
        _borderSize = borderSize;
    }
}

#pragma makr 选中边框大小
-(void)setClickborderSize:(CGFloat)clickborderSize{
    
    if (_clickborderSize!= clickborderSize) {
        _clickborderSize = clickborderSize;
    }
}

#pragma makr 默认选择 单选
-(void)setClickString:(NSString *)clickString{
    
    if (_clickString != clickString) {
        _clickString = clickString;
    }
    if ([_tagsFrame.tagsArray containsObject:_clickString]) {
        
        NSInteger index = [_tagsFrame.tagsArray indexOfObject:_clickString];
        [self ClickString:index];
    }
}

#pragma mark 默认选择 多选
-(void)setClickArray:(NSArray *)clickArray{
    
    if (_clickArray != clickArray) {
        _clickArray = clickArray;
    }
    
    for (NSString *string in clickArray) {
        
        if ([_tagsFrame.tagsArray containsObject:string]) {
            
            NSInteger index = [_tagsFrame.tagsArray indexOfObject:string];
            NSString *x = [[NSString alloc] initWithFormat:@"%ld",(long)index];
            [self ClickArray:x];
        }
        
    }
    
}

#pragma makr 单选
-(void)ClickString:(NSInteger )index{
    
    UIButton *btn;
    for (id obj in self.subviews) {
        if ([obj isKindOfClass:[UIButton class]]) {
            btn = (UIButton *)obj;
            if (btn.tag == index){
                
                btn.backgroundColor = [UIColor whiteColor];
                [btn setTitleColor:_clickTitleColor forState:UIControlStateNormal];
                [self makeCorner:_clickborderSize view:btn color:_clickTitleColor];
                [_delegate YRTagView:@[[NSString stringWithFormat:@"%ld",(long)index]]];
                
            }else{
                
                btn.backgroundColor = [UIColor whiteColor];
                [btn setTitleColor:TextColor forState:UIControlStateNormal];
                [self makeCorner:_borderSize view:btn color:UIColorRGBA(221, 221, 221, 1)];
                
            }
        }
    }
}


#pragma mark 多选
-(void)ClickArray:(NSString *)index{
    
    UIButton *btn;
    for (id obj in self.subviews) {
        if ([obj isKindOfClass:[UIButton class]]) {
            btn = (UIButton *)obj;
            if (btn.tag == [index integerValue]){
                if ([selectedBtnList containsObject:index]) {
                    if (selectedBtnList.count>4) {
                        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        [selectedBtnList removeObject:index];
                        [btn setBackgroundImage:[UIImage imageNamed:@"yr_buttontag_bg"] forState:UIControlStateNormal];
                        [_delegate YRTagView:selectedBtnList];
                    }else{
                        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        [selectedBtnList removeObject:index];
                        [btn setBackgroundImage:[UIImage imageNamed:@"yr_buttontag_bg"] forState:UIControlStateNormal];
                        [_delegate YRTagView:selectedBtnList];
                    }
                }else{
                    if (selectedBtnList.count>4) {
                        [MBProgressHUD showError:@"最多可添加5个标签"];
                    }else{
                        [btn setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
                        [btn setBackgroundImage:[UIImage imageNamed:@"yr_button_selected"] forState:UIControlStateNormal];
                        [selectedBtnList addObject:index];
                        [_delegate YRTagView:selectedBtnList];
                    }
                    
                }
                
            }
        }
        
    }
    
}

-(void)makeCorner:(CGFloat)corner view:(UIView *)view color:(UIColor *)color{
    
    CALayer * fileslayer = [view layer];
    fileslayer.borderColor = [color CGColor];
    fileslayer.borderWidth = corner;
    
}

-(void)TagsBtn:(UIButton *)sender{
    
    if (self.clickStart == 0) {
        //单选
        [self ClickString:sender.tag];
        
    }else{
        //多选
//        sender.selected =!sender.selected

        NSString *x = [[NSString alloc] initWithFormat:@"%ld",(long)sender.tag];
        [self ClickArray:x];
    }
}

@end
