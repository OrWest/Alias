//
//  AMPlayViewController.h
//  Alias
//
//  Created by Alex Motor on 08.08.15.
//  Copyright (c) 2015 Alex Motor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMGameContoller.h"

@interface AMPlayViewController : UIViewController
@property (weak, nonatomic) AMGameContoller* gameController;

@property (weak, nonatomic) IBOutlet UIView *wordView;
@property (weak, nonatomic) IBOutlet UILabel *answeredLabel;
@property (weak, nonatomic) IBOutlet UILabel *notAnsweredLabel;
@property (weak, nonatomic) IBOutlet UILabel *roundRemainLabel;
@property (weak, nonatomic) IBOutlet UILabel *wordLabel;

@end
