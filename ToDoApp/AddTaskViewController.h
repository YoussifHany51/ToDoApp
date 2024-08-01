//
//  AddTaskViewController.h
//  ToDoApp
//
//  Created by Youssif Hany on 17/07/2024.
//

#import <UIKit/UIKit.h>
#import "Notes.h"
NS_ASSUME_NONNULL_BEGIN

@interface AddTaskViewController : UIViewController
@property (nonatomic, strong) Notes *note;
@property (nonatomic, assign) BOOL isEditingNote;
@property (nonatomic, assign) NSInteger noteIndex;

@end

NS_ASSUME_NONNULL_END
