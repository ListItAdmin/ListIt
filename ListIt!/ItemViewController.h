//
//  ItemViewController.h
//  ListIt!
//
//  Created by Ryan on 7/20/16.
//  Copyright © 2016 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface ItemViewController : UIViewController
@property (nonatomic, strong) NSMutableArray *Items;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSManagedObject *Seque_selectedRow;
@property (strong, nonatomic) NSArray *SequeData;
- (IBAction)Back:(UIBarButtonItem *)sender;

@end
