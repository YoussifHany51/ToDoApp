//
//  Notes.m
//  ToDoApp
//
//  Created by Youssif Hany on 17/07/2024.
//

#import "Notes.h"

@implementation Notes

- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    [coder encodeObject:self.title forKey:@"title"];
    [coder encodeObject:self.desc forKey:@"description"];
    [coder encodeInteger:self.priority forKey:@"priority"];
    [coder encodeInteger:self.state forKey:@"state"];
    [coder encodeObject:self.date forKey:@"date"];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)coder {
    self = [super init];
        if (self) {
            self.title = [coder decodeObjectOfClass: [NSString class] forKey:@"title"];
            self.desc = [coder decodeObjectOfClass: [NSString class] forKey:@"description"];
            self.priority = [coder decodeIntegerForKey:@"priority"];
            self.state = [coder decodeIntegerForKey:@"state"];
            self.date = [coder decodeObjectOfClass: [NSDate class] forKey:@"date"];
        }
        return self;
}
+ (BOOL)supportsSecureCoding{
    return YES;
}
@end
