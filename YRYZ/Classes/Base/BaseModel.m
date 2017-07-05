//
//  BaseModel.m
//  Rrz
//
//  Created by weishibo on 16/2/19.
//  Copyright © 2016年 rongzhongwang. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel



-(void)encodeWithCoder:(NSCoder *)encoder{
    unsigned int count;
    Ivar *ivar = class_copyIvarList([self class], &count);
    for (int i=0; i<count; i++) {
        Ivar iv = ivar[i];
        const char *name = ivar_getName(iv);
        NSString *strName = [NSString stringWithUTF8String:name];
        //利用KVC取值
        id value = [self valueForKey:strName];
        [encoder encodeObject:value forKey:strName];
    }
    free(ivar);
}

-(id)initWithCoder:(NSCoder *)decoder{
    self  = [super init];
    if (self) {
        unsigned int count = 0;
        //获取类中所有成员变量名
        Ivar *ivar = class_copyIvarList([self class], &count);
        for (int i = 0; i<count; i++) {
            Ivar iva = ivar[i];
            const char *name = ivar_getName(iva);
            NSString *strName = [NSString stringWithUTF8String:name];
            //进行解档取值
            id value = [decoder decodeObjectForKey:strName];
            //利用KVC对属性赋值
            [self setValue:value forKey:strName];
        }
        free(ivar);
    }
    return self;
}


@end
