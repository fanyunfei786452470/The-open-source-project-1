
/********************* 有任何问题欢迎反馈给我 liuweiself@126.com ****************************************/
/***************  https://github.com/waynezxcv/Gallop 持续更新 ***************************/
/******************** 正在不断完善中，谢谢~  Enjoy ******************************************************/
#import "SunTextCellLayout.h"
#import "LWTextParser.h"
#import "CommentModel.h"
#import "Gallop.h"
#import "NSString+EmojiAdditions.h"

NSString *const kPngRangeValue = @"bytes=16-23";
NSString *const kJpgRangeValue = @"bytes=0-209";
NSString *const kGifRangeValue = @"bytes=6-9";



@implementation SunTextCellLayout

- (id)initWithStatusModel:(StatusModel *)statusModel
                    index:(NSInteger)index
            dateFormatter:(NSDateFormatter *)dateFormatter {
    self = [super init];
    if (self) {
        self.statusModel = statusModel;
        //头像模型 avatarImageStorage
        LWImageStorage* avatarStorage = [[LWImageStorage alloc] initWithIdentifier:@"image"];
        avatarStorage.contents = statusModel.custImg;
        avatarStorage.cornerRadius = 5.0f;
        avatarStorage.cornerBackgroundColor = [UIColor whiteColor];
        avatarStorage.backgroundColor = RGB_COLOR(245, 245, 245);
        avatarStorage.frame = CGRectMake(10, 20, 40, 40);
        avatarStorage.tag = 101;
        avatarStorage.cornerBorderWidth = 1.0f;
        avatarStorage.cornerBorderColor = RGB(113, 129, 161, 1);
        self.headImgPosition = avatarStorage.frame;
        
        //名字模型 nameTextStorage
        LWTextStorage* nameTextStorage = [[LWTextStorage alloc] init];
        NSString *name = statusModel.nameNotes?statusModel.nameNotes:statusModel.custNname;
        nameTextStorage.text = name?name:@"昵称";
        nameTextStorage.backgroundColor = RGB_COLOR(245, 245, 245);
        nameTextStorage.font = [UIFont boldSystemFontOfSize:16.f];
        nameTextStorage.frame = CGRectMake(60.0f, 20.0f, SCREEN_WIDTH - 80.0f, CGFLOAT_MAX);
        [nameTextStorage lw_addLinkWithData:[NSString stringWithFormat:@"%@",statusModel.custNname?statusModel.custNname:@"昵称"]
                                      range:NSMakeRange(0,name.length?name.length:2)
                                  linkColor:[UIColor themeColor]
                             highLightColor:RGB(0, 0, 0, 0.15)];
        //生成时间的模型 dateTextStorage
        LWTextStorage* dateTextStorage = [[LWTextStorage alloc] init];
        dateTextStorage.text = [NSString getTimeFormatterWithString:statusModel.timeStamp];
        dateTextStorage.font = [UIFont systemFontOfSize:14.f];
        dateTextStorage.textColor = RGB_COLOR(153, 153, 153);
        dateTextStorage.frame = CGRectMake(nameTextStorage.left, nameTextStorage.bottom, SCREEN_WIDTH - 80.0f, CGFLOAT_MAX);
        
        //正文内容模型 contentTextStorage
        LWTextStorage* contentTextStorage = [[LWTextStorage alloc] init];
        contentTextStorage.text = statusModel.content;
        contentTextStorage.font = [UIFont systemFontOfSize:17.f];
        contentTextStorage.textColor = RGB(51, 51, 51, 1);
        contentTextStorage.frame = CGRectMake(avatarStorage.left, avatarStorage.bottom + 10.0f, SCREEN_WIDTH - 20.0f, CGFLOAT_MAX);
        [LWTextParser parseEmojiWithTextStorage:contentTextStorage];
        [LWTextParser parseTopicWithLWTextStorage:contentTextStorage
                                        linkColor:[UIColor themeColor]
                                   highlightColor:RGB(0, 0, 0, 0.15)];
        //发布的图片模型 imgsStorage
        CGFloat imageWidth = (SCREEN_WIDTH - 50.0f)/3.0f;
        NSInteger imageCount = [statusModel.pics count];
        NSMutableArray* imageStorageArray = [[NSMutableArray alloc] initWithCapacity:imageCount];
        NSMutableArray* imagePositionArray = [[NSMutableArray alloc] initWithCapacity:imageCount];
        
        LWImageStorage* videoImage = [[LWImageStorage alloc] initWithIdentifier:@"image"];
        if ([self.statusModel.type isEqualToString:@"image"]) {
            NSInteger row = 0;
            NSInteger column = 0;
            if (imageCount == 1) {
                NSString* URLString = [statusModel.pics objectAtIndex:0][@"url"];
                CGRect imageRect;
//
//                if (statusModel.onePicW != 0 && statusModel.onePicH != 0) {
//                    
//                    if (statusModel.onePicW>statusModel.onePicH) {
//                        imageRect = CGRectMake(avatarStorage.left,
//                                               contentTextStorage.bottom + 5.0f + (row * (imageWidth + 5.0f)),
//                                               (imageWidth*1.7*statusModel.onePicW/statusModel.onePicH)>(SCREEN_WIDTH-20)?(SCREEN_WIDTH-20):(imageWidth*1.7*statusModel.onePicW/statusModel.onePicH),
//                                               imageWidth*1.7);
//                    }else if (statusModel.onePicH>statusModel.onePicW){
//                        imageRect = CGRectMake(avatarStorage.left,
//                                               contentTextStorage.bottom + 5.0f + (row * (imageWidth + 5.0f)),
//                                               imageWidth*1.7,
//                                               (imageWidth*1.7*statusModel.onePicH/statusModel.onePicW)>(SCREEN_WIDTH-20)?(SCREEN_WIDTH-20):(imageWidth*1.7*statusModel.onePicH/statusModel.onePicW));
//                    }else{
//                        imageRect = CGRectMake(avatarStorage.left,
//                                               contentTextStorage.bottom + 5.0f + (row * (imageWidth + 5.0f)),
//                                               imageWidth*1.7,
//                                               imageWidth*1.7);
//                    }
//
//                }else{
//                    //                CGSize imgSize = [self getImageSizeWithURL:URLString];
//                    NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:URLString]];
//                    UIImage *image = [UIImage imageWithData:data];
//                    
//                    statusModel.onePicH = image.size.height;
//                    statusModel.onePicW = image.size.width;
//                    
//                    
//                    if (image.size.width>image.size.height) {
//                        imageRect = CGRectMake(avatarStorage.left,
//                                               contentTextStorage.bottom + 5.0f + (row * (imageWidth + 5.0f)),
//                                               (imageWidth*1.7*image.size.width/image.size.height)>(SCREEN_WIDTH-20)?(SCREEN_WIDTH-20):(imageWidth*1.7*image.size.width/image.size.height),
//                                               imageWidth*1.7);
//                    }else if (image.size.height>image.size.width){
//                        imageRect = CGRectMake(avatarStorage.left,
//                                               contentTextStorage.bottom + 5.0f + (row * (imageWidth + 5.0f)),
//                                               imageWidth*1.7,
//                                               (imageWidth*1.7*image.size.height/image.size.width)>(SCREEN_WIDTH-20)?(SCREEN_WIDTH-20):(imageWidth*1.7*image.size.height/image.size.width));
//                    }else{
                        imageRect = CGRectMake(avatarStorage.left,
                                               contentTextStorage.bottom + 5.0f + (row * (imageWidth + 5.0f)),
                                               imageWidth*1.7,
                                               imageWidth*1.7);
//                    }
//                }
                                NSString* imagePositionString = NSStringFromCGRect(imageRect);
                                [imagePositionArray addObject:imagePositionString];
                                LWImageStorage* imageStorage = [[LWImageStorage alloc] initWithIdentifier:@"image"];
                                imageStorage.tag = 0;
                                imageStorage.clipsToBounds = YES;
                                imageStorage.frame = imageRect;
                                imageStorage.backgroundColor = RGB(240, 240, 240, 1);
                                imageStorage.contents = [NSURL URLWithString:URLString];
                                [imageStorageArray addObject:imageStorage];
                                
                                [self.picArray addObject:imageStorage];
                
        } else {
                for (NSInteger i = 0; i < imageCount; i ++) {
                    LWImageStorage* imageStorage = [[LWImageStorage alloc] initWithIdentifier:@"image"];

                        CGRect imageRect = CGRectMake(avatarStorage.left + (column * (imageWidth + 5.0f)),
                                                      contentTextStorage.bottom + 5.0f + (row * (imageWidth + 5.0f)),
                                                      imageWidth,
                                                      imageWidth);
                        NSString* imagePositionString = NSStringFromCGRect(imageRect);
                        [imagePositionArray addObject:imagePositionString];
                        imageStorage.clipsToBounds = YES;
                        imageStorage.tag = i;
                        imageStorage.frame = imageRect;
                        imageStorage.backgroundColor = RGB(240, 240, 240, 1);
                        NSString* URLString = [statusModel.pics objectAtIndex:i][@"url"];
                        imageStorage.contents = [NSURL URLWithString:URLString];
                        [imageStorageArray addObject:imageStorage];
                        column = column + 1;
                 
                       if (column > (imageCount == 4?1:2)) {
                            column = 0;
                            row = row + 1;
                        }

                    [self.picArray addObject:imageStorage];
                }
            }
            videoImage.frame = CGRectZero;

        }else if ([self.statusModel.type isEqualToString:@"video"]) {
            
            videoImage.frame = CGRectMake(avatarStorage.left,contentTextStorage.bottom + 5.0f,SCREEN_WIDTH - 20.0f,200.0f);
            videoImage.backgroundColor = RGB(245, 245, 245, 1);
            videoImage.contents = statusModel.videoPic;
            videoImage.contentMode = UIViewContentModeScaleAspectFill;
            videoImage.clipsToBounds = YES;

            
            self.videoRect = CGRectMake(avatarStorage.left,contentTextStorage.bottom + 5.0f,SCREEN_WIDTH - 20.0f,200.0f);
            self.videoBtnRect = CGRectMake((SCREEN_WIDTH- 100)/2, contentTextStorage.bottom + 5.0f+65.f, 100, 70);

        }
        //获取最后一张图片的模型
        LWImageStorage* lastImageStorage = (LWImageStorage *)[imageStorageArray lastObject];
   
        //菜单按钮
        CGRect menuPosition;
        CGRect deletePosition;
        
        CGFloat menuY;
        
        if ([self.statusModel.type isEqualToString:@"video"]) {
            
            menuPosition = CGRectMake(SCREEN_WIDTH - 215.0f,contentTextStorage.bottom+10+200+10,195,35);
            menuY = contentTextStorage.bottom +45 +210;
            deletePosition =  CGRectMake(5, contentTextStorage.bottom+10+200+10, 40, 20);
            
        }else{
            if (lastImageStorage) {
                menuPosition = CGRectMake(SCREEN_WIDTH - 215.0f,lastImageStorage.bottom+10,195,35);
                menuY = lastImageStorage.bottom +45;
                deletePosition =  CGRectMake(5, lastImageStorage.bottom+10, 40, 20);

            } else {
                menuPosition = CGRectMake(SCREEN_WIDTH - 215.0f,contentTextStorage.bottom+10,195,35);
                menuY = contentTextStorage.bottom +45;
                deletePosition =  CGRectMake(5, contentTextStorage.bottom+10, 40, 20);
            }
        }
        
        //生成评论背景Storage
        LWImageStorage* commentBgStorage = [[LWImageStorage alloc] init];
        NSArray* commentTextStorages = @[];
        CGRect commentBgPosition = CGRectZero;
        CGRect rect = CGRectMake(10.0f,menuY + 5.0f, SCREEN_WIDTH - 30, 20);
        CGFloat offsetY = 0.0f;
        
        //点赞
        LWImageStorage* likeImageSotrage = [[LWImageStorage alloc] init];
        LWTextStorage* likeCountStorage = [[LWTextStorage alloc] init];
        LWTextStorage* likeTextStorage = [[LWTextStorage alloc] init];
        
        if (self.statusModel.likes.count != 0) {
            likeImageSotrage.contents = [UIImage imageNamed:@"yr_sunText_like"];
            if (SYSTEMVERSION <9.0) {
                likeImageSotrage.frame = CGRectMake(rect.origin.x + 10.0f,rect.origin.y + 13.0f + offsetY,15.0f, 15.0f);
            }else{
                likeImageSotrage.frame = CGRectMake(rect.origin.x + 10.0f,rect.origin.y + 16.0f + offsetY,15.0f, 15.0f);
            }
            NSMutableString* mutableString = [[NSMutableString alloc] init];
            NSMutableArray* composeArray = [[NSMutableArray alloc] init];
            int rangeOffset = 0;
            for (NSInteger i = 0;i < self.statusModel.likes.count; i ++) {
                NSString* liked = self.statusModel.likes[i][@"custNname"];
                NSString* nliked = self.statusModel.likes[i][@"nameNotes"];
                NSString *likeName = nliked?nliked:liked;
                NSString *likes = likeName?likeName:@"昵称";
                [mutableString appendString:likes];
                NSRange range = NSMakeRange(rangeOffset, likeName.length?likeName.length:2);
                [composeArray addObject:[NSValue valueWithRange:range]];
                rangeOffset += likeName.length;
                if (i != self.statusModel.likes.count - 1) {
                    NSString* dotString = @"、";
                    [mutableString appendString:dotString];
                    rangeOffset += 1;
                }
            }
            
            likeTextStorage.text = mutableString;
            likeTextStorage.font = [UIFont systemFontOfSize:16.f];
            likeTextStorage.frame = CGRectMake(likeImageSotrage.right + 5.0f, rect.origin.y + 10.0f, SCREEN_WIDTH - 100.0f, 30);
            likeCountStorage.frame = CGRectMake(SCREEN_WIDTH - 100.0f, rect.origin.y + 12.0f, 70, 20);
            likeCountStorage.font = [UIFont systemFontOfSize:16.f];
            likeCountStorage.textColor = [UIColor grayColor];
            likeCountStorage.textAlignment = NSTextAlignmentRight;
            likeCountStorage.text = [NSString stringWithFormat:@"%ld",self.statusModel.likeCount];
            
            for (NSInteger i = 0;i < composeArray.count; i ++) {
                NSRange range = [composeArray[i] rangeValue];
                CommentModel* commentModel = [[CommentModel alloc] init];
                commentModel.to = [likeTextStorage.text substringWithRange:range];
                commentModel.index = index;
                commentModel.custId = self.statusModel.likes[i][@"custId"];
                [likeTextStorage lw_addLinkWithData:commentModel range:range linkColor:[UIColor themeColor] highLightColor:RGB(0, 0, 0, 0.15)];
            }
            
            offsetY += likeTextStorage.height + 5.0f; 
            self.lineLikeRect = CGRectMake(rect.origin.x, rect.origin.y + 8.0f + offsetY,  SCREEN_WIDTH - 30, 0.5f);
            commentBgPosition = CGRectMake(10.0f,menuY + 5.0f, SCREEN_WIDTH - 30, offsetY + 8.0f);
            commentBgStorage.frame = commentBgPosition;
            commentBgStorage.contents = [UIImage imageNamed:@"comment"];
            [commentBgStorage stretchableImageWithLeftCapWidth:40 topCapHeight:15];
        }

        //礼物
        LWImageStorage* giftImageSotrage = [[LWImageStorage alloc] init];
        LWTextStorage* giftTextStorage = [[LWTextStorage alloc] init];
        LWTextStorage* giftCountStorage = [[LWTextStorage alloc] init];

        if (self.statusModel.giftList.count != 0) {
            giftImageSotrage.contents = [UIImage imageNamed:@"yr_show_gift"];
            giftImageSotrage.frame = CGRectMake(rect.origin.x + 10.0f,rect.origin.y + 15.0f + offsetY,13.0f, 13.0f);
            NSMutableString* mutableString = [[NSMutableString alloc] init];
            NSMutableArray* composeArray = [[NSMutableArray alloc] init];
            int rangeOffset = 0;
            for (NSInteger i = 0;i < self.statusModel.giftList.count; i ++) {
                                
                NSString* gifted = self.statusModel.giftList[i][@"custNname"];
                NSString *gifts = gifted?gifted:@"昵称";

                [mutableString appendString:gifts];
                NSRange range = NSMakeRange(rangeOffset, gifted.length);
                [composeArray addObject:[NSValue valueWithRange:range]];
                rangeOffset += gifted.length;
                if (i != self.statusModel.giftList.count - 1) {
                    NSString* dotString = @"、";
                    [mutableString appendString:dotString];
                    rangeOffset += 1;
                }
            }
            giftTextStorage.text = mutableString;
            giftTextStorage.font = [UIFont systemFontOfSize:14.f];
            giftTextStorage.frame = CGRectMake(giftImageSotrage.right + 5.0f, giftImageSotrage.top-3, SCREEN_WIDTH - 100.0f, 20);
            giftCountStorage.frame = CGRectMake(SCREEN_WIDTH - 100.0f, rect.origin.y + 12.0f+ offsetY, 70, 20);
            giftCountStorage.font = [UIFont systemFontOfSize:14.f];
            giftCountStorage.textColor = [UIColor grayColor];
            giftCountStorage.textAlignment = NSTextAlignmentRight;
            giftCountStorage.text = [NSString stringWithFormat:@"%ld",self.statusModel.giftList.count];
            
            for (NSInteger i = 0;i < composeArray.count; i ++) {
                NSRange range = [composeArray[i] rangeValue];
                
                CommentModel* commentModel = [[CommentModel alloc] init];
                commentModel.to = [giftTextStorage.text substringWithRange:range];
                commentModel.index = index;
                commentModel.custId = self.statusModel.giftList[i][@"custId"];

                [giftTextStorage lw_addLinkWithData:commentModel range:range linkColor:[UIColor themeColor] highLightColor:RGB(0, 0, 0, 0.15)];
            }
            offsetY += giftTextStorage.height + 5.0f;
            
            //如果有评论，设置评论背景Storage
            self.lineGiftRect = CGRectMake(rect.origin.x, rect.origin.y + 8.0f + offsetY,  SCREEN_WIDTH - 30, 0.5f);
            commentBgPosition = CGRectMake(10.0f,menuY + 5.0f, SCREEN_WIDTH - 30, offsetY + 8.0f);
            commentBgStorage.frame = commentBgPosition;
            commentBgStorage.contents = [UIImage imageNamed:@"comment"];
            [commentBgStorage stretchableImageWithLeftCapWidth:40 topCapHeight:15];
           
        }
        
        LWTextStorage *moreComment = [[LWTextStorage alloc] init];
        LWImageStorage* commentImageSotrage = [[LWImageStorage alloc] init];
 
        if (statusModel.comments.count != 0 && statusModel.comments != nil) {
            commentImageSotrage.contents = [UIImage imageNamed:@"yr_show_comment"];
            
            NSDictionary *commentsDic = statusModel.comments[0];
            NSString* content = commentsDic[@"content"];
            if ([NSString stringContainsEmoji:content]) {
                commentImageSotrage.frame = CGRectMake(rect.origin.x + 10.0f,rect.origin.y + 17.0f + offsetY,15.0f, 15.0f);
            }else{
                commentImageSotrage.frame = CGRectMake(rect.origin.x + 10.0f,rect.origin.y + 14.0f + offsetY,15.0f, 15.0f);
            }
            
    
            NSMutableArray* tmp = [[NSMutableArray alloc] initWithCapacity:statusModel.comments.count];
            for (NSDictionary* commentDict in statusModel.comments) {
                

                    NSString* to = commentDict[@"authorName"];
                    NSString* nto = commentDict[@"authorNameNote"];
                    NSString *toName = nto?nto:to;
  
                    NSString *from = commentDict[@"custName"];
                    NSString *nfrom = commentDict[@"custNameNote"];
                    NSString *fromName = nfrom?nfrom:from;

                    if (toName.length != 0) {
                        NSString* commentString = [NSString stringWithFormat:@"%@回复%@: %@",fromName,toName,commentDict[@"content"]];
                        LWTextStorage* commentTextStorage = [[LWTextStorage alloc] init];
                        commentTextStorage.text = commentString;
                        commentTextStorage.font = [UIFont systemFontOfSize:16.f];
                        commentTextStorage.textColor = RGB(40, 40, 40, 1);
                        commentTextStorage.frame = CGRectMake(rect.origin.x + 30.0f, rect.origin.y + 10.0f + offsetY,SCREEN_WIDTH - 65.0f, CGFLOAT_MAX);
                        
                        CommentModel* commentModel1 = [[CommentModel alloc] init];
                        commentModel1.to = fromName;
                        commentModel1.index = index;
                        commentModel1.custId = commentDict[@"custId"];
                        [commentTextStorage lw_addLinkForWholeTextStorageWithData:commentModel1 linkColor:nil highLightColor:RGB(0, 0, 0, 0.15)];
                        
                        [commentTextStorage lw_addLinkWithData:commentModel1
                                                         range:NSMakeRange(0,[(NSString *)fromName length])
                                                     linkColor:[UIColor themeColor]
                                                highLightColor:RGB(0, 0, 0, 0.15)];
                        
                        CommentModel* commentModel2 = [[CommentModel alloc] init];
                        commentModel2.to = [NSString stringWithFormat:@"%@",toName];
                        commentModel2.index = index;
                        [commentTextStorage lw_addLinkWithData:commentModel2
                                                         range:NSMakeRange([(NSString *)fromName length] + 2,[(NSString *)toName length])
                                                     linkColor:[UIColor themeColor]
                                                highLightColor:RGB(0, 0, 0, 0.15)];
                        
                        [LWTextParser parseTopicWithLWTextStorage:commentTextStorage
                                                        linkColor:[UIColor themeColor]
                                                   highlightColor:RGB(0, 0, 0, 0.15)];
                        [LWTextParser parseEmojiWithTextStorage:commentTextStorage];
                        [tmp addObject:commentTextStorage];
                        offsetY += commentTextStorage.height+5;
                    } else {
                        NSString* commentString = [NSString stringWithFormat:@"%@: %@",fromName,commentDict[@"content"]];
                        LWTextStorage* commentTextStorage = [[LWTextStorage alloc] init];
                        commentTextStorage.text = commentString;
                        commentTextStorage.font = [UIFont systemFontOfSize:16.f];
                        commentTextStorage.textAlignment = NSTextAlignmentLeft;
                        commentTextStorage.linespacing = 2.0f;
                        commentTextStorage.textColor = RGB(40, 40, 40, 1);
                        commentTextStorage.frame = CGRectMake(rect.origin.x + 30.0f, rect.origin.y + 10.0f + offsetY,SCREEN_WIDTH - 65.0f, CGFLOAT_MAX);
                        
                        CommentModel* commentModel = [[CommentModel alloc] init];
                        commentModel.to = fromName;
                        commentModel.index = index;
                        commentModel.custId = commentDict[@"custId"];

                        [commentTextStorage lw_addLinkForWholeTextStorageWithData:commentModel linkColor:nil highLightColor:RGB(0, 0, 0, 0.15)];
                        [commentTextStorage lw_addLinkWithData:commentModel
                                                         range:NSMakeRange(0,[(NSString *)fromName length])
                                                     linkColor:[UIColor themeColor]
                                                highLightColor:RGB(0, 0, 0, 0.15)];
                        
                        [LWTextParser parseTopicWithLWTextStorage:commentTextStorage
                                                        linkColor:[UIColor themeColor]
                                                   highlightColor:RGB(0, 0, 0, 0.15)];
                        [LWTextParser parseEmojiWithTextStorage:commentTextStorage];
                        [tmp addObject:commentTextStorage];
                        offsetY += commentTextStorage.height+5;
                    }
                
            }
            
            //如果有评论，设置评论背景Storage
            if (statusModel.comments.count>= 5) {
                self.moreCommentRect = CGRectMake((SCREEN_WIDTH-30-100)/2+10, offsetY + 10.0f+menuY + 5.0f, 100,23.f);
                commentTextStorages = tmp;
                commentBgPosition = CGRectMake(10.0f,menuY + 5.0f, SCREEN_WIDTH - 30, offsetY + 10.0f+30.f);
                commentBgStorage.frame = commentBgPosition;
                commentBgStorage.contents = [UIImage imageNamed:@"comment"];
                [commentBgStorage stretchableImageWithLeftCapWidth:40 topCapHeight:15];
                
            }else{

                self.moreCommentRect = CGRectZero;
                commentTextStorages = tmp;
                commentBgPosition = CGRectMake(10.0f,menuY + 5.0f, SCREEN_WIDTH - 30, offsetY + 10.0f);
                commentBgStorage.frame = commentBgPosition;
                commentBgStorage.contents = [UIImage imageNamed:@"comment"];
                [commentBgStorage stretchableImageWithLeftCapWidth:40 topCapHeight:15];
            }
        }
        
        [self addStorage:videoImage];
        [self addStorage:nameTextStorage];
        [self addStorage:contentTextStorage];
        [self addStorage:dateTextStorage];
        [self addStorage:likeCountStorage];
        [self addStorage:giftCountStorage];
        [self addStorages:commentTextStorages];
        [self addStorage:avatarStorage];
        [self addStorage:commentBgStorage];
        [self addStorage:likeImageSotrage];
        [self addStorage:giftImageSotrage];
        [self addStorage:commentImageSotrage];
        [self addStorages:imageStorageArray];
        [self addStorage:moreComment];
        
        if (likeTextStorage) {
            [self addStorage:likeTextStorage];
        }
        if (likeTextStorage) {
            [self addStorage:giftTextStorage];
        }
        //一些其他属性
        self.deleteBtnRect     = deletePosition;
        self.menuPosition      = menuPosition;
        self.commentBgPosition = commentBgPosition;
        self.imagePostionArray = imagePositionArray;
        self.statusModel       = statusModel;
        //如果是使用在UITableViewCell上面，可以通过以下方法快速的得到Cell的高度
        
        CGFloat addH;
        if (statusModel.likes.count == 0 && statusModel.giftList.count == 0 && statusModel.comments.count == 0) {
            addH = 45.f;
        }else{
            addH = 0;
        }
        
        self.cellHeight = [self suggestHeightWithBottomMargin:15.0f] + addH;
    }
    
    return self;
}

//获取字符串的高度
-(float)heightForString:(NSString *)value fontSize:(float)fontSize{
    
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
    CGSize size = [value boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-20, CGFLOAT_MAX) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return size.height;
}

@end
