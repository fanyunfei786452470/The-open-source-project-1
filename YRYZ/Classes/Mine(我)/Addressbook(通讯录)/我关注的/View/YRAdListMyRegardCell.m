//
//  YRAdListMyRegardCell.m
//  Rrz
//
//  Created by 易超 on 16/7/8.
//  Copyright © 2016年 rongzhongwang. All rights reserved.
//

#import "YRAdListMyRegardCell.h"

@interface YRAdListMyRegardCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *subLabel;

@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

@end

@implementation YRAdListMyRegardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(void)setItem:(RRZGoodFriendItem *)item{
    
    _item = item;
    [self.iconImageView setImageWithURL:[NSURL URLWithString:item.custImg] placeholder:[UIImage defaultHead]];
    if (item.nameNotes.length>1) {
        self.nameLabel.text = item.nameNotes;
    }else{
        self.nameLabel.text = item.custNname;
    }
    self.subLabel.text = item.custSignature;
    
//    if (item.custType == 1) {
//        [self.rightBtn setTitle:@"已关注" forState:UIControlStateDisabled];
//    }else if (item.custType == 3){
//        [self.rightBtn setTitle:@"互相关注" forState:UIControlStateDisabled];
//    }else{
//        [self.rightBtn setTitle:@"" forState:UIControlStateDisabled];
//    }
    
    if([item.relation integerValue]==1){
        self.rightBtn.enabled = YES;
        self.rightBtn.backgroundColor = [UIColor clearColor];
        [self.rightBtn setTitle:@"已是好友" forState:UIControlStateNormal];
        [self.rightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }else{
        self.rightBtn.enabled = NO;
        [self.rightBtn setTitle:@"等待对方同意" forState:UIControlStateNormal];
        [self.rightBtn.titleLabel sizeToFit];
        [self.rightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        self.rightBtn.backgroundColor = [UIColor clearColor];
    }
    
    
    
}

@end
