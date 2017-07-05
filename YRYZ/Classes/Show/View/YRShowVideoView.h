//
//  AskGameView.h
//  BoardGame
//
//  Created by 张享 on 16/3/11.
//  Copyright © 2016年 ZX. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YRShowVideoViewDelegate <NSObject>


@end

@interface YRShowVideoView : UIView

/**
 *  数据
 */
@property (nonatomic,strong) NSArray *data;

/**
 *  标题
 */
@property (nonatomic,copy) NSString *title;

@property (nonatomic,weak) id<YRShowVideoViewDelegate> delegate;

/**
 *  显示
 */
- (void)show;
- (instancetype)initWithFrame:(CGRect)frame IsRequest:(BOOL)isRequest WithPathOrUrl:(NSString *)pathOrUrl;
@end
