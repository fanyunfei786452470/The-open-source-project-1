//
//  YRLikeListHeightModel.m
//  YRYZ
//
//  Created by Mrs_zhang on 16/8/29.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRLikeListHeightModel.h"

@implementation YRLikeListHeightModel

@synthesize likeListArr = _likeListArr;

- (void)setLikeListArr:(NSMutableArray *)likeListArr{

    _likeListArr = likeListArr;
}

- (CGFloat)likeListHeight{

    CGFloat cellH;
    
    if (self.likeListArr.count == 0) {
            cellH = 0.0f;
    }else{
        if (SCREEN_WIDTH == 320.f) {
            cellH = (self.likeListArr.count-1)/6 +1;
        }else if (SCREEN_WIDTH == 375.f){
            cellH = (self.likeListArr.count-1)/7 +1;
        }else{
            cellH = (self.likeListArr.count-1)/8 +1;
        }
    }
    
    CGFloat height = cellH*40 >1 ? cellH*40+10 : cellH*40;
    
    return height;
}

@end
