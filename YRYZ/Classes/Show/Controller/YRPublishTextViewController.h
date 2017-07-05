//
//  YRPublishViewController.h
//  YRYZ
//
//  Created by Mrs_zhang on 16/7/28.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@protocol YRPublishTextViewControllerDeletate <NSObject>

- (void)getYRPublishTextShowSunTextWithDic:(NSDictionary *)dic;

@end

@interface YRPublishTextViewController : BaseViewController

@property (nonatomic,strong) NSMutableArray *imageArr;

@property (nonatomic,assign) BOOL isText;

@property (nonatomic,weak) id<YRPublishTextViewControllerDeletate> delegate;

@end
