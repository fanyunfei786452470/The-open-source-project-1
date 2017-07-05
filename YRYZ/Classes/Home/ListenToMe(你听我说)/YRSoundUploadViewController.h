//
//  YRSoundUploadViewController.h
//  YRYZ
//
//  Created by Rongzhong on 16/8/9.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface YRSoundUploadViewController : BaseViewController

@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,copy) NSString *audioPath;

@property (nonatomic,copy) NSString *audioTime;
@end
