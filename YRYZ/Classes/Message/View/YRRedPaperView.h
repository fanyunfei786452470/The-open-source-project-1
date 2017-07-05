//
//  YRRedPaperView.h
//  YRYZ
//
//  Created by Rongzhong on 16/7/5.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YRRedPaperView : UIView

typedef void (^OpenBlock)();

@property (strong, nonatomic) OpenBlock openBlock;

@property (strong, nonatomic) NSString      *nameText;

@property (strong, nonatomic) UIImageView   *redPaperBgView;


+(void)showRedPaperViewWithName:(NSString*)name OpenBlock:(void(^)())openblock;

@end
