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
    // Do any additional setup after loading the view.
    
    NSLog(@"list id: %@", _SequeData[0]);
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
    // setup database connection
    NSManagedObjectContext *context = [self managedObjectContext];
    NSNumber *Test = [self GoGetIt];
    
    // set up data
    NSManagedObject *List = [NSEntityDescription insertNewObjectForEntityForName:@"Items" inManagedObjectContext:context];
    
    NSString *string = _SequeData[0];
    NSInteger number=[string intValue];
    
    [List setValue:[NSNumber numberWithInteger:number] forKey:@"listid"];
    [List setValue:[NSNumber numberWithInteger:[Test intValue]] forKey:@"itemid"];
    [List setValue:[NSString stringWithFormat:@"%@", self.SaveText.text] forKey:@"itemName"];

    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        
    }
    //close VC and go back
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (NSNumber *) GoGetIt {
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

@end

