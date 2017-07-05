//
//  YRSunImageCell.h
//  YRYZ
//
//  Created by Mrs_zhang on 16/7/29.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRSunAddImageCell.h"

@protocol YRSunImageCellDelegate <NSObject>

- (void)didClickDelegatePhotoWithIndex:(NSIndexPath *)indexPath;

@end

@interface YRSunImageCell : YRSunAddImageCell

@property (nonatomic,weak) id<YRSunImageCellDelegate> delegate;
@property (nonatomic,strong) NSIndexPath* indexPath;

@end
