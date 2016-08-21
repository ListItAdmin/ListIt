//
//  NewItemViewController.m
//  ListIt!
//
//  Created by Neville Linden on 7/21/16.
//  Copyright © 2016 Ryan. All rights reserved.
//

#import "NewItemViewController.h"
#import <CoreData/CoreData.h>
@interface NewItemViewController ()

@property (strong) NSMutableArray *fetchResults;

@end

@implementation NewItemViewController


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
    //,.asasd
    if ([_SequeData[0] isEqualToString:@"Update"]) {
        self.SaveText.text = _SequeData[1];
        
        //set title of screen to the List Name
        [self setTitle:@"Update Item Name"];
    } else {
        self.SaveText.text = @"";
        
        //set title of screen to the List Name
        [self setTitle:@"Create New Item"];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)SaveItem:(id)sender {
    [self SaveThingy];
    
}

- (NSNumber *) GoGetIt {
    //establish database connection
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Items"];
    
    
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
    
    
    return myNum;
    
}


- (void) SaveThingy {
    
    // setup database connection
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSLog(@"SequeData[0] = %@", _SequeData[0]);
    
    if ([_SequeData[0] isEqualToString:@"Update"]) {
        //update core data
        

        
        NSLog(@"SequeData[0] = %@", _SequeData[0]);
        NSLog(@"New name: %@", self.SaveText.text);
        NSLog(@"Seque_selectedRow: %@", _Seque_selectedRow);
        [_Seque_selectedRow setValue:self.SaveText.text forKey:@"itemName"];
    } else {
        NSManagedObject *Item = [NSEntityDescription insertNewObjectForEntityForName:@"Items" inManagedObjectContext:context];
        NSNumber *Test = [self GoGetIt];
        NSString *string = _SequeData[0];
        NSInteger number=[string intValue];
        
        [Item setValue:[NSNumber numberWithInteger:number] forKey:@"listid"];
        [Item setValue:[NSNumber numberWithInteger:[Test intValue]] forKey:@"itemid"];
        [Item setValue:[NSString stringWithFormat:@"%@", self.SaveText.text] forKey:@"itemName"];
    }
    
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        
    }
    //close VC and go back
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)ReturnButton:(id)sender {
    [self SaveThingy];
}
@end

