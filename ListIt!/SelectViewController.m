//
//  SelectViewController.m
//  ListIt!
//
//  Created by Neville Linden on 7/29/16.
//  Copyright © 2016 Ryan. All rights reserved.
//


#import "SelectViewController.h"
#import "SelectTableViewCell.h"
#import <CoreData/CoreData.h>
#import "NewItemViewController.h"

@interface SelectViewController ()

@end

@implementation SelectViewController

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
    [self setTitle:@"SelectItems"];
    
    //add Edit button to Navigation button bar
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    //allow rows to be selected during editing
    //self.tableView.allowsSelectionDuringEditing = YES;
    
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
    
    _Selected = [[NSMutableArray alloc]init];
    int itemno;
    itemno = (int)self.Items.count + (int)self.blankItems.count;
    NSLog(@"Number of le items xd: %d", itemno);
    
    for (int a = 0; a <= (self.Items.count + self.blankItems.count); a++) {
        [_Selected addObject:@NO];
    }
    
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
    SelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    /*int row = [indexPath row];
    
    cell.ListName.text= _Lists[row];*/
    
    NSString *ItemStatus;
    
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
    
    /* SelectTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
     NSManagedObjectContext *context = [self managedObjectContext];
     //!!!!!!
     NSManagedObject *selectedRow;
     
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
     }*/
    
    //SelectTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //cell.backgroundColor = [UIColor colorWithRed:(234/255.0) green:(125/255.0) blue:(155/255.0) alpha:1];
    
    //NSIndexPath *myIndexPath = [self.tableView indexPathForSelectedRow];
    //int row = (int)[myIndexPath row];
    int row = (int)indexPath.row;
    NSLog (@"SelectedRow[%d]:|%@|",row,_Selected[row]);
    NSLog (@"%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Number of Items: %lu", (unsigned long)_Selected.count);
    if (indexPath.section == 0) {
        
        if ([_Selected[row]  isEqual: @NO]) {
            SelectTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.backgroundColor = [UIColor colorWithRed:(34/255.0) green:(125/255.0) blue:(255/255.0) alpha:1];
            [_Selected replaceObjectAtIndex:indexPath.row withObject:@YES];
            NSLog (@"The selected row is no");
        }   else {
            SelectTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.backgroundColor = [UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:1];
            [_Selected replaceObjectAtIndex:indexPath.row withObject:@NO];
            NSLog (@"The selected row is not no");
        }
        
    } else {
        row = row + (int)self.Items.count;
        if ([_Selected[row]  isEqual: @NO]) {
            SelectTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.backgroundColor = [UIColor colorWithRed:(34/255.0) green:(125/255.0) blue:(255/255.0) alpha:1];
            [_Selected replaceObjectAtIndex:row withObject:@YES];
            NSLog (@"The selected row is no");
        }   else {
            SelectTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.backgroundColor = [UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:1];
            [_Selected replaceObjectAtIndex:row withObject:@NO];
            NSLog (@"The selected row is not no");
        }
    }
    [self.tableView reloadData];
    
    // [self loadTableView];
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
    
    
    if ([[segue identifier] isEqualToString:@"ShowNewItem"]) {
        
        NewItemViewController *newitemviewcontroller = [segue destinationViewController];
        
        newitemviewcontroller.SequeData = @[_SequeData[1]];
        
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


- (IBAction)CheckButton:(id)sender {
    NSManagedObjectContext *context = [self managedObjectContext];
    
    for (int a = 0; a < (self.Items.count); a++) {
        NSLog(@"_Selected[%d]: %@", a, _Selected[a]);
        if ([_Selected[a] isEqual: @YES]) {
            NSManagedObject *selectedRow = [self.Items objectAtIndex:a];
            [selectedRow setValue:[NSNumber numberWithInt:2] forKey:@"itemStatus"];
            
            NSError *error = nil;
            // Save the object to persistent store
            if (![context save:&error]) {
                NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
            }
        }
    }
    
    for (int a = (int)self.Items.count; a < (self.Items.count + self.blankItems.count); a++) {
        NSLog(@"_Selected[%d]: %@", a, _Selected[a]);
        if ([_Selected[a] isEqual: @YES]) {
            NSManagedObject *selectedRow = [self.blankItems objectAtIndex:(a - self.Items.count)];
            [selectedRow setValue:[NSNumber numberWithInt:2] forKey:@"itemStatus"];
            
            NSError *error = nil;
            // Save the object to persistent store
            if (![context save:&error]) {
                NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
            }
        }
    }
    //close view controller
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)UncheckButton:(id)sender {
    NSManagedObjectContext *context = [self managedObjectContext];
    
    for (int a = 0; a < (self.Items.count); a++) {
        NSLog(@"_Selected[%d]: %@", a, _Selected[a]);
        if ([_Selected[a] isEqual: @YES]) {
            NSManagedObject *selectedRow = [self.Items objectAtIndex:a];
            [selectedRow setValue:[NSNumber numberWithInt:1] forKey:@"itemStatus"];
            
            NSError *error = nil;
            // Save the object to persistent store
            if (![context save:&error]) {
                NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
            }
        }
    }
    
    for (int a = (int)self.Items.count; a < (self.Items.count + self.blankItems.count); a++) {
        NSLog(@"_Selected[%d]: %@", a, _Selected[a]);
        if ([_Selected[a] isEqual: @YES]) {
            NSManagedObject *selectedRow = [self.blankItems objectAtIndex:(a - self.Items.count)];
            [selectedRow setValue:[NSNumber numberWithInt:1] forKey:@"itemStatus"];
            
            NSError *error = nil;
            // Save the object to persistent store
            if (![context save:&error]) {
                NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
            }
        }
    }
    //close view controller
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)ResetButton:(id)sender {
    NSManagedObjectContext *context = [self managedObjectContext];
    
    for (int a = 0; a < (self.Items.count); a++) {
        NSLog(@"_Selected[%d]: %@", a, _Selected[a]);
        if ([_Selected[a] isEqual: @YES]) {
            NSManagedObject *selectedRow = [self.Items objectAtIndex:a];
            [selectedRow setValue:[NSNumber numberWithInt:0] forKey:@"itemStatus"];
            
            NSError *error = nil;
            // Save the object to persistent store
            if (![context save:&error]) {
                NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
            }
        }
    }
    
    for (int a = (int)self.Items.count; a < (self.Items.count + self.blankItems.count); a++) {
        NSLog(@"_Selected[%d]: %@", a, _Selected[a]);
        if ([_Selected[a] isEqual: @YES]) {
            NSManagedObject *selectedRow = [self.blankItems objectAtIndex:(a - self.Items.count)];
            [selectedRow setValue:[NSNumber numberWithInt:0] forKey:@"itemStatus"];
            
            NSError *error = nil;
            // Save the object to persistent store
            if (![context save:&error]) {
                NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
            }
        }
    }
    //close view controller
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)CancelButton:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}
@end
