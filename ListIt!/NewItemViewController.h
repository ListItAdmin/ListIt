//
//  NewItemViewController.h
//  ListIt!
//
//  Created by Neville Linden on 7/21/16.
//  Copyright © 2016 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewItemViewController : UIViewController
- (IBAction)SaveItem:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *SaveText;

@end
