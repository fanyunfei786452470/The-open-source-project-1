//
//  YRMsgDetailViewController.h
//  YRYZ
//
//  Created by Mrs_zhang on 16/7/13.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <WXOpenIMSDKFMWK/YWFMWK.h>


@interface YRMsgDetailViewController : UIViewController

@property (nonatomic, strong) YWIMKit *imKit;

@property (nonatomic, strong) YWPerson *person;

@end
