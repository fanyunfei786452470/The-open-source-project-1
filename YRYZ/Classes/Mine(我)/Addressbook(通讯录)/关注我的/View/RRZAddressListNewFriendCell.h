//
//  RRZAddressListNewFriendCell.h
//  Rrz
//
//  Created by 易超 on 16/3/4.
//  Copyright © 2016年 rongzhongwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendsModel.h"

@class RRZAddressListNewFriendCell;

@protocol RRZAddressListNewFriendCellAddButtonDelegate <NSObject>
-(void)listNewFriendCellAddFriend:(FriendsModel*)item cell:(RRZAddressListNewFriendCell *)cell;
@end

@interface RRZAddressListNewFriendCell : UITableViewCell


+(RRZAddressListNewFriendCell *)tableView:(UITableView *)tableView  items:(FriendsModel *)items cellID:(NSString *)cellID;

@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property(nonatomic , assign)id<RRZAddressListNewFriendCellAddButtonDelegate> friendDelegate;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@end
