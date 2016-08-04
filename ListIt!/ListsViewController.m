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
#import "NewListViewController.h"
#import "ItemTableViewCell.h"
#import <CoreData/CoreData.h>

@interface ListsViewController ()

@property (strong, nonatomic) NSManagedObject *selectedList;
@property (strong) NSMutableArray *fetchResults;
@property (strong, nonatomic) NSManagedObject *selectedItem;
@property BOOL isCopying;

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

    _isCopying = NO;
    NSLog(@"isCopying = %d",_isCopying);
    
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
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"List"];
    self.fetchResults = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
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
    
    //int row = [indexPath row];
    
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

//*******************************************
// Load table view
//*******************************************
- (void)loadTableView
{
    
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"List"];
    self.Lists = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    NSLog(@"Self.Lists: %@", self.Lists);
    
    _isCopying = NO;
    
    [self.tableView reloadData];
    
    
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete object from database
        NSManagedObject *listitem;
        
        listitem = [self.Lists objectAtIndex:indexPath.row];
        
        NSString *listid = [listitem valueForKey:@"listid"];

        
        //NSIndexPath *myIndexPath = [self.tableView indexPathForSelectedRow];
        //ListTableViewCell *cell = [self.tableView cellForRowAtIndexPath:myIndexPath];
        NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
        
        //get items from the database that have the checkbox and checkmark
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Items"];
        NSLog(@"THIS IS A MESSAGE :/ %@",listid);
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"((listid = %@))", listid];
        [fetchRequest setPredicate:pred];
        self.Items = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
        NSLog(@"Self.Items: %lu", (unsigned long)self.Items.count);

        for (int i = 0; i < self.Items.count; i++) {
            [context deleteObject:[self.Items objectAtIndex:i]];
            
            NSError *error = nil;
            if (![context save:&error]) {
                NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
                return;
            }
        }
        
        [context deleteObject:[self.Lists objectAtIndex:indexPath.row]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
            return;
        }
        
        //NSLog(@"Self.blankItems: %lu", (unsigned long)self.blankItems.count);
        //NSLog(@"Self.Items: %lu", (unsigned long)self.Items.count);

        
        // Remove device from table view
        [self.Lists removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

//*******************************************
// User Select-a-row
//*******************************************
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"isCopying = %d",_isCopying);
    
    //!!!!!!
    if(self.tableView.isEditing){
        NSManagedObject *selectedRow = [self.Lists objectAtIndex:indexPath.row];
        // save selected list item to pass to Update view contoller
        _selectedList = selectedRow;
        
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        [self performSegueWithIdentifier:@"ShowUpdateList" sender:cell];
        
    } else if(_isCopying == YES){
      
        NSLog(@"IS COPYING");
        
        NSManagedObjectContext *context = [self managedObjectContext];
        NSIndexPath *myIndexPath = [self.tableView indexPathForSelectedRow];
        ListTableViewCell *cell = [self.tableView cellForRowAtIndexPath:myIndexPath];
        NSManagedObject *List = [NSEntityDescription insertNewObjectForEntityForName:@"List" inManagedObjectContext:context];
        
        NSNumber *Test = [self GoGetIt];
        
        [List setValue:[NSNumber numberWithInteger: [Test intValue]] forKey:@"listid"];
        [List setValue:[NSString stringWithFormat:@"%@ (Copy)", cell.ListName.text] forKey:@"listName"];

        NSError *error = nil;
        // Save the object to persistent store
        if (![context save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
            
        }
        
        [self loadTableView];
        
        NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
        
        //NSNumber *something = 0;
        
        //get items from the database that have the checkbox and checkmark
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Items"];
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"((listid = %@))", cell.ListID.text];
        [fetchRequest setPredicate:pred];
        self.Items = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
        NSLog(@"Self.Items: %lu", (unsigned long)self.Items.count);
        
        //NSManagedObject *Item = [NSEntityDescription insertNewObjectForEntityForName:@"Items" inManagedObjectContext:context];
        
        //NSString *string =ç cell.ListID.text;
        
        NSManagedObject *listitem;
        NSManagedObject *newListitem;
        
        // Copy each list item from selected list to new copy list
        for (int i = 0; i < self.Items.count; i++) {
            
            
            newListitem = [NSEntityDescription insertNewObjectForEntityForName:@"Items" inManagedObjectContext:context];
            
            [newListitem setValue:[NSNumber numberWithInteger:[Test intValue]] forKey:@"listid"];
            
            listitem = [self.Items objectAtIndex:i ];
            
            
            NSString *listItemName = [listitem valueForKey:@"itemName"];
            
            [newListitem setValue:listItemName forKey:@"itemName"];
            
            NSString *checkeditem = [listitem valueForKey:@"itemStatus"];
            int checkeditem_I = [checkeditem intValue];
            [newListitem setValue:[NSNumber numberWithInteger:checkeditem_I] forKey:@"itemStatus"];
            
            // Execute query
            if (![context save:&error]) {
                NSLog(@"Can't Execute! %@ %@", error, [error localizedDescription]);
            }
            
        }
    
    } else {
        
        NSManagedObject *selectedRow = [self.Lists objectAtIndex:indexPath.row];
        // save selected list item to pass to Update view contoller
        _selectedList = selectedRow;
        
        NSLog(@"******SELECTED ROW: %@",[_selectedList valueForKey:@"listName"]);
        
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [self performSegueWithIdentifier:@"Same" sender:cell];
    }

}

