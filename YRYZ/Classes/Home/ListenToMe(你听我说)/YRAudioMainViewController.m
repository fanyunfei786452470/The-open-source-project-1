//
//  YRAudioMainViewController.m
//  YRYZ
//
//  Created by weishibo on 16/8/3.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRAudioMainViewController.h"
#import "YRAudioViewController.h"
#import "YRSoundRecordingViewController.h"
#import "YRInfoProductTypeModel.h"
#import "YRSoundUploadViewController.h"



@interface YRAudioMainViewController ()<YRSoundRecordingViewControllerDelegate>

@end

@implementation YRAudioMainViewController


- (NSMutableArray*)typeDataSource{

    if (!_typeDataSource) {
        _typeDataSource = @[].mutableCopy;
    }
    return _typeDataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"你听我说";
    
    
    if (self.typeDataSource.count == 0 || !self.typeDataSource  ) {
        [self fectProductTypeList:kInfoTypeVoice];
    }
    
    [self setRightNavButtonWithImage:@"yr_show_edit" title:@"发布"];
    [self setUpChildControllers];
    
}

- (void)fectProductTypeList:(InfoProductType)type{
    
    [YRHttpRequest productTypeListAnd:type cacheKey:nil success:^(NSArray *data) {
                NSArray  *array =  [YRInfoProductTypeModel mj_objectArrayWithKeyValuesArray:data];
                [self.typeDataSource removeAllObjects];
                [self.typeDataSource addObjectsFromArray:array];
                [[YRYYCache share].yyCache removeObjectForKey:@"voicedataSource"];
                [[YRYYCache share].yyCache setObject:array forKey:@"voicedataSource"];
        
    } failure:^(NSString *data) {
        [MBProgressHUD showError:data];
    }];
    
}
- (void)rightNavAction:(UIButton *)button{
    
    if (![YRUserInfoManager manager].currentUser.custId) {
        [self noLoginTip];
        return;
    }
    
    YRSoundRecordingViewController *soundRecordingViewController = [[YRSoundRecordingViewController alloc]init];
    soundRecordingViewController.dataSource = self.typeDataSource;
    soundRecordingViewController.delegate = self;
    BaseNavigationController *navigation = [[BaseNavigationController alloc] initWithRootViewController:soundRecordingViewController];
    [self presentViewController:navigation animated:YES completion:nil];
 }

-(void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didClickDataSource:(NSMutableArray *)dataSource AudioPath:(NSString *)audioPath AudioTime:(NSString *)audioTime{

    YRSoundUploadViewController *soundUploadViewController = [[YRSoundUploadViewController alloc]init];
    soundUploadViewController.dataSource = dataSource;
    soundUploadViewController.audioPath = audioPath;
    soundUploadViewController.audioTime = audioTime;
    
    BaseNavigationController *navigation = [[BaseNavigationController alloc] initWithRootViewController:soundUploadViewController];
    [self presentViewController:navigation animated:YES completion:nil];

}

// 添加子控制器
- (void)setUpChildControllers{
    
    [self.typeDataSource enumerateObjectsUsingBlock:^(YRInfoProductTypeModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        
        YRAudioViewController *audioController = [[YRAudioViewController alloc]init];
        audioController.title                  = model.channelName;
        audioController.model                  = model;
        audioController.typeList = self.typeDataSource;
        [self addChildViewController:audioController];
        
    }];
    
}


@end
