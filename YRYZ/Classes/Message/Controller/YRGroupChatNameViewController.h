//
//  YRGroupChatNameViewController.h
//  YRYZ
//
//  Created by Mrs_zhang on 16/7/14.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YRGroupChatNameViewControllerDelegate <NSObject>

- (void)ChangeGroupChatName:(NSString *)name;

@end

@interface YRGroupChatNameViewController : UIViewController

@property (nonatomic,weak) id<YRGroupChatNameViewControllerDelegate> delegate;

@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *tribeId;

@end
