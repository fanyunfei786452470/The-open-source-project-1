//
//  YRAdListItem.m
//  YRYZ
//
//  Created by 易超 on 16/7/11.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRAdListItem.h"

@implementation YRAdListItem
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self == [super init]) {
        self.custId = [aDecoder decodeObjectForKey:@"custId"];
        self.custNname = [aDecoder decodeObjectForKey:@"custNname"];
        self.custName = [aDecoder decodeObjectForKey:@"custName"];
        self.headPath = [aDecoder decodeObjectForKey:@"headPath"];
        self.signature = [aDecoder decodeObjectForKey:@"signature"];
        self.nameNotes = [aDecoder decodeObjectForKey:@"nameNotes"];
        self.custPhone = [aDecoder decodeObjectForKey:@"custPhone"];
        self.uid = [aDecoder decodeObjectForKey:@"uid"];
        self.custImg = [aDecoder decodeObjectForKey:@"custImg"];
        self.custNo = [aDecoder decodeObjectForKey:@"custNo"];
        self.custSignature = [aDecoder decodeObjectForKey:@"custSignature"];

    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.custId forKey:@"custId"];
    [aCoder encodeObject:self.custNname forKey:@"custNname"];
    [aCoder encodeObject:self.custName forKey:@"custName"];
    [aCoder encodeObject:self.headPath forKey:@"headPath"];
    [aCoder encodeObject:self.signature forKey:@"signature"];
    [aCoder encodeObject:self.nameNotes forKey:@"nameNotes"];
    [aCoder encodeObject:self.custPhone forKey:@"custPhone"];
    [aCoder encodeObject:self.uid forKey:@"uid"];
    [aCoder encodeObject:self.custImg forKey:@"custImg"];
    [aCoder encodeObject:self.custNo forKey:@"custNo"];
    [aCoder encodeObject:self.custSignature forKey:@"custSignature"];

}



@end
