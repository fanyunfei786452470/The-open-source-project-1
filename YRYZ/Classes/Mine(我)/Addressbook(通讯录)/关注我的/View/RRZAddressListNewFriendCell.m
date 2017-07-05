//
//  RRZAddressListNewFriendCell.m
//  Rrz
//
//  Created by 易超 on 16/3/4.
//  Copyright © 2016年 rongzhongwang. All rights reserved.
//

#import "RRZAddressListNewFriendCell.h"

@interface RRZAddressListNewFriendCell ()






@property (strong, nonatomic)FriendsModel  *friends;
@end

@implementation RRZAddressListNewFriendCell

+(RRZAddressListNewFriendCell *)tableView:(UITableView *)tableView  items:(FriendsModel *)items cellID:(NSString *)cellID{
    
    RRZAddressListNewFriendCell *cell = (RRZAddressListNewFriendCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[RRZAddressListNewFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.friends = items;
    
    return cell;
}

- (void)setFriends:(FriendsModel *)friends{
    _friends = friends;
    
    self.rightButton.layer.cornerRadius = 4;
    self.rightButton.layer.masksToBounds = YES;
    
//    if ([friends.custType isEqualToString:@"1"]) {
////        [self.rightButton setTitle:@"已添加" forState:UIControlStateDisabled];
//        self.rightButton.enabled = NO;
//        self.rightButton.backgroundColor = [UIColor clearColor];
//    }else{
////        [self.rightButton setTitle:@"已添加" forState:UIControlStateDisabled];
//        self.rightButton.enabled = YES;
//        self.rightButton.backgroundColor = Global_Color;
//    }
    
//    if (friends.custType == 1) {
//        self.rightButton.enabled = YES;
//        self.rightButton.backgroundColor = RGB_COLOR(61, 183, 128);
//    }else{
//        self.rightButton.enabled = NO;
//        self.rightButton.backgroundColor = [UIColor clearColor];
//    }
//    
//    
//    if (friends.isSel == YES) {
//        self.rightButton.enabled = NO;
//        self.rightButton.backgroundColor = [UIColor clearColor];
//    }else{
//        self.rightButton.enabled = YES;
//        self.rightButton.backgroundColor = Global_Color;
//    }
    
    if([friends.relation integerValue]==0){
        self.rightButton.enabled = YES;
        self.rightButton.backgroundColor = [UIColor themeColor];
        [self.rightButton setTitle:@"同意关注" forState:UIControlStateNormal];
    }else{
        self.rightButton.enabled = NO;
        [self.rightButton setTitle:@"已是好友" forState:UIControlStateNormal];
        self.rightButton.backgroundColor = [UIColor clearColor];
    }
    [self.iconImageView setImageWithURL:[NSURL URLWithString:friends.custImg] placeholder:[UIImage defaultHead]];
    if (friends.nameNotes.length>0) {
         self.titleLabel.text = friends.nameNotes;
    }else{
         self.titleLabel.text = friends.custNname;
    }
   
    self.subTitleLabel.text = friends.custSignature;
     
}

- (IBAction)addFriendsButtonClick:(UIButton *)sender {
    
    if ([self.friendDelegate respondsToSelector:@selector(listNewFriendCellAddFriend:cell:)]) {
        [self.friendDelegate listNewFriendCellAddFriend:self.friends cell:self];
    }
    sender.enabled = NO;
    sender.backgroundColor = [UIColor clearColor];
}

@end
