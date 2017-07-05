//
//  RRZAdListBlackListCell.m
//  Rrz
//
//  Created by 易超 on 16/6/24.
//  Copyright © 2016年 rongzhongwang. All rights reserved.
//

#import "RRZAdListBlackListCell.h"


@interface RRZAdListBlackListCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *subLabel;

@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@end

@implementation RRZAdListBlackListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.rightBtn.layer.cornerRadius = 4;
    self.rightBtn.layer.masksToBounds = YES;
    self.rightBtn.backgroundColor = RGB_COLOR(245, 245, 245);
    self.rightBtn.enabled = NO;
    
    [self.rightBtn setTitleColor:[UIColor themeColor]  forState:UIControlStateNormal];
   
}

-(void)setItem:(RRZGoodFriendItem *)item{
//     [self.rightBtn setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
    _item = item;
    [self.iconImageView setImageWithURL:[NSURL URLWithString:item.custImg] placeholder:[UIImage defaultHead]];
    if (item.nameNotes.length>=1) {
        self.nameLabel.text = item.nameNotes;
    }else{
        self.nameLabel.text = item.custNname;
    }
    self.subLabel.text = item.custSignature;
}

@end
