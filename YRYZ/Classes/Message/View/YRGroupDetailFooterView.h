//
//  YRGroupDetailFooterView.h
//  YRYZ
//
//  Created by Mrs_zhang on 16/7/13.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YRGroupDetailFooterViewDelegate <NSObject>

- (void)didClickDeleteGroupChat;

@end

@interface YRGroupDetailFooterView : UIView

@property (nonatomic,weak) id<YRGroupDetailFooterViewDelegate> delegate;

@end
