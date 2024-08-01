//
//  SecondViewController.m
//  ToDoApp
//
//  Created by Youssif Hany on 17/07/2024.
//


#import "SecondViewController.h"
#import "Notes.h"

@interface SecondViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *filterButton;
@property BOOL isFiltered;

@property NSMutableArray<Notes *> *filteredNotesArray;
@property NSMutableArray<Notes *> *arrayOfNotes;
@property NSMutableArray<Notes *> *priorityHigh;
@property NSMutableArray<Notes *> *priorityMed;
@property NSMutableArray<Notes *> *priorityLow;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    _isFiltered = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self retriveUserDefaults];
    [self filterNotes];
    [self.tableView reloadData];
}

- (IBAction)priorityButton:(id)sender {
    _isFiltered = !_isFiltered;
    [self.tableView reloadData];
}

- (void)initializeArrays {
    _filteredNotesArray = [NSMutableArray new];
    _priorityHigh = [NSMutableArray new];
    _priorityMed = [NSMutableArray new];
    _priorityLow = [NSMutableArray new];
}

- (void)filterNotes {
    [self initializeArrays];

    for (Notes *note in self.arrayOfNotes) {
        if (note.state == 1) {
            [_filteredNotesArray addObject:note];
            switch (note.priority) {
                case 0:
                    [_priorityLow addObject:note];
                    break;
                case 1:
                    [_priorityMed addObject:note];
                    break;
                case 2:
                    [_priorityHigh addObject:note];
                    break;
                default:
                    break;
            }
        }
    }
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
    Notes *note;
    
    if (_isFiltered) {
        switch (indexPath.section) {
            case 0:
                note = self.priorityLow[indexPath.row];
                break;
            case 1:
                note = self.priorityMed[indexPath.row];
                break;
            case 2:
                note = self.priorityHigh[indexPath.row];
                break;
            default:
                break;
        }
    } else {
        note = self.filteredNotesArray[indexPath.row];
    }
    
    cell.textLabel.text = note.title;
    switch (note.priority) {
        case 0:
            cell.imageView.image = [UIImage imageNamed:@"low"];
            break;
        case 1:
            cell.imageView.image = [UIImage imageNamed:@"med"];
            break;
        case 2:
            cell.imageView.image = [UIImage imageNamed:@"high"];
            break;
        default:
            break;
    }
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_isFiltered) {
        switch (section) {
            case 0:
                return _priorityLow.count;
            case 1:
                return _priorityMed.count;
            case 2:
                return _priorityHigh.count;
            default:
                return 0;
        }
    } else {
        return _filteredNotesArray.count;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (_isFiltered) {
        switch (section) {
            case 0:
                return @"Low Priority";
            case 1:
                return @"Medium Priority";
            case 2:
                return @"High Priority";
            default:
                return @"";
        }
    }
    return @"";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger numOfSections = 0;
    if (_filteredNotesArray.count > 0)
    {
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        numOfSections                = 1;
        _tableView.backgroundView = nil;
    }
    else
    {
        UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _tableView.bounds.size.width, _tableView.bounds.size.height)];
        noDataLabel.text             = @"No data available";
        
        noDataLabel.textColor        = [UIColor blackColor];
        noDataLabel.textAlignment    = NSTextAlignmentCenter;
        _tableView.backgroundView = noDataLabel;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        numOfSections = 1;
    }
    
    return numOfSections;
}

- (void)retriveUserDefaults {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"notesData"];
    if (data) {
        NSError *error = nil;
        NSArray *notesArray = [NSKeyedUnarchiver unarchivedObjectOfClasses:[NSSet setWithObjects:[NSArray class], [Notes class], nil] fromData:data error:&error];
        if (error) {
            NSLog(@"Failed to unarchive notes: %@", error.localizedDescription);
        } else {
            self.arrayOfNotes = [notesArray mutableCopy];
        }
    }
    [self.tableView reloadData];
}

@end
