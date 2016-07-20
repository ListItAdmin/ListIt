//
//  ListsViewController.m
//  ListIt!
//
//  Created by Ryan on 7/19/16.
//  Copyright © 2016 Ryan. All rights reserved.
//

#import "ListsViewController.h"
#import "ListTableViewCell.h"

@interface ListsViewController ()

@end

@implementation ListsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _Lists = [[NSMutableArray alloc] init];
    [_Lists addObject:@"Waterpolo"];
    [_Lists addObject:@"Baseball"];
    [_Lists addObject:@"League of Angles --- It's a math game"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ListName";
   ListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    int row = [indexPath row];
    
    cell.ListName.text= _Lists[row];
    
    //NSManagedObject *listitem = [self.SWNames objectAtIndex:indexPath.row];
    
    //[cell.Name setText:[NSString stringWithFormat:@"%@", [listitem valueForKey:@"name"]]];
    
    //NSString *checkmark = _Checked[row];
    
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.Lists.count;
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
