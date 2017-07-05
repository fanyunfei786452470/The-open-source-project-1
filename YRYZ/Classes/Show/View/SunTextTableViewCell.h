
/********************* 有任何问题欢迎反馈给我 liuweiself@126.com ****************************************/
/***************  https://github.com/waynezxcv/Gallop 持续更新 ***************************/
/******************** 正在不断完善中，谢谢~  Enjoy ******************************************************/

#import <UIKit/UIKit.h>
#import "SunTextCellLayout.h"
#import "Gallop.h"


@class SunTextTableViewCell;

@protocol TableViewCellDelegate <NSObject>

- (void)tableViewCell:(SunTextTableViewCell *)cell didClickedImageWithCellLayout:(SunTextCellLayout *)layout atIndex:(NSInteger)index;

- (void)tableViewCell:(SunTextTableViewCell *)cell didClickedLinkWithData:(id)data atIndexPath:(NSIndexPath *)indexPath;

- (void)tableViewCell:(SunTextTableViewCell *)cell didClickedHeaderImgWithIndexPath:(NSIndexPath *)indexPath;

- (void)tableViewCell:(SunTextTableViewCell *)cell didClickedCommentWithCellLayout:(SunTextCellLayout *)layout atIndexPath:(NSIndexPath *)indexPath;

- (void)tableViewCell:(SunTextTableViewCell *)cell didClickedLikeButtonWithIsLike:(NSInteger)isLike atIndexPath:(NSIndexPath *)indexPath;

- (void)tableViewCell:(SunTextTableViewCell *)cell didClickedGiftButtonWithIsGift:(BOOL)isGift atIndexPath:(NSIndexPath *)indexPath;

- (void)tableViewCell:(SunTextTableViewCell *)cell didClickedPlayVideoButtonWithIndexPath:(NSIndexPath *)indexPath;

- (void)tableViewCell:(SunTextTableViewCell *)cell didClickedDeleteButtonWithIndexPath:(NSIndexPath *)indexPath;

- (void)tableViewCell:(SunTextTableViewCell *)cell didClickedLookMoreCommentButtonWithIndexPath:(NSIndexPath *)indexPath;
@end

@interface SunTextTableViewCell : UITableViewCell

@property (nonatomic,weak) id <TableViewCellDelegate> delegate;
@property (nonatomic,strong) SunTextCellLayout* cellLayout;
@property (nonatomic,strong) NSIndexPath* indexPath;


@end


