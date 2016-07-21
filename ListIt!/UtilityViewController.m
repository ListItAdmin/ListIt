//
//  UtilityViewController.m
//  ListIt!
//
//  Created by Ryan on 7/20/16.
//  Copyright © 2016 Ryan. All rights reserved.
//

#import "UtilityViewController.h"
#import <CoreData/CoreData.h>

@interface UtilityViewController ()

@property (strong) NSMutableArray *fetchResults;

@end

@implementation UtilityViewController

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

- (IBAction)loaddata:(UIButton *)sender {
    
    // setup database connection
    NSManagedObjectContext *context = [self managedObjectContext];
    
    
    // set up d
    NSManagedObject *List = [NSEntityDescription insertNewObjectForEntityForName:@"List" inManagedObjectContext:context];
    
    [List setValue:[NSNumber numberWithInteger:0] forKey:@"listid"];
    [List setValue:[NSString stringWithFormat:@"Ralphs"] forKey:@"listName"];
    //[List setValue:[NSString stringWithFormat:@""] forKey:@"creationDate"];
    [List setValue:[NSNumber numberWithInteger:0] forKey:@"listCounter"];
    
    NSManagedObject *List01 = [NSEntityDescription insertNewObjectForEntityForName:@"List" inManagedObjectContext:context];
    [List01 setValue:[NSNumber numberWithInteger:1] forKey:@"listid"];
    [List01 setValue:[NSString stringWithFormat:@"HomeDepot"] forKey:@"listName"];
    //[List01 setValue:[NSString stringWithFormat:@""] forKey:@"creationDate"];
    [List01 setValue:[NSNumber numberWithInteger:0] forKey:@"listCounter"];
    
    NSManagedObject *List02 = [NSEntityDescription insertNewObjectForEntityForName:@"List" inManagedObjectContext:context];
    [List02 setValue:[NSNumber numberWithInteger:2] forKey:@"listid"];
    [List02 setValue:[NSString stringWithFormat:@"Outdoor Ed"] forKey:@"listName"];
    //[List02 setValue:[NSString stringWithFormat:@""] forKey:@"creationDate"];
    [List02 setValue:[NSNumber numberWithInteger:0] forKey:@"listCounter"];

    
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    
    
    
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"List"];
    self.fetchResults = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    //NSPredicate *pred = [NSPredicate predicateWithFormat:@"(charid == 1)"];
    
    //[fetchRequest setPredicate:pred];
    
    /*self.fetchResults = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    NSLog(@"Number of Records Found: %lu", (unsigned long)[self.fetchResults count]);
    NSLog(@"Retrieved record: %@", self.fetchResults[0]);
    NSLog(@"Char ID: %@", [[self.fetchResults objectAtIndex:0] valueForKey:@"charid"]);
    NSLog(@"Name: %@", [[self.fetchResults objectAtIndex:0] valueForKey:@"name"]);
    NSLog(@"Faction: %@", [[self.fetchResults objectAtIndex:0] valueForKey:@"faction"]);
    NSLog(@"Weapon: %@", [[self.fetchResults objectAtIndex:0] valueForKey:@"weapon"]);
    NSLog(@"Race: %@", [[self.fetchResults objectAtIndex:0] valueForKey:@"race"]);
    NSLog(@"Description: %@", [[self.fetchResults objectAtIndex:0] valueForKey:@"desc"]);*/

    
}

- (IBAction)loaditems:(UIButton *)sender {
    
    // setup database connection
    NSManagedObjectContext *context = [self managedObjectContext];
    
    
    // set up data
    NSManagedObject *List = [NSEntityDescription insertNewObjectForEntityForName:@"Items" inManagedObjectContext:context];
    
    [List setValue:[NSNumber numberWithInteger:0] forKey:@"listid"];
    [List setValue:[NSNumber numberWithInteger:0] forKey:@"itemid"];
    [List setValue:[NSString stringWithFormat:@"tomatoes"] forKey:@"itemName"];
    [List setValue:[NSNumber numberWithInteger:0] forKey:@"itemStatus"];
    //[List setValue:[NSString stringWithFormat:@"Rebel"] forKey:@"faction"];
    //[List setValue:[NSString stringWithFormat:@"Blue Lightsaber"] forKey:@"weapon"];
    //[List setValue:[NSString stringWithFormat:@"Human"] forKey:@"race"];
    
    NSManagedObject *List01 = [NSEntityDescription insertNewObjectForEntityForName:@"Items" inManagedObjectContext:context];
    
    [List01 setValue:[NSNumber numberWithInteger:0] forKey:@"listid"];
    [List01 setValue:[NSNumber numberWithInteger:1] forKey:@"itemid"];
    [List01 setValue:[NSString stringWithFormat:@"carrots"] forKey:@"itemName"];
    [List01 setValue:[NSNumber numberWithInteger:2] forKey:@"itemStatus"];
    //[List01 setValue:[NSString stringWithFormat:@"Rebel"] forKey:@"faction"];
    //[List01 setValue:[NSString stringWithFormat:@"Blue Lightsaber"] forKey:@"weapon"];
    //[List01 setValue:[NSString stringWithFormat:@"Human"] forKey:@"race"];
    
    NSManagedObject *List02 = [NSEntityDescription insertNewObjectForEntityForName:@"Items" inManagedObjectContext:context];
    
    [List02 setValue:[NSNumber numberWithInteger:0] forKey:@"listid"];
    [List02 setValue:[NSNumber numberWithInteger:2] forKey:@"itemid"];
    [List02 setValue:[NSString stringWithFormat:@"fedoras"] forKey:@"itemName"];
    [List02 setValue:[NSNumber numberWithInteger:1] forKey:@"itemStatus"];
    //[List02 setValue:[NSString stringWithFormat:@"Rebel"] forKey:@"faction"];
    //[List02 setValue:[NSString stringWithFormat:@"Blue Lightsaber"] forKey:@"weapon"];
    //[List02 setValue:[NSString stringWithFormat:@"Human"] forKey:@"race"];
    
    
    
    
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    
    
    //read from database
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Items"];
    self.fetchResults = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    //NSPredicate *pred = [NSPredicate predicateWithFormat:@"(charid == 1)"];
    
    //[fetchRequest setPredicate:pred];
    
    self.fetchResults = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    NSLog(@"Number of Records Found: %lu", (unsigned long)[self.fetchResults count]);
    NSLog(@"Retrieved record: %@", self.fetchResults[0]);
    NSLog(@"Retrieved record: %@", self.fetchResults[1]);
    NSLog(@"Retrieved record: %@", self.fetchResults[2]);
    //NSLog(@"List ID: %@", [[self.fetchResults objectAtIndex:0] valueForKey:@"listid"]);
    //NSLog(@"Item ID: %@", [[self.fetchResults objectAtIndex:0] valueForKey:@"itemid"]);
    //NSLog(@"Item Name: %@", [[self.fetchResults objectAtIndex:0] valueForKey:@"itemName"]);
    //NSLog(@"itemStatus: %@", [[self.fetchResults objectAtIndex:0] valueForKey:@"itemStatus"]);
    //NSLog(@"Race: %@", [[self.fetchResults objectAtIndex:0] valueForKey:@"race"]);
    //NSLog(@"Description: %@", [[self.fetchResults objectAtIndex:0] valueForKey:@"desc"]);

    
}

@end