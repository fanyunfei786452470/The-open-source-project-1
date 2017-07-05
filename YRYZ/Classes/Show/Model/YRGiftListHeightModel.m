//
//  YRGiftListHeightModel.m
//  YRYZ
//
//  Created by Mrs_zhang on 16/8/29.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRGiftListHeightModel.h"

@implementation YRGiftListHeightModel

@synthesize giftListArr = _giftListArr;

- (void)setGiftListArr:(NSMutableArray *)giftListArr{

    _giftListArr = giftListArr;
}

- (CGFloat)giftListHeight{
    
    CGFloat cellH;
    
    if (self.giftListArr.count == 0) {
            cellH = 0.0f;
    }else{
        if (SCREEN_WIDTH == 320.f) {
            cellH = (self.giftListArr.count-1)/3 +1;
        }else if (SCREEN_WIDTH == 375.f){
            cellH = (self.giftListArr.count-1)/3 +1;
        }else{
            cellH = (self.giftListArr.count-1)/4 +1;
        }
    }
    
    CGFloat height = cellH*40 >1 ? cellH*40+10 : cellH*40;
    
    return height;
}

@end
