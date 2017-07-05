//
//  YRFriendsShowViewController.h
//  YRYZ
//
//  Created by Mrs_zhang on 16/7/12.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YRFriendsShowViewController : UIViewController
typedef enum
{
    kFSendShowType              = 2001,//好友发布晒一晒
    kFForwardWorksType          = 2002,//好友转发作品
    kFSendWorksOrTextType       = 2003,//好友发布作品(文字)
    kFSendWorksOrAudioType      = 2004,//好友发布作品(声音)
    kFSendWorksOrVideoType      = 2005,//好友发布作品(视频)
    
} NotificationType;//枚举名称
@end
