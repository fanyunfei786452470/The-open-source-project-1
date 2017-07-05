//
//  RRZAddressCommendFriendCell.m
//  Rrz
//
//  Created by 易超 on 16/3/12.
//  Copyright © 2016年 rongzhongwang. All rights reserved.
//

#import "RRZAddressCommendFriendCell.h"

@interface RRZAddressCommendFriendCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;




@property (weak, nonatomic) IBOutlet UIButton *addButton;

@end

@implementation RRZAddressCommendFriendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.addButton.layer.cornerRadius = 3;
    self.addButton.layer.masksToBounds = YES;
//    [self.addButton setBackgroundImage:[UIImage imageWithColor:Global_Color andRect:self.addButton.bounds] forState:UIControlStateNormal];
//    [self.addButton setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor] andRect:self.addButton.bounds] forState:UIControlStateDisabled];
    
    self.iconImageView.layer.cornerRadius = 3;
    self.iconImageView.layer.masksToBounds = YES;
}


- (IBAction)addButtonClick:(UIButton *)sender {
    sender.enabled = NO;
    
    if ([self.friendDelegate respondsToSelector:@selector(listNewFriendCellAddFriend:)]) {
        [self.friendDelegate listNewFriendCellAddFriend:self.items];
    }
}

-(void)setItems:(RRZCommendFriend *)items{
    _items = items;
 
    [self.iconImageView setImageWithURL:[NSURL URLWithString:items.custImg] placeholder:[UIImage defaultHead]];
    
    self.titleLabel.text = items.nameNotes?items.nameNotes:items.custNname;
    self.subTitleLabel.text = items.signature;
    
//    if ([items.relation integerValue] == 0) {
//        self.addButton.enabled = YES;
//        [self.addButton setTitle:@"加关注" forState:UIControlStateNormal];
//        [self.addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        self.addButton.backgroundColor = [UIColor themeColor];
//    }else{
//        self.addButton.enabled = NO;
//        [self.addButton setTitle:@"已关注" forState:UIControlStateNormal];
//           [self.addButton setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
//        self.addButton.backgroundColor = RGB_COLOR(245, 245, 245);
//    }
       self.addButton.hidden = YES;
    
}

@end
