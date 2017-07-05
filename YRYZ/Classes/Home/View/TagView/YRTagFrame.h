//
//  YRTagFrame.h
//  YRYZ
//
//  Created by 21.5 on 16/10/19.
//  Copyright © 2016年 yryz. All rights reserved.
//


#define TagTitleFont [UIFont systemFontOfSize:13]

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface YRTagFrame : NSObject
/** 标签名字数组 */
@property (nonatomic, strong) NSArray *tagsArray;
@property (nonatomic,strong)NSArray * UidArray;
/** 标签frame数组 */
@property (nonatomic, strong) NSMutableArray *tagsFrames;
/** 全部标签的高度 */
@property (nonatomic, assign) CGFloat tagsHeight;
/** 标签间距 default is 10*/
@property (nonatomic, assign) CGFloat tagsMargin;
/** 标签行间距 default is 10*/
@property (nonatomic, assign) CGFloat tagsLineSpacing;
/** 标签最小内边距 default is 10*/
@property (nonatomic, assign) CGFloat tagsMinPadding;
@end
