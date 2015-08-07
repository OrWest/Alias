//
//  AMPackageViewController.h
//  Alias
//
//  Created by Alex Motor on 07.08.15.
//  Copyright (c) 2015 Alex Motor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMGameContoller.h"

@interface AMPackageViewController : UIViewController <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView* tableView;

- (void) installGameController:(AMGameContoller*) gameController;

@end
