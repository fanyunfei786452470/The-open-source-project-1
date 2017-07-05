//
//  YRRedPaperReceiveView.h
//  YRYZ
//
//  Created by Rongzhong on 16/7/14.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YRRedListModel.h"


@interface YRRedPaperReceiveView : UIView

typedef void (^LookRecordBlock)();

@property (strong, nonatomic) LookRecordBlock lookRecordBlock;

-(void)showAnimation;
- (instancetype)initWithFrame:(CGRect)frame  redModel:(YRRedListModel*)redModel;
@end
