//
//  AMRulesAndBuyViewController.m
//  Alias
//
//  Created by Alex Motor on 09.08.15.
//  Copyright (c) 2015 Alex Motor. All rights reserved.
//

#import "AMRulesAndBuyViewController.h"

@implementation AMRulesAndBuyViewController

#pragma mark - View methods

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.halfAlphaViewWithSuccess.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8f];
    self.halfAlphaViewWithSuccess.transform =
    CGAffineTransformMakeTranslation(0, CGRectGetHeight(self.halfAlphaViewWithSuccess.bounds));
    
    self.purchaseSuccessView.layer.borderWidth = 4.f;
    self.purchaseSuccessView.layer.borderColor = [UIColor redColor].CGColor;
    self.purchaseSuccessView.layer.cornerRadius = 10.0f;
}

#pragma mark - Actions

- (IBAction)rulesOKAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)purchaseSuccessAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)purchaseButtonAction:(UIButton *)sender {
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.halfAlphaViewWithSuccess.transform = CGAffineTransformIdentity;
                     }
                     completion:^(BOOL finished) {
                     }];
}

- (void)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
