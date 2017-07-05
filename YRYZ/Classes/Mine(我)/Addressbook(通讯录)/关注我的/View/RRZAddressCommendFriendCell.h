//
//  RRZAddressCommendFriendCell.h
//  Rrz
//
//  Created by 易超 on 16/3/12.
//  Copyright © 2016年 rongzhongwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RRZCommendFriend.h"


@protocol RRZAddressListNewFriendCellAddButtonDelegate <NSObject>
-(void)listNewFriendCellAddFriend:(RRZCommendFriend*)item;
@end

@interface RRZAddressCommendFriendCell : UITableViewCell

@property(nonatomic , assign)id<RRZAddressListNewFriendCellAddButtonDelegate> friendDelegate;

/** <#注释#>*/
@property (strong, nonatomic) RRZCommendFriend *items;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@end
