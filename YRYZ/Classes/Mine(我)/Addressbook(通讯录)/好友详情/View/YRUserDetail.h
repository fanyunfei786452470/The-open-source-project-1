//
//  YRUserDetail.h
//  YRYZ
//
//  Created by Sean on 16/8/25.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "BaseModel.h"

@interface YRUserDetail : BaseModel

@property (nonatomic,copy) NSString *custDesc;
@property (nonatomic,copy) NSString *custNname;
/**<#name#>**/
@property (nonatomic,copy) NSString *custDevId;
/**<#name#>**/
@property (nonatomic,copy) NSString *custId;
/**<#name#>**/
@property (nonatomic,copy) NSString *custImg;
@property (nonatomic,copy) NSString *custName;
/**<#name#>**/
@property (nonatomic,copy) NSString *custLevel;

/**<#name#>**/
@property (nonatomic,copy) NSString *custLocation;

/**<#name#>**/
@property (nonatomic,copy) NSString *custPhone;
/**<#name#>**/
@property (nonatomic,copy) NSString *custQr;

/**<#name#>**/
@property (nonatomic,copy) NSString *custSex;

@property (nonatomic,copy) NSString *custSignature;

@property (nonatomic,copy) NSString *nameNotes;

@property (nonatomic,copy) NSString *relation;

@end
