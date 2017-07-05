//
//  YRRotateButton.h
//  YRYZ
//
//  Created by Rongzhong on 16/7/21.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YRRotateButton : UIButton

typedef void (^TouchesBeganBlock)(NSSet<UITouch *> *touches);

typedef void (^TouchesMoveBlock)(NSSet<UITouch *> *touches);

typedef void (^TouchesEndBlock)(NSSet<UITouch *> *touches);

@property (strong, nonatomic) TouchesBeganBlock touchesBeganBlock;

@property (strong, nonatomic) TouchesMoveBlock touchesMoveBlock;

@property (strong, nonatomic) TouchesEndBlock touchesEndBlock;

@end
