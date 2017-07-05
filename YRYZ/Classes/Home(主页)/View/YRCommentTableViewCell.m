//
//  YRCommentTableViewCell.m
//  YRYZ
//
//  Created by weishibo on 16/8/15.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRCommentTableViewCell.h"

@interface YRCommentTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property(strong ,nonatomic)YRProuductCommentModel          *commentModel;
@end

@implementation YRCommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (void)setCommentModel:(YRProuductCommentModel *)commentModel{

    _commentModel = commentModel;
    
    self.nameLabel.text = commentModel.authorName;
    self.timeLabel.text = commentModel.time;
    [self.headImageView setImageWithURL:[NSURL URLWithString:commentModel.authorHeadimg] placeholder:[UIImage defaultHead]];
    self.commentLabel.text = commentModel.content;
    
}

@end
