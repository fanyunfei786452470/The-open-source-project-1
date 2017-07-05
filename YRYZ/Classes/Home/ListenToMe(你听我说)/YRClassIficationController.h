//
//  YRClassIficationController.h
//  YRYZ
//
//  Created by Sean on 16/8/13.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "BaseViewController.h"
typedef void(^SeleteTypeblk_t)(NSString *typeId ,NSString* typeName);

@interface YRClassIficationController : BaseViewController

@property (nonatomic,strong) NSMutableArray *videoTypeArr;

@property (nonatomic,copy) NSString *typeName;

@property (nonatomic,copy) SeleteTypeblk_t seleteType;

- (void)returnSeleteType:(SeleteTypeblk_t)block;
@end
