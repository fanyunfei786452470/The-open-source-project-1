//
//  YRSunTextDetailViewController.h
//  YRYZ
//
//  Created by Mrs_zhang on 16/7/20.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "YRSunTextDetailHeaderModel.h"

@protocol YRSunTextDetailViewControllerDelegate <NSObject>

- (void)deleteSunTextWithIndexPath:(NSIndexPath *)index;

@end

@interface YRSunTextDetailViewController : BaseViewController

@property (nonatomic,strong) YRSunTextDetailHeaderModel *headerViewModel;

@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,strong) NSIndexPath *seleteIndex;

@property (nonatomic,weak) id<YRSunTextDetailViewControllerDelegate> delegate;
//@property (nonatomic,strong) NSDictionary *dic;
@property (nonatomic,assign) int sid;


@end
