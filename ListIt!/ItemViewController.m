//
//  ItemViewController.m
//  ListIt!
//
//  Created by Ryan on 7/20/16.
//  Copyright © 2016 Ryan. All rights reserved.
//

#import "ItemViewController.h"
#import "ItemTableViewCell.h"

@interface ItemViewController ()

@end

@implementation ItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _Items = [[NSMutableArray alloc] init];
    [_Items addObject:@"Something Different"];
    [_Items addObject:@"Softball"];
    [_Items addObject:@"League of Geometry --- It's a math game"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ItemName";
    ItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    int row = [indexPath row];
    
    cell.ItemName.text= _Items[row];
    
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
    return self.Items.count;
    
    
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
