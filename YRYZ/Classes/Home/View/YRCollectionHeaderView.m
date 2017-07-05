//
//  YRCollectionHeaderView.m
//  YRYZ
//
//  Created by Sean on 16/9/9.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRCollectionHeaderView.h"

@interface YRCollectionHeaderView ()
@property (weak, nonatomic) IBOutlet UISearchBar *search;

@end

@implementation YRCollectionHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.search.placeholder = @"搜索关键字";
    self.search.barTintColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    self.search.tintColor = Global_Color;
    self.search.layer.borderWidth = 1;
    self.search.layer.borderColor = RGB_COLOR(245, 245, 245).CGColor;
    self.search.userInteractionEnabled = NO;
}

@end
