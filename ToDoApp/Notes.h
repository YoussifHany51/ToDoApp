//
//  Notes.h
//  ToDoApp
//
//  Created by Youssif Hany on 17/07/2024.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Notes : NSObject<NSCoding,NSSecureCoding>

@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) NSString *desc;
@property (nonatomic, assign) NSInteger priority;
@property (nonatomic, assign) NSInteger state;
@property (nonatomic, assign) NSDate *date;

@end

NS_ASSUME_NONNULL_END
