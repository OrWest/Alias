//
//  ViewController.m
//  Alias
//
//  Created by Alex Motor on 05.08.15.
//  Copyright (c) 2015 Alex Motor. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction) pressOKAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
