//
//  AddressBook.h
//  Rrz
//
//  Created by weishibo on 16/3/7.
//  Copyright © 2016年 rongzhongwang. All rights reserved.
//
#import "BaseModel.h"
#import <AddressBook/AddressBook.h>

typedef void(^isPermissions)(BOOL isYes,NSArray *allInfo);


@interface AddressBook : BaseModel

@property NSInteger sectionNumber;
@property NSInteger recordID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *tel;

@property (nonatomic,copy) isPermissions info;


+ (NSArray *)readAllPeoplesHeader;
- (void)readAllPeoplesNumAndName;




@end
