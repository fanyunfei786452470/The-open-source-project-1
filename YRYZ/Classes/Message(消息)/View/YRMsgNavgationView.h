//
//  YRMgsNavgationView.h
//  YRYZ
//
//  Created by Mrs_zhang on 16/7/11.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^blk_t)(void);

@interface YRMsgNavgationView : UIView

@property (nonatomic,copy) blk_t msgBlock;
@property (nonatomic,copy) blk_t friendsShowBlock;
@property (nonatomic,copy) blk_t myShowBlock;

@end
