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
#import "SelectViewController.h"

@interface ItemViewController ()

@property (strong, nonatomic) NSManagedObject *selectedItem;
@property NSString *SegueItemID;

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
    
    //get items from the database that have the checkbox and checkmark
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Items"];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"((listid = %@) AND (itemStatus != 0))", _SequeData[1]];
    [fetchRequest setPredicate:pred];
    self.Items = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    NSLog(@"Self.Items: %@", self.Items);
    
    //get items from the database that have no checkbox or checkmark
    NSFetchRequest *blankFetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Items"];
    NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"((listid = %@) AND (itemStatus = 0))", _SequeData[1]];
    [blankFetchRequest setPredicate:pred1];
    self.blankItems = [[managedObjectContext executeFetchRequest:blankFetchRequest error:nil] mutableCopy];
    NSLog(@"Self.blankItems: %@", self.blankItems);
    
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
    
    /*int row = [indexPath row];
    
    cell.ListName.text= _Lists[row];*/
    
    NSString *ItemStatus;
    
    if (indexPath.section == 0) {
        NSManagedObject *listitem = [self.Items objectAtIndex:indexPath.row];
        NSLog(@"status (string): 4|%@|", [listitem valueForKey:@"itemStatus"]);
        [cell.ItemName setText:[NSString stringWithFormat:@"%@", [listitem valueForKey:@"itemName"]]];
        ItemStatus = [NSString stringWithFormat:@"%@", [listitem valueForKey:@"itemStatus"]];
    } else {
        NSManagedObject *listitem = [self.blankItems objectAtIndex:indexPath.row];
        NSLog(@"status (string): |%@|", [listitem valueForKey:@"itemStatus"]);
        [cell.ItemName setText:[NSString stringWithFormat:@"%@", [listitem valueForKey:@"itemName"]]];
        ItemStatus = [NSString stringWithFormat:@"%@", [listitem valueForKey:@"itemStatus"]];
    }
    
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

//*******************************************
// User Select-a-row
//*******************************************
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"CHECK POINT");
    
    //!!!!!!
    if(self.tableView.isEditing){
        NSLog(@"CHECK POINT");
        
        //NSManagedObject *selectedRow = [self.Items objectAtIndex:indexPath.row];
        NSManagedObject *selectedRow;		
        // save selected list item to pass to Update view contoller
        
        NSLog(@"CHECK POINT");
        
        if (indexPath.section == 0) {
            selectedRow = [self.Items objectAtIndex:indexPath.row];
            _selectedItem = selectedRow;
        } else {
            selectedRow = [self.blankItems objectAtIndex:indexPath.row];
            _selectedItem = selectedRow;
        }
        NSLog(@"CHECK POINT");
        NSString *ItemID = [selectedRow valueForKey: @"itemid"];
        
        _SegueItemID = ItemID;
        
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        NSLog(@"CHECK POINT");
        
        [self performSegueWithIdentifier:@"ShowUpdateItem" sender:cell];
        
    } else {
        
        ItemTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        NSManagedObjectContext *context = [self managedObjectContext];
        //!!!!!!
        NSManagedObject *selectedRow;
        if (indexPath.section == 0) {
            selectedRow = [self.Items objectAtIndex:indexPath.row];
        } else {
            selectedRow = [self.blankItems objectAtIndex:indexPath.row];
        }
        NSString *ItemStatus = [selectedRow valueForKey: @"itemStatus"];
        
        int ItemStatus_I = [ItemStatus intValue];
        
        NSLog(@"status (not string): |%d|", ItemStatus_I);
        
        if (ItemStatus_I == 0) {
            cell.ItemImage.image = [UIImage imageNamed:@"checkbox.png"];
            [selectedRow setValue:[NSNumber numberWithInteger:1] forKey:@"itemStatus"];
        } else if (ItemStatus_I == 1) {
            cell.ItemImage.image = [UIImage imageNamed:@"checkmark.png"];
            [selectedRow setValue:[NSNumber numberWithInteger:2] forKey:@"itemStatus"];
        } else {
            cell.ItemImage.image = [UIImage imageNamed:@"checkblank.png"];
            [selectedRow setValue:[NSNumber numberWithInteger:0] forKey:@"itemStatus"];
        }
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
            return;
        }
        
        [self loadTableView];

    }
}


