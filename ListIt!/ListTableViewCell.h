//
//  ListTableViewCell.h
//  ListIt!
//
//  Created by Ryan on 7/19/16.
//  Copyright © 2016 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *ListName;
@property (weak, nonatomic) IBOutlet UILabel *ListID;

@end
