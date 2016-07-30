//
//  SelectViewController.h
//  ListIt!
//
//  Created by Neville Linden on 7/29/16.
//  Copyright © 2016 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface SelectViewController : UIViewController
@property (nonatomic, strong) NSMutableArray *Items;
@property (nonatomic, strong) NSMutableArray *blankItems;
@property (strong, nonatomic) NSManagedObject *Seque_selectedRow;
@property (nonatomic, strong) NSMutableArray *Selected;
- (IBAction)CheckButton:(id)sender;
- (IBAction)UncheckButton:(id)sender;
- (IBAction)ResetButton:(id)sender;
- (IBAction)CancelButton:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *SequeData;

@end
