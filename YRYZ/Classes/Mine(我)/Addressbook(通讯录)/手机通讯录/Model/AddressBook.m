//
//  AddressBook.h
//  Rrz
//
//  Created by weishibo on 16/3/7.
//  Copyright © 2016年 rongzhongwang. All rights reserved.
//
#import "AddressBook.h"
#import "User.h"

@implementation AddressBook

+ (NSArray *)readAllPeoplesHeader
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    //取得本地通讯录名柄
    ABAddressBookRef tmpAddressBook = nil;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
        tmpAddressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(tmpAddressBook, ^(bool granted, CFErrorRef error) {
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }
    
    //取得本地所有联系人纪录
    if (tmpAddressBook == nil) {
        return nil;
    }
    NSArray *tmpPeoples = (__bridge NSArray *)ABAddressBookCopyArrayOfAllPeople(tmpAddressBook);
    
    for (id tmpPerson in tmpPeoples) {
        NSString *tmpFirstName = (__bridge NSString *)ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonFirstNameProperty);
        NSString *tmpLastName = (__bridge NSString *)ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonLastNameProperty);
        NSString *nameStr = [NSString stringWithFormat:@"%@%@",tmpFirstName,tmpLastName];
        
        ABMultiValueRef phones = (ABMultiValueRef) ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonPhoneProperty);
        for(int i = 0 ;i < ABMultiValueGetCount(phones); i ++){
            NSString *phone = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phones, i);
            AddressBook *addressBook = [[AddressBook alloc] init];
            addressBook.name = nameStr;
            addressBook.tel = phone;
            [array addObject:addressBook];
        }
    }
    return array;
}
- (void)readAllPeoplesNumAndName{
    
    //这个变量用于记录授权是否成功，即用户是否允许我们访问通讯录
    int __block tip=0;
    //声明一个通讯簿的引用
    ABAddressBookRef addBook =nil;
    //创建通讯簿的引用
     addBook=ABAddressBookCreateWithOptions(NULL, NULL);
     //创建一个出事信号量为0的信号
    dispatch_semaphore_t sema=dispatch_semaphore_create(0);
        //申请访问权限
     ABAddressBookRequestAccessWithCompletion(addBook, ^(bool greanted, CFErrorRef error) {
            //greanted为YES是表示用户允许，否则为不允许
            if (!greanted) {
                tip=1;
            }
            //发送一次信号
            dispatch_semaphore_signal(sema);
        });
        //等待信号触发
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);

    if (tip) {
        //做一个友好的提示
//        UIAlertView * alart = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请您设置允许APP访问您的通讯录\nSettings>General>Privacy" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alart show];
//
//        return [NSArray array];
        self.info(NO,nil);   return;
    }else{
            NSMutableArray *nameArray = [NSMutableArray array];
            NSMutableArray *phoneArray = [NSMutableArray array];
            
            //获取所有联系人的数组
            CFArrayRef allLinkPeople = ABAddressBookCopyArrayOfAllPeople(addBook);
            //获取联系人总数
            CFIndex number = ABAddressBookGetPersonCount(addBook);
            //进行遍历
            for (NSInteger i=0; i<number; i++) {
                //获取联系人对象的引用
                ABRecordRef  people = CFArrayGetValueAtIndex(allLinkPeople, i);
                //获取当前联系人名字
                NSString*firstName=(__bridge NSString *)(ABRecordCopyValue(people, kABPersonFirstNameProperty));
                
                //获取当前联系人姓氏
                NSString*lastName=(__bridge NSString *)(ABRecordCopyValue(people, kABPersonLastNameProperty));
                
                //获取当前联系人的电话 数组
                NSMutableArray * phoneArr = [[NSMutableArray alloc]init];
                
                
                ABMultiValueRef phones= ABRecordCopyValue(people, kABPersonPhoneProperty);
                
                for (NSInteger j=0; j<ABMultiValueGetCount(phones); j++) {
                    [phoneArr addObject:(__bridge NSString *)(ABMultiValueCopyValueAtIndex(phones, j))];
                }
                
                if (phoneArr.count>0) {
                    NSString *phohe = [(NSString*)phoneArr[0] stringByReplacingOccurrencesOfString:@"-" withString:@""];
                    lastName == nil?lastName = @"" : lastName;
                    firstName == nil?firstName = @"" : firstName;
             
                    NSString *name = [NSString stringWithFormat:@"%@%@",lastName,firstName];
//                    User *user = [[User alloc]init:name name:name];
//                    
//                    [nameArray addObject:user];
                    [nameArray addObject:name];
                    if (phohe.length>11) {
                        phohe = [phohe substringFromIndex:phohe.length-11];
                    }
                    [phoneArray addObject:phohe];
                }
            }
            
            //第一个是通讯录姓名,第二个是通讯录手机号
            NSArray *allUserInfo = @[nameArray,phoneArray];
            
             CFRelease(addBook);
        
            
            self.info(YES,allUserInfo);
            
    }
}









@end






















