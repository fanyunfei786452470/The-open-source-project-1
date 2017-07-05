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
@interface YRAudioMainViewController ()

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
    [self setRightNavButtonWithTitle:@"发布"];
    [self setUpChildControllers];
    
}

- (void)rightNavAction:(UIButton *)button{
    
    YRSoundRecordingViewController *soundRecordingViewController = [[YRSoundRecordingViewController alloc]init];
    soundRecordingViewController.dataSource = self.typeDataSource;
    [self.navigationController pushViewController:soundRecordingViewController animated:YES];
 }

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

// 添加子控制器
- (void)setUpChildControllers{
    
    [self.typeDataSource enumerateObjectsUsingBlock:^(YRInfoProductTypeModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        YRAudioViewController *audioController = [[YRAudioViewController alloc]init];
        audioController.title = model.channelName;
        audioController.model = model;
        [self addChildViewController:audioController];
        
//        DLog(@"name:%@ typeId:%@ Id:%@",model.channelName,model.channelPid,model.uid);
    }];
    
}


@end
