//
//  YRAudioDetailController.h
//  YRYZ
//
//  Created by weishibo on 16/8/15.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "BaseViewController.h"
#import "YRProductListModel.h"


@protocol NewAudioPlayDelegate <NSObject>

- (void)newAudioPlayDelegate:(NSInteger)readStatus;

@end



@interface YRNewAudioDetailViewController : BaseViewController
@property(strong ,nonatomic)YRProductListModel  *productListModel;
@property(strong ,nonatomic)NSString            *productId;



@property (nonatomic ,assign) id<NewAudioPlayDelegate>   audioPlayDelegate;


@property (nonatomic ,assign) CGFloat                       commentHeigt;//内容高度

@property (nonatomic,strong) UIImage                        *shareImage;

@end
