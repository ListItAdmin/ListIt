//
//  NewListViewController.m
//  ListIt!
//
//  Created by Ryan on 7/21/16.
//  Copyright © 2016 Ryan. All rights reserved.
//

#import "NewListViewController.h"
#import <CoreData/CoreData.h>

@interface NewListViewController ()

@property (strong) NSMutableArray *fetchResults;

@end

@implementation NewListViewController

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
- (IBAction)Save:(UIBarButtonItem *)sender {
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    
    // NSString *nextCharID = [self gogetnext];
    
    //NSInteger *Test = [self TheRealGoGetIt];
    
    
    //!!!!
    
    
    /*if ([_SequeData[0] isEqualToString:@"Update"]) {
        
        //update core data
        
        NSLog(@"New name: %@", self.Name.text);
        [_Seque_selectedRow setValue:self.Name.text forKey:@"name"];
        [_Seque_selectedRow setValue:self.Description.text forKey:@"desc"];
        [_Seque_selectedRow setValue:self.Faction.text forKey:@"faction"];
        [_Seque_selectedRow setValue:self.Weapon.text forKey:@"weapon"];
        [_Seque_selectedRow setValue:self.Race.text forKey:@"race"];
        
        
        
    } else {
        NSManagedObject *SWChar = [NSEntityDescription insertNewObjectForEntityForName:@"SWChar" inManagedObjectContext:context];
        
        NSNumber *Test = [self TheRealGoGetIt];
        
        [SWChar setValue:[NSNumber numberWithInteger: [Test intValue]] forKey:@"charid"];
        [SWChar setValue:[NSString stringWithFormat:@"%@", self.Name.text] forKey:@"name"];
        [SWChar setValue:[NSString stringWithFormat:@"%@", self.Description.text] forKey:@"desc"];
        [SWChar setValue:[NSString stringWithFormat:@"%@", self.Faction.text] forKey:@"faction"];
        [SWChar setValue:[NSString stringWithFormat:@"%@", self.Weapon.text] forKey:@"weapon"];
        [SWChar setValue:[NSString stringWithFormat:@"%@", self.Race.text] forKey:@"race"];
        
        
    }*/
    
    NSManagedObject *List = [NSEntityDescription insertNewObjectForEntityForName:@"List" inManagedObjectContext:context];
    
    NSNumber *Test = [self GoGetIt];
    
    [List setValue:[NSNumber numberWithInteger: [Test intValue]] forKey:@"listid"];
    [List setValue:[NSString stringWithFormat:@"%@", self.NewList.text] forKey:@"listName"];
    
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

@end
