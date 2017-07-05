




/********************* 有任何问题欢迎反馈给我 liuweiself@126.com ****************************************/
/***************  https://github.com/waynezxcv/Gallop 持续更新 ***************************/
/******************** 正在不断完善中，谢谢~  Enjoy ******************************************************/

#import "LWLayout.h"
#import "StatusModel.h"

/**
 *  要添加一些其他属性，可以继承自LWLayout
 */

@interface SunTextCellLayout : LWLayout

@property (nonatomic,assign) CGFloat cellHeight;
@property (nonatomic,assign) CGRect lineRect;
@property (nonatomic,assign) CGRect lineLikeRect;
@property (nonatomic,assign) CGRect lineGiftRect;
@property (nonatomic,strong) NSMutableArray *picArray;
@property (nonatomic,assign) CGRect menuPosition;
@property (nonatomic,assign) CGRect commentBgPosition;
@property (nonatomic,assign) CGRect headImgPosition;
@property (nonatomic,copy) NSArray* imagePostionArray;
@property (nonatomic,strong) StatusModel* statusModel;
@property (nonatomic,assign) CGRect websiteRect;
@property (nonatomic,assign) CGRect videoRect;
@property (nonatomic,assign) CGRect videoBtnRect;
@property (nonatomic,assign) CGRect deleteBtnRect;
@property (nonatomic,assign) CGRect moreCommentRect;

@property (nonatomic,strong) UIImage *picImg;



- (id)initWithStatusModel:(StatusModel *)stautsModel
                    index:(NSInteger)index
            dateFormatter:(NSDateFormatter *)dateFormatter;



@end
