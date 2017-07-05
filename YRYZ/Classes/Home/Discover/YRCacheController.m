//
//  YRCacheController.m
//  YRYZ
//
//  Created by Sean on 16/9/2.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRCacheController.h"
#import "YRMyCacheModel.h"
#import "YRYYCache.h"
#import <UIImageView+YYWebImage.h>
@interface YRCacheController ()

@property (nonatomic,strong) NSMutableArray *array;

@end

@implementation YRCacheController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat width = (self.view.frame.size.width/4)-10;
    NSArray *name = @[@"萧炎",@"姬无命",@"辰南",@"林修涯"];
    NSArray *sex = @[@(0),@1,@1,@0];
    NSArray *imageName = @[@"http://ww3.sinaimg.cn/mw690/63e6fd01jw1esenz2rq9qj218g18g4fx.jpg",
                           @"http://ww3.sinaimg.cn/mw690/63e6fd01jw1ez58fhendrj20hs0hswfj.jpg",
                           @"http://ww4.sinaimg.cn/mw690/63e6fd01jw1eu3g19eds1j20qo0qowkb.jpg",@"http://ww4.sinaimg.cn/mw690/63e6fd01jw1eu3g19eds1j20qo0qowkb.jpg"];
    
    
    
     NSArray *model = (NSArray *)[[YRYYCache share].yyCache objectForKey:@"myModel"];
    
    
    for (int i = 0; i<4; i++) {
        
        YRMyCacheModel *model = [[YRMyCacheModel alloc]init];
        model.name = name[i];
     
        model.sex = [sex[i] boolValue];
        model.imageName = imageName[i];
        
    
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(i*width,300, width, width)];
    
        [image setImageWithURL:[NSURL URLWithString:model.imageName] placeholder:[UIImage defaultImage]];
        
        
        

        image.backgroundColor = [UIColor randomColor];
        [self.view addSubview:image];
        [self.array addObject:model];
    }
    
    [[YRYYCache  share].yyCache setObject:self.array forKey:@"myModel"];
    
  
    DLog(@"%@",model);
    
}
- (NSMutableArray *)array
{
    if (!_array) {
        _array = [[NSMutableArray alloc]init];
    }
    return _array;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end




































