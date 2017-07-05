//
//  CollectionViewCell.h
//  share
//
//  Created by Sean on 16/7/19.
//  Copyright © 2016年 Sean. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *title;

@end
