//
//  ItemViewController.m
//  ListIt!
//
//  Created by Ryan on 7/20/16.
//  Copyright © 2016 Ryan. All rights reserved.
//

#import "ItemViewController.h"
#import "ItemTableViewCell.h"
#import <CoreData/CoreData.h>
#import "NewItemViewController.h"

@interface ItemViewController ()

@end

@implementation ItemViewController


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
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    
    //set title of screen to the List Name
    [self setTitle:@"Items"];
    
    //add Edit button to Navigation button bar
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    //allow rows to be selected during editing
    self.tableView.allowsSelectionDuringEditing = YES;
    
    //change color of table view separator lines
    [self.tableView setSeparatorColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1]];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Items"];
    
    NSString *listid = [NSString stringWithFormat:@"(listid == %@)", _SequeData[1]];
    NSPredicate *pred = [NSPredicate predicateWithFormat:listid];
    
    [fetchRequest setPredicate:pred];
    self.Items = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    NSLog(@"Self.Items: %@", self.Items);
    NSLog(@"segue data: %@, %@", _SequeData[0], _SequeData[1]);
}

//***********************************************************************
// Executes everytime the view is shown
//***********************************************************************
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // Do any additional setup after loading the view.
    
    [self loadTableView];
}

- (void)loadTableView
{
    
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Items"];
    
    NSString *listid = [NSString stringWithFormat:@"(listid == %@)", _SequeData[1]];
    NSPredicate *pred = [NSPredicate predicateWithFormat:listid];
    
    [fetchRequest setPredicate:pred];
    self.Items = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    NSLog(@"Self.Items: %@", self.Items);
    
    [self.tableView reloadData];
    
    
}

- (void) setEditing:(BOOL)editing animated:(BOOL)animated
{
    
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//load data into table view
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ItemName";
    ItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    int row = [indexPath row];
    
    //cell.ListName.text= _Lists[row];
    
    
    NSManagedObject *listitem = [self.Items objectAtIndex:indexPath.row];
    
    NSLog(@"status (string): |%@|", [listitem valueForKey:@"itemStatus"]);
    
    [cell.ItemName setText:[NSString stringWithFormat:@"%@", [listitem valueForKey:@"itemName"]]];
    
    NSString *ItemStatus = [NSString stringWithFormat:@"%@", [listitem valueForKey:@"itemStatus"]];
    
    int ItemStatus_I = [ItemStatus intValue];
    
    NSLog(@"status (not string): |%d|", ItemStatus_I);
    
    if (ItemStatus_I == 0) {
     cell.ItemImage.image = [UIImage imageNamed:@"checkblank.png"];
    } else if (ItemStatus_I == 1) {
        cell.ItemImage.image = [UIImage imageNamed:@"checkbox.png"];
    } else {
        cell.ItemImage.image = [UIImage imageNamed:@"checkmark.png"];
    }
    
    
    //NSString *checkmark = _Checked[row];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete object from database
        [context deleteObject:[self.Items objectAtIndex:indexPath.row]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
            return;
        }
        
        // Remove device from table view
        [self.Items removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.Items.count;
    
    
}

//*******************************************
// Pass Data to Items View Controller
//*******************************************
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    //if ([[segue identifier] isEqualToString:@"ShowListItems"]) {
    
    NewItemViewController *newitemviewcontroller = [segue destinationViewController];
    
    newitemviewcontroller.SequeData = @[_SequeData[1]];
    
    //}
    
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)Back:(UIBarButtonItem *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