- (NSNumber *) GoGetIt {
    //establish database connection
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"List"];
    //self.fetchResults = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"listid"
                                                                   ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    self.fetchResults = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    
    //get the thingy from the datathingy
    NSLog(@"Number of Records Found: %lu", (unsigned long)[self.fetchResults count]);
    
    NSLog(@"*MAX List ID: %@", [[self.fetchResults objectAtIndex:[self.fetchResults count]-1] valueForKey:@"listid"]);
    
    NSInteger i;
    
    NSString *nextCharID  =[[self.fetchResults objectAtIndex:[self.fetchResults count]-1] valueForKey:@"listid"];
    
    //increment the charid
    i = [nextCharID integerValue];
    
    i = i+1;
    
    NSNumber *myNum = @(i);
    NSLog(@"This is myNum: %@", myNum);
    //nextCharID = [NSString stringWithFormat:@"%ld", (long)i];
    
    //return it BOIS
    return myNum;
    
}

- (NSNumber *) ItemGoGetIt {
    //establish database connection
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Items"];
    //self.fetchResults = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"itemid"
                                                                   ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    self.fetchResults = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    
    //get the thingy from the datathingy
    NSLog(@"Number of Records Found: %lu", (unsigned long)[self.fetchResults count]);
    
    NSLog(@"*MAX List ID: %@", [[self.fetchResults objectAtIndex:[self.fetchResults count]-1] valueForKey:@"itemid"]);
    
    NSInteger i;
    
    NSString *nextCharID  =[[self.fetchResults objectAtIndex:[self.fetchResults count]-1] valueForKey:@"itemid"];
    
    //increment the charid
    i = [nextCharID integerValue];
    
    i = i+1;
    
    NSNumber *myNum = @(i);
    NSLog(@"This is myNum: %@", myNum);
    //nextCharID = [NSString stringWithFormat:@"%ld", (long)i];
    
    //return it BOIS
    return myNum;
    
}

//*******************************************
// Pass Data to Items View Controller
//*******************************************
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    if ([[segue identifier] isEqualToString:@"Same"]) {
        
        ItemViewController *itemviewcontroller = [segue destinationViewController];
        
        NSIndexPath *myIndexPath = [self.tableView indexPathForSelectedRow];
        
        
        //int row = (int)[myIndexPath row];
        
        //NSString *selectedRow = [NSString stringWithFormat:@"%d", row];
        
        
        ListTableViewCell *cell = [self.tableView cellForRowAtIndexPath:myIndexPath];
        
        NSLog(@"List Name: %@", cell.ListName.text);
        NSLog(@"List ID: %@", cell.ListID.text);
        
        
        itemviewcontroller.SequeData = @[cell.ListName.text, cell.ListID.text];
    } else if ([[segue identifier] isEqualToString:@"ShowUpdateList"]){
        
        NSIndexPath *myIndexPath = [self.tableView indexPathForSelectedRow];
        ListTableViewCell *cell = [self.tableView cellForRowAtIndexPath:myIndexPath];
        
        NewListViewController *newlistviewcontroller = [segue destinationViewController];
        
        newlistviewcontroller.SequeData = @[@"Update",cell.ListName.text,cell.ListID.text];
        
        newlistviewcontroller.Seque_selectedRow = _selectedList;
        NSLog(@"seque_selectedrow: %@",newlistviewcontroller.Seque_selectedRow);
        
        //[self performSegueWithIdentifier:@"ShowUpdateList" sender:_cell];
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

- (IBAction)Copy:(UIButton *)sender {
    
    NSLog(@"Set Copying to YES");
    _isCopying = YES;
    
}
@end
