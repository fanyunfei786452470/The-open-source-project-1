//
//  YRSearchController.m
//  YRYZ
//
//  Created by weishibo on 16/8/16.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRSearchController.h"

@interface YRSearchController ()
<UISearchBarDelegate,UISearchResultsUpdating,UISearchControllerDelegate>

@property (strong, nonatomic) UISearchController        *searchController ;


@end

@implementation YRSearchController


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.searchController.active) {
        self.searchController.active = NO;
        [self.searchController.searchBar removeFromSuperview];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.active = NO;
}
- (instancetype)init {
    self = [super init];
    if (self) {
 
        self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        self.searchController.searchResultsUpdater = self;
        self.searchController.dimsBackgroundDuringPresentation = YES;
        self.searchController.hidesNavigationBarDuringPresentation = YES;
        self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
        self.searchController.searchBar.placeholder = @"搜索关键字";
        self.searchController.searchBar.barTintColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
        self.searchController.searchBar.tintColor = Global_Color;
         
        self.searchController.definesPresentationContext = YES;
        
//        UIImageView *view = [[[self.searchController.searchBar.subviews objectAtIndex:0] subviews] firstObject];
//        view.layer.borderColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1].CGColor;
//        view.layer.borderWidth = 1;
        
//         self.headView = [[UIView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 44)];
//        [self.headView  setBackgroundColor:[UIColor whiteColor]];
//        [self.searchController.searchBar setBackgroundColor:[UIColor redColor]];
//        [self.headView  addSubview:self.searchController.searchBar];
        
        self.searchController.searchBar.delegate = self;
        self.searchController.delegate = self;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = YES;
    for(UIView *view in  [[[searchBar subviews] objectAtIndex:0] subviews]) {
        if([view isKindOfClass:[NSClassFromString(@"UINavigationButton") class]]) {
            UIButton * cancel =(UIButton *)view;
            cancel.titleLabel.font = [UIFont systemFontOfSize:16];
        }
    }
}


#pragma mark - UISearchResultsUpdating
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
