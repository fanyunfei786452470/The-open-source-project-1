//
//  RRZGoodFriend.m
//  Rrz
//
//  Created by 易超 on 16/3/10.
//  Copyright © 2016年 rongzhongwang. All rights reserved.
//

#import "RRZGoodFriendItem.h"

@implementation RRZGoodFriendItem
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self == [super init]) {
        self.custId = [aDecoder decodeObjectForKey:@"custId"];
        self.custNname = [aDecoder decodeObjectForKey:@"custNname"];
//        self.custName = [aDecoder decodeObjectForKey:@"custName"];
        self.headPath = [aDecoder decodeObjectForKey:@"headPath"];
        self.signature = [aDecoder decodeObjectForKey:@"signature"];
        self.nameNotes = [aDecoder decodeObjectForKey:@"nameNotes"];
        self.custPhone = [aDecoder decodeObjectForKey:@"custPhone"];
        self.relation = [aDecoder decodeObjectForKey:@"relation"];
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
//    [aCoder encodeObject:self.custName forKey:@"custName"];
    [aCoder encodeObject:self.headPath forKey:@"headPath"];
    [aCoder encodeObject:self.signature forKey:@"signature"];
    [aCoder encodeObject:self.nameNotes forKey:@"nameNotes"];
    [aCoder encodeObject:self.custPhone forKey:@"custPhone"];
    [aCoder encodeObject:self.relation forKey:@"relation"];
    [aCoder encodeObject:self.custImg forKey:@"custImg"];
    [aCoder encodeObject:self.custNo forKey:@"custNo"];
    [aCoder encodeObject:self.custSignature forKey:@"custSignature"];
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
- (void)setNilValueForKey:(NSString *)key{
    
}
@end