//*******************************************
// User Delete-a-row
//*******************************************
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *selectedRow;
    ItemTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete object from database
        //[context deleteObject:[self.Items objectAtIndex:indexPath.row]];
        
        NSString *ItemStatus = [selectedRow valueForKey: @"itemStatus"];
        
        if (indexPath.section == 0) {
            NSManagedObject *listitem = [self.Items objectAtIndex:indexPath.row];
            NSLog(@"status (string): |%@|", [listitem valueForKey:@"itemStatus"]);
            [cell.ItemName setText:[NSString stringWithFormat:@"%@", [listitem valueForKey:@"itemName"]]];
            ItemStatus = [NSString stringWithFormat:@"%@", [listitem valueForKey:@"itemStatus"]];
        } else {
            NSManagedObject *listitem = [self.blankItems objectAtIndex:indexPath.row];
            NSLog(@"status (string): |%@|", [listitem valueForKey:@"itemStatus"]);
            [cell.ItemName setText:[NSString stringWithFormat:@"%@", [listitem valueForKey:@"itemName"]]];
            ItemStatus = [NSString stringWithFormat:@"%@", [listitem valueForKey:@"itemStatus"]];
        }
        
        int ItemStatus_I = [ItemStatus intValue];
        
        if (ItemStatus_I == 0) {
            [context deleteObject:[self.blankItems objectAtIndex:indexPath.row]];
            [self.blankItems removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        } else if (ItemStatus_I == 1) {
            [context deleteObject:[self.Items objectAtIndex:indexPath.row]];
            [self.Items removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        } else if (ItemStatus_I == 2){
            [context deleteObject:[self.Items objectAtIndex:indexPath.row]];
            [self.Items removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            //[self.Items removeObjectAtIndex:indexPath.row];
        } else {
            NSLog(@"HAHAHAHAHHAHAHAHA YOU JUST GOT REKT BWAHAHAHAHAHA");
        }
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
            return;
        }
        
        NSLog(@"Self.blankItems: %lu", (unsigned long)self.blankItems.count);
        NSLog(@"Self.Items: %lu", (unsigned long)self.Items.count);
        
        // Remove device from table view
        //[self.Items removeObjectAtIndex:indexPath.row];
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
         return self.Items.count;
    } else {
        return self.blankItems.count;
    }
    
    
}

//*******************************************
// Pass Data to Items View Controller
//*******************************************
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSLog(@"Inside prepareforSegue");
    
    if ([[segue identifier] isEqualToString:@"ShowUpdateItem"]){
        
        NSLog(@"Inside ShowUpdateItem");
        
        NSIndexPath *myIndexPath = [self.tableView indexPathForSelectedRow];
        ItemTableViewCell *cell = [self.tableView cellForRowAtIndexPath:myIndexPath];
        
        NewItemViewController *newitemviewcontroller = [segue destinationViewController];
        
        NSLog(@"Inside ShowUpdateItem");
        
        //newitemviewcontroller.SequeData = @[@"Update",cell.ItemName.text,cell.ItemID.text,_SequeData[1]];
        newitemviewcontroller.SequeData = @[@"Update",cell.ItemName.text,cell.ItemID.text,_SequeData[1],_SegueItemID];
        
        NSLog(@"SequqData[0] prepareForSegue: %@", newitemviewcontroller.SequeData[0]);
        
        newitemviewcontroller.Seque_selectedRow = _selectedItem;
        NSLog(@"seque_selectedrow: %@",newitemviewcontroller.Seque_selectedRow);
    } else if ([[segue identifier] isEqualToString:@"ShowSelect"]) {
        SelectViewController *selectviewcontroller = [segue destinationViewController];
        
        selectviewcontroller.SequeData = @[_SequeData[0], _SequeData[1]];
    } else {
        NewItemViewController *newitemviewcontroller = [segue destinationViewController];
        
        newitemviewcontroller.SequeData = @[_SequeData[1]];
    }
    
    //NewItemViewController *newitemviewcontroller = [segue destinationViewController];
    
    //newitemviewcontroller.SequeData = @[_SequeData[1]];
    
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
