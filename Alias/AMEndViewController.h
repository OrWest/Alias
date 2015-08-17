//
//  AMEndViewController.h
//  Alias
//
//  Created by Alex Motor on 08.08.15.
//  Copyright (c) 2015 Alex Motor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMGameContoller.h"

@interface AMEndViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *winnerLabel;

- (IBAction)endGamePressAction:(UIButton *)sender;

@end
