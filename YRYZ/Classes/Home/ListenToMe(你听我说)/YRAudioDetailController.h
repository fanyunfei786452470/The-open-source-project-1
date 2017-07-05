//
//  YRAudioDetailController.h
//  YRYZ
//
//  Created by weishibo on 16/8/15.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "BaseViewController.h"
#import "YRProductListModel.h"


@protocol AudioPlayDelegate <NSObject>

- (void)audioPlayDelegate:(NSInteger)readStatus;

@end



@interface YRAudioDetailController : BaseViewController
@property(strong ,nonatomic)YRProductListModel *productListModel;



@property (nonatomic ,assign) id<AudioPlayDelegate>   audioPlayDelegate;


@property (nonatomic ,assign) CGFloat                  commentHeigt;//内容高度

@property (nonatomic,strong) UIImage                      *shareImage;


@property (nonatomic, assign) BOOL                           isOriginalWorks;//是否我的原创作品

@end
