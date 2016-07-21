//
//  NewListViewController.h
//  ListIt!
//
//  Created by Ryan on 7/21/16.
//  Copyright © 2016 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewListViewController : UIViewController
- (IBAction)Save:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UITextField *NewList;

@end
