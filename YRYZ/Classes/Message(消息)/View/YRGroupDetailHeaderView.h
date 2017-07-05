//
//  YRGroupDetailHeaderView.h
//  YRYZ
//
//  Created by Mrs_zhang on 16/7/13.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YRGroupDetailHeaderViewDelegate <NSObject>
- (void)didSeleteAddGroupChat;
- (void)didSeleteMinusGroupChat;
- (void)didSeleteLookAllGroupPeople;

@end

@interface YRGroupDetailHeaderView : UIView


@property (nonatomic,weak) id<YRGroupDetailHeaderViewDelegate> delegate;

@property (nonatomic,strong) NSMutableArray *dataSource;



@end
