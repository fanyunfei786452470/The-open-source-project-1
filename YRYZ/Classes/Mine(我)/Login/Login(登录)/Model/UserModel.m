//
//  UserModel.m
//  Rrz
//
//  Created by weishibo on 16/3/2.
//  Copyright © 2016年 rongzhongwang. All rights reserved.
//

#import "UserModel.h"
#import "YRYYCache.h"
@interface UserModel()
@property (nonatomic,strong) NSTimer *myTimer;

@end
@implementation UserModel
//@synthesize isOpenLottery = _isOpenLottery;
- (NSString*)token{
    if (!_token || _token.length == 0) {
        _token = @"";
    }
    return _token;
}
- (void)setCustQr:(NSString *)custQr{
    
    if ([custQr hasPrefix:@"http://"]) {
        _custQr = custQr;
    }else{
        NSString *qr = [NSString stringWithFormat:@"http://yryz.%@",custQr];
        _custQr = qr;
    }
}
+ (UserModel*)getObjcByid:(NSString*)objc_id{
    NSDictionary *userdic = (NSDictionary*)[[YRYYCache share].yyCache objectForKey:objc_id];
    UserModel *user = [UserModel mj_objectWithKeyValues:userdic];
    return user;
}


- (void)setIsbusy:(NSString *)isbusy{
    _isbusy = isbusy;

}
//- (void)setIsOpenLottery:(BOOL)isOpenLottery{
//    _isOpenLottery = isOpenLottery;
//    if (_isOpenLottery) {
//        self.seconds = 60;
//        self.myTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countdown) userInfo:self repeats:YES];
//        [[NSRunLoop currentRunLoop] addTimer:self.myTimer forMode:NSRunLoopCommonModes];
//    }else{
//        [self.myTimer setFireDate:[NSDate distantFuture]];
//        self.myTimer = nil;
//        self.seconds = 0;
//    }
//}
//- (void)countdown{
//    self.seconds--;
//}


@end



@implementation UserDefaultCardModel



@end
