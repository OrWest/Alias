//
//  AMRulesAndBuyViewController.h
//  Alias
//
//  Created by Alex Motor on 09.08.15.
//  Copyright (c) 2015 Alex Motor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMRulesAndBuyViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *purchaseSuccessView;
@property (weak, nonatomic) IBOutlet UIView *halfAlphaViewWithSuccess;

- (IBAction)rulesOKAction:(UIButton *)sender;
- (IBAction)purchaseButtonAction:(UIButton *)sender;
- (IBAction)purchaseSuccessAction:(id)sender;
- (IBAction)backButtonAction:(id)sender;

@end
