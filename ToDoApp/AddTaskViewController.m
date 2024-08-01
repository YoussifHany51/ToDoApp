//
//  AddTaskViewController.m
//  ToDoApp
//
//  Created by Youssif Hany on 17/07/2024.
//

#import "AddTaskViewController.h"
#import "Notes.h"
#import "HomeView.h"

@interface AddTaskViewController ()
//@property Notes *note;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *descTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *prioritySegmentField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *typeSegmentField;
@property (weak, nonatomic) IBOutlet UIDatePicker *dateField;
@property (weak, nonatomic) IBOutlet UIButton *buttonLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageLabel;


@end

@implementation AddTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    _note = [Notes new];
    [_dateField setMinimumDate: [NSDate date]];

    if (self.isEditingNote && self.note) {
            self.titleTextField.text = self.note.title;
            self.descTextField.text = self.note.desc;
            self.prioritySegmentField.selectedSegmentIndex = self.note.priority;
            self.typeSegmentField.selectedSegmentIndex = self.note.state;
            self.dateField.date = self.note.date;
        [self.buttonLabel setTitle:@"Edit" forState:UIControlStateNormal];
        switch (_note.priority) {
            case 0:
                _imageLabel.image = [UIImage imageNamed:@"low"];
                break;
            case 1:
                _imageLabel.image = [UIImage imageNamed:@"med"];
                break;
            default:
                _imageLabel.image = [UIImage imageNamed:@"high"];
                break;
        }
    }else{
        [_typeSegmentField setEnabled:NO];
    }
}
- (IBAction)saveButton:(id)sender {
    if ([self isValidTextFields]) {
            if (self.isEditingNote) {
                self.note.title = self.titleTextField.text;
                self.note.desc = self.descTextField.text;
                self.note.priority = self.prioritySegmentField.selectedSegmentIndex;
                self.note.state = self.typeSegmentField.selectedSegmentIndex;
                self.note.date = self.dateField.date;
            } else {
                self.note = [Notes new];
                self.note.title = self.titleTextField.text;
                self.note.desc = self.descTextField.text;
                self.note.priority = self.prioritySegmentField.selectedSegmentIndex;
                self.note.state = self.typeSegmentField.selectedSegmentIndex;
                self.note.date = self.dateField.date;
            }
            
            [self saveUserDefaults];
        }
}
- (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:title
                                          message:message
                                          preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self saveUserDefaults];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertController addAction:okAction];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}
- (void)saveUserDefaults {
NSMutableArray<Notes *> *existingNotes = [NSMutableArray new];
    NSData *existingData = [[NSUserDefaults standardUserDefaults] objectForKey:@"notesData"];
    if (existingData) {
        NSError *error = nil;
        NSArray *notesArray = [NSKeyedUnarchiver unarchivedObjectOfClasses:[NSSet setWithObjects:[NSArray class], [Notes class], nil] fromData:existingData error:&error];
        if (error) {
            NSLog(@"Failed to unarchive existing notes: %@", error.localizedDescription);
        } else {
            existingNotes = [notesArray mutableCopy];
        }
    }
    
    if (self.isEditingNote) {
        if (self.noteIndex < existingNotes.count) {
            existingNotes[self.noteIndex] = self.note;
        }
    } else {
        [existingNotes addObject:self.note];
    }
    
    NSError *error = nil;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:existingNotes requiringSecureCoding:YES error:&error];
    if (error) {
        NSLog(@"Failed to archive notes: %@", error.localizedDescription);
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"notesData"];
    [[NSUserDefaults standardUserDefaults] synchronize];  
    [self.navigationController popViewControllerAnimated:YES];
}
-(BOOL)isValidTextFields{
    if (_titleTextField.text.length < 1)
        return FALSE;
    return TRUE;
}

@end
