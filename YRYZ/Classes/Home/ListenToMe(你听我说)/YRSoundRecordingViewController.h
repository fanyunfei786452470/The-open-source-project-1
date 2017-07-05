//
//  YRSoundRecordingViewController.h
//  YRYZ
//
//  Created by Rongzhong on 16/8/4.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@protocol  YRSoundRecordingViewControllerDelegate<NSObject>

- (void)didClickDataSource:(NSMutableArray *)dataSource AudioPath:(NSString *)audioPath AudioTime:(NSString *)audioTime;

@end

@interface YRSoundRecordingViewController : BaseViewController


@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,strong) id<YRSoundRecordingViewControllerDelegate>  delegate;


@end
