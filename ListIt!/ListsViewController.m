//
//  ListsViewController.m
//  ListIt!
//
//  Created by Ryan on 7/19/16.
//  Copyright © 2016 Ryan. All rights reserved.
//

#import "ListsViewController.h"
#import "ListTableViewCell.h"
#import "ItemViewController.h"
#import <CoreData/CoreData.h>

@interface ListsViewController ()

@property (strong, nonatomic) NSManagedObject *selectedList;

@end

@implementation ListsViewController

//***********************************************************************
// Setup ManagedObjectContext to access core data
//***********************************************************************
- (NSManagedObjectContext *)managedObjectContext
{
    
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self checkFirstTime];

    
    //set title of screen to the List Name
    [self setTitle:@"Lists"];
    
    //add Edit button to Navigation button bar
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    //allow rows to be selected during editing
    self.tableView.allowsSelectionDuringEditing = YES;
    
    //change color of table view separator lines
    [self.tableView setSeparatorColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1]];
    
    
    
    //_Lists = [[NSMutableArray alloc] init];
    //[_Lists addObject:@"Waterpolo"];
    //[_Lists addObject:@"Baseball"];
    //[_Lists addObject:@"League of Angles --- It's a math game"];
    
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"List"];
    self.Lists = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    NSLog(@"Self.Lists: %@", self.Lists);
    
    
    
}

//***********************************************************************
// Executes everytime the view is shown
//***********************************************************************
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // Do any additional setup after loading the view.
    
    [self loadTableView];
}

- (void)checkFirstTime {
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"hasPerformedFirstLaunch"]) {
        // On first launch, this block will execute
        
        NSLog(@"First time launching...");
        
        // Set the "hasPerformedFirstLaunch" key so this block won't execute again
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasPerformedFirstLaunch"];
        
        // setup database connection
        NSManagedObjectContext *context = [self managedObjectContext];
        
        
        // set up d
        NSManagedObject *List = [NSEntityDescription insertNewObjectForEntityForName:@"List" inManagedObjectContext:context];
        
        [List setValue:[NSNumber numberWithInteger:0] forKey:@"listid"];
        [List setValue:[NSString stringWithFormat:@"Sample List"] forKey:@"listName"];
        //[List setValue:[NSString stringWithFormat:@""] forKey:@"creationDate"];
        [List setValue:[NSNumber numberWithInteger:0] forKey:@"listCounter"];
        
        // set up data
        NSManagedObject *Item = [NSEntityDescription insertNewObjectForEntityForName:@"Items" inManagedObjectContext:context];
        
        [Item setValue:[NSNumber numberWithInteger:0] forKey:@"listid"];
        [Item setValue:[NSNumber numberWithInteger:0] forKey:@"itemid"];
        [Item setValue:[NSString stringWithFormat:@"Sample Item"] forKey:@"itemName"];
        [Item setValue:[NSNumber numberWithInteger:0] forKey:@"itemStatus"];
        //[List setValue:[NSString stringWithFormat:@"Rebel"] forKey:@"faction"];
        //[List setValue:[NSString stringWithFormat:@"Blue Lightsaber"] forKey:@"weapon"];
        //[List setValue:[NSString stringWithFormat:@"Human"] forKey:@"race"];
        
        NSError *error = nil;
        // Save the object to persistent store
        if (![context save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }
        
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        NSLog(@"Not first time launching...");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//load data into table view
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ListName";
   ListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    int row = [indexPath row];
    
    //cell.ListName.text= _Lists[row];
    
    NSManagedObject *listitem = [self.Lists objectAtIndex:indexPath.row];
    
    [cell.ListName setText:[NSString stringWithFormat:@"%@", [listitem valueForKey:@"listName"]]];
    [cell.ListID setText:[NSString stringWithFormat:@"%@", [listitem valueForKey:@"listid"]]];

    
    //NSString *checkmark = _Checked[row];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.Lists.count;
    
    
}

- (void) setEditing:(BOOL)editing animated:(BOOL)animated
{
    
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
    
}

- (void)loadTableView
{
    
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"List"];
    self.Lists = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    NSLog(@"Self.Lists: %@", self.Lists);
    
    [self.tableView reloadData];
    
    
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete object from database
        [context deleteObject:[self.Lists objectAtIndex:indexPath.row]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
            return;
        }
        
        // Remove device from table view
        [self.Lists removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

//*******************************************
// User Select-a-row
//*******************************************
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //!!!!!!
    NSManagedObject *selectedRow = [self.Lists objectAtIndex:indexPath.row];
    // save selected list item to pass to Update view contoller
    _selectedList = selectedRow;
    
    NSLog(@"******SELECTED ROW: %@",[_selectedList valueForKey:@"listName"]);
    
    
    
    //!!!!!!!!!
    //NSString *nameSelected = [_InterestingNames objectAtIndex:indexPath.row];
    
    //NSString *msg = [NSString stringWithFormat:@"You have selected %@", nameSelected];
    //UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Player selected" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    //[alert show];
    
    //!!!!!!!
    //UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    //[self performSegueWithIdentifier:@"ShowDetail" sender:cell];
}


//*******************************************
// Pass Data to Items View Controller
//*******************************************
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    if ([[segue identifier] isEqualToString:@"Same"]) {
        
        ItemViewController *itemviewcontroller = [segue destinationViewController];
        
        NSIndexPath *myIndexPath = [self.tableView indexPathForSelectedRow];
        
        
        int row = [myIndexPath row];
        
        NSString *selectedRow = [NSString stringWithFormat:@"%d", row];
        
        
        // ListTableCell *cell = [self.tableView cellForRowAtIndexPath:myIndexPath];
        
        
        ListTableViewCell *cell = [self.tableView cellForRowAtIndexPath:myIndexPath];
        
        NSLog(@"List Name: %@", cell.ListName.text);
        NSLog(@"List ID: %@", cell.ListID.text);
        
        
        itemviewcontroller.SequeData = @[cell.ListName.text, cell.ListID.text];
        
    }
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
