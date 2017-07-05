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
    
    self.nameLabel.font = [UIFont titleFont15];
    
    UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    longPressGr.minimumPressDuration           = 1.0;
    [self.contentView addGestureRecognizer:longPressGr];
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (void)setCommentModel:(YRProuductCommentModel *)commentModel{
    
    _commentModel = commentModel;
    self.nameLabel.textColor = RGB_COLOR(27, 194, 184);
   
    self.nameLabel.text = commentModel.authorNameNotes.length>0?commentModel.authorNameNotes :commentModel.authorName;
    self.timeLabel.text = [NSString getTimeFormatterWithString:commentModel.time];
    self.timeLabel.font = [UIFont titleFont14];
    [self.headImageView setImageWithURL:[NSURL URLWithString:commentModel.authorHeadimg ?commentModel.authorHeadimg  :commentModel.userHeadimg ] placeholder:[UIImage defaultHead]];
   [self.headImageView setCircleHeadWithPoint:CGPointMake(30  , 30) radius:4];
    if (commentModel.type == 1) {
        self.commentLabel.text = commentModel.content;
    }else{
        NSString *titleStr = [NSString stringWithFormat:@"回复%@:%@",commentModel.userNameNotes ? commentModel.userNameNotes:commentModel.userName,commentModel.content];
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:titleStr];
        NSArray *highlightStrs = @[commentModel.userName ? commentModel.userName : @""];
        
        for (NSString * hStr in highlightStrs) {
            
            NSRange hRange = [titleStr rangeOfString: hStr];
            
            [attrStr addAttribute:NSFontAttributeName
                            value:[UIFont titleFont15]
                            range:hRange];
            [attrStr addAttribute:NSForegroundColorAttributeName
                            value:[UIColor themeColor]
                            range:hRange];
            
        }
        self.commentLabel.attributedText = attrStr;
    }
}


/**
 *  @author ZX, 16-08-26 14:08:33
 *
 *  长按删除评论
 *
 */
-(void)longPressToDo:(UILongPressGestureRecognizer *)gesture {
    
    if ([self.commentModel.authorId isEqualToString:[YRUserInfoManager manager].currentUser.custId] || [self.commentModel.userid isEqualToString:[YRUserInfoManager manager].currentUser.custId] ) {
        if(gesture.state == UIGestureRecognizerStateBegan){
            if ([self.delegate respondsToSelector:@selector(didClickLongPressGestureRecognizerCellWithIndexPath:)]){
                [self.delegate didClickLongPressGestureRecognizerCellWithIndexPath:self.indexPath];
            }
        }
    }
    
}



@end
