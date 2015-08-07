//
//  TeamCell.h
//  Alias
//
//  Created by Alex Motor on 07.08.15.
//  Copyright (c) 2015 Alex Motor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface AMTeamCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *teamName;
@property (weak, nonatomic) IBOutlet ViewController* viewController;
@property (assign, nonatomic) BOOL checked;

- (IBAction)pressTeamCheckerAction:(UIButton *)sender;

@end
