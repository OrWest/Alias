//
//  AMStartGameViewController.h
//  Alias
//
//  Created by Alex Motor on 07.08.15.
//  Copyright (c) 2015 Alex Motor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMGameContoller.h"

@interface AMStartGameViewController : UIViewController <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel* currentTeamLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction) backButtonAction:(id)sender;

@end
