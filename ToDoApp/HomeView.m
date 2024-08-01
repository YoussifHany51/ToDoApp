//
//  ViewController.m
//  ToDoApp
//
//  Created by Youssif Hany on 17/07/2024.
//

#import "HomeView.h"
#import "AddTaskViewController.h"
#import "Notes.h"

@interface HomeView ()
@property (weak, nonatomic) IBOutlet UITableView *notesTable;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property NSMutableArray<Notes *> *filteredNotesArray;
@property NSMutableArray * arrayOfNotes;
@property (nonatomic, strong) UISearchController *searchController;

@end

@implementation HomeView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.notesTable.dataSource = self;
    self.notesTable.delegate = self;
    
    self.filteredNotesArray = [NSMutableArray new];
    self.arrayOfNotes = [NSMutableArray new];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.obscuresBackgroundDuringPresentation = NO;
    self.searchController.searchBar.placeholder = @"Search Notes";
    self.notesTable.tableHeaderView = self.searchController.searchBar;
    
    self.definesPresentationContext = YES;
    [self retriveUserDefaults];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self retriveUserDefaults];
    [_notesTable reloadData];
}
- (IBAction)addTaskButton:(id)sender {
    AddTaskViewController * addtask = [self.storyboard instantiateViewControllerWithIdentifier:@"addTask"];
    [self.navigationController pushViewController:addtask animated:YES];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"forIndexPath:indexPath];
    Notes *note;
    if (self.searchController.isActive && self.searchController.searchBar.text.length > 0) {
        note = self.filteredNotesArray[indexPath.row];
    } else {
        note = self.arrayOfNotes[indexPath.row];
    }
    cell.textLabel.text = note.title;
    switch (note.priority) {
        case 0:
            cell.imageView.image = [UIImage imageNamed:@"low"];
            break;
        case 1:
            cell.imageView.image = [UIImage imageNamed:@"med"];
            break;
        default:
            cell.imageView.image = [UIImage imageNamed:@"high"];
            break;
    }
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchController.isActive && self.searchController.searchBar.text.length > 0) {
        return self.filteredNotesArray.count;
    }
    return self.arrayOfNotes.count;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.arrayOfNotes removeObjectAtIndex:indexPath.row];
        
        NSError *error = nil;
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.arrayOfNotes requiringSecureCoding:YES error:&error];
        if (error) {
            NSLog(@"Failed to archive notes: %@", error.localizedDescription);
        } else {
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"notesData"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
}

-(void)retriveUserDefaults{
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
    [self.notesTable reloadData];
    printf("%lu",(unsigned long)_arrayOfNotes.count);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    NSInteger numOfSections = 0;
    if (_arrayOfNotes.count > 0)
    {
        _notesTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        numOfSections                = 1;
        _notesTable.backgroundView = nil;
    }
    else
    {
        UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _notesTable.bounds.size.width, _notesTable.bounds.size.height)];
        noDataLabel.text             = @"No data available";
        
        noDataLabel.textColor        = [UIColor blackColor];
        noDataLabel.textAlignment    = NSTextAlignmentCenter;
        _notesTable.backgroundView = noDataLabel;
        _notesTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        numOfSections = 1;
    }
    
    return numOfSections;
}
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchText = searchController.searchBar.text;
    [self.filteredNotesArray removeAllObjects];
    
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(Notes *evaluatedObject, NSDictionary *bindings) {
           // Case-insensitive search for title
           NSString *title = evaluatedObject.title;
           return [title rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound;
       }];
    self.filteredNotesArray = [[self.arrayOfNotes filteredArrayUsingPredicate:predicate] mutableCopy];
    
    [self.notesTable reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Notes *selectedNote;
        NSInteger selectedIndex;
        if (self.searchController.isActive && self.searchController.searchBar.text.length > 0) {
            selectedNote = self.filteredNotesArray[indexPath.row];
            selectedIndex = [self.arrayOfNotes indexOfObject:selectedNote];
        } else {
            selectedNote = self.arrayOfNotes[indexPath.row];
            selectedIndex = indexPath.row;
        }
        
        if (selectedNote) {
            AddTaskViewController *addTaskVC = [self.storyboard instantiateViewControllerWithIdentifier:@"addTask"];
            addTaskVC.note = selectedNote;
            addTaskVC.noteIndex = selectedIndex;
            addTaskVC.isEditingNote = YES;
            [self.navigationController pushViewController:addTaskVC animated:YES];
        } else {
            NSLog(@"Error: selectedNote is null");
        }
}

@end
