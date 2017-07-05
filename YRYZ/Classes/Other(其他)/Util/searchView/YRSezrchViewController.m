//
//  YRSezrchViewController.m
//  YRYZ
//
//  Created by Sean on 16/8/30.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRSezrchViewController.h"

@interface YRSezrchViewController ()<UISearchResultsUpdating>

@end

@implementation YRSezrchViewController


- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)congigUI{
    self.dimsBackgroundDuringPresentation = NO;
    self.hidesNavigationBarDuringPresentation = YES;
    self.searchBar.frame = CGRectMake(self.searchBar.frame.origin.x, self.searchBar.frame.origin.y, self.searchBar.frame.size.width, 44.0);
    self.searchBar.layer.borderWidth = 1;
    self.searchBar.layer.borderColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1].CGColor;
    
    self.searchResultsUpdater = self;
}
#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
 
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
