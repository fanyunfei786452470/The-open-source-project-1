//
//  SDContactsSearchResultController.h
//  GSD_WeiXin(wechat)
//
//  Created by gsd on 16/2/29.
//  Copyright © 2016年 GSD. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface SDContactsSearchResultController : UITableViewController


@property (strong, nonatomic) UIViewController* selfViewController;

/** 过滤后数组*/
@property (strong, nonatomic) NSArray *filterItems;

/** 输入字符串*/
@property (strong, nonatomic) NSString *inputStr;

/** <#注释#>*/
@property (copy, nonatomic) void(^searchFilterBlock)(NSString *custID);

@end
