//
//  AMListViewController.h
//  Alias
//
//  Created by Alex Motor on 10.08.15.
//  Copyright (c) 2015 Alex Motor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMListViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UITableView* tableView;

- (IBAction)backButtonAction:(id)sender;
- (IBAction)goToSiteAction:(id)sender;

@end
