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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // Do any additional setup after loading the view.
    self.NewList.text = _SequeData[1];
    
    //set title of screen to the List Name
    [self setTitle:@"Update List"];
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
    
    
    if ([_SequeData[0] isEqualToString:@"Update"]) {
        
        //update core data
        
        NSLog(@"SequeData[0] = %@", _SequeData[0]);
        NSLog(@"New name: %@", self.NewList.text);
        [_Seque_selectedRow setValue:self.NewList.text forKey:@"listName"];
    } else {
        NSManagedObject *List = [NSEntityDescription insertNewObjectForEntityForName:@"List" inManagedObjectContext:context];
        
        NSNumber *Test = [self GoGetIt];
        
        [List setValue:[NSNumber numberWithInteger: [Test intValue]] forKey:@"listid"];
        [List setValue:[NSString stringWithFormat:@"%@", self.NewList.text] forKey:@"listName"];
    }
    
    /*NSManagedObject *List = [NSEntityDescription insertNewObjectForEntityForName:@"List" inManagedObjectContext:context];
    
    NSNumber *Test = [self GoGetIt];
    
    [List setValue:[NSNumber numberWithInteger: [Test intValue]] forKey:@"listid"];
    [List setValue:[NSString stringWithFormat:@"%@", self.NewList.text] forKey:@"listName"];*/
    
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
