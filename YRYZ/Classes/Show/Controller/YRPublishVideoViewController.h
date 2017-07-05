//
//  YRPublishVideoViewController.h
//  YRYZ
//
//  Created by Mrs_zhang on 16/8/12.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YRPublishVideoViewControllerDelegate <NSObject>

- (void)getPublishVideoShowSunTextWithDic:(NSDictionary *)dic;

@end

@interface YRPublishVideoViewController : UIViewController


@property (nonatomic,copy) NSString *videoPath;

@property (nonatomic,copy) NSString *thumbnailPath;

@property (nonatomic,weak) id<YRPublishVideoViewControllerDelegate> delegate;


@end
