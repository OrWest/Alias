//
//  AMPlayViewController.m
//  Alias
//
//  Created by Alex Motor on 08.08.15.
//  Copyright (c) 2015 Alex Motor. All rights reserved.
//

#import "AMPlayViewController.h"

@implementation AMPlayViewController

#pragma mark - initialize and destroy

- (void)viewDidLoad {
    self.wordView.layer.borderWidth = 3.0f;
    self.wordView.layer.borderColor = [UIColor blueColor].CGColor;
    self.wordView.layer.cornerRadius = 10.0f;
    
#warning not develop
    if ([self.gameController haveExtraQuest]) {
        //add half of alpha view
    }
    
    UISwipeGestureRecognizer* swipeUpRecognizer =
    [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(handleSwipeUpRecognizer:)];
    
    UISwipeGestureRecognizer* swipeDownRecognizer =
    [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(handleSwipeDownRecognizer:)];
    
    swipeUpRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    swipeDownRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    
    [self.view addGestureRecognizer:swipeUpRecognizer];
    [self.view addGestureRecognizer:swipeDownRecognizer];
    
    NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self
                           selector:@selector(rountTimeRemainChangeNotificationHandle:)
                               name:AMGameControllerRoundTimeRemainChangeValueNotification
                             object:nil];
    
    [notificationCenter addObserver:self
                           selector:@selector(rountTimeUpNotificationHandle:)
                               name:AMGameControllerRoundTimeUpNotification
                             object:nil];
    
    [self startGame];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private methods

- (void) startGame{
    self.roundRemainLabel.text = [NSString stringWithFormat:@"%ld", [self.gameController getRoundTime]];
    
    [self.gameController startGameRound];
    self.wordLabel.text = [self.gameController getWord];
}

- (void) refreshAnsweredCountLabel {
    self.answeredLabel.text = [NSString stringWithFormat:@"+%ld", [self.gameController getAnsweredCount]];
}

- (void) refreshNotAnsweredCountLabel {
    self.notAnsweredLabel.text = [NSString stringWithFormat:@"-%ld", [self.gameController getNotAnsweredCount]];

}


#pragma mark - Gestures handle

- (void) handleSwipeUpRecognizer:(UISwipeGestureRecognizer*) recognizer {
    [self.gameController addCorrectAnswer];
    [self refreshAnsweredCountLabel];
    self.wordLabel.text = [self.gameController getWord];
}

- (void) handleSwipeDownRecognizer:(UISwipeGestureRecognizer*) recognizer {
    [self. gameController addNotAnswered];
    [self refreshNotAnsweredCountLabel];
    self.wordLabel.text = [self.gameController getWord];
}

#pragma mark - Notification handles


- (void) rountTimeRemainChangeNotificationHandle:(NSNotification*) notification {
    NSDictionary* userInfo = notification.userInfo;
    NSNumber* roundTimeRemain =
    [userInfo objectForKey:AMGameControllerRoundTimeRemainChangeValueUserInfoKey];
    self.roundRemainLabel.text =
    [NSString stringWithFormat:@"%ld", [roundTimeRemain integerValue]];
}

- (void) rountTimeUpNotificationHandle:(NSNotification*) notification {
    if ([self.gameController isEndGame]) {
        [self performSegueWithIdentifier:@"EndGame" sender:self];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [segue.destinationViewController setGameController:self.gameController];
}


@end
