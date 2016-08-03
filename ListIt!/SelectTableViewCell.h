//
//  SelectTableViewCell.h
//  ListIt!
//
//  Created by Neville Linden on 7/29/16.
//  Copyright © 2016 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ItemImage;
@property (weak, nonatomic) IBOutlet UILabel *ItemName;

@end
