//
//  AMPlayViewController.m
//  Alias
//
//  Created by Alex Motor on 08.08.15.
//  Copyright (c) 2015 Alex Motor. All rights reserved.
//

#import "AMPlayViewController.h"

typedef enum {
    AMAnimationDirectiomUp,
    AMAnimationDirectiomDown
} AMAnimationDirection;

@interface AMPlayViewController ()

@property (strong, nonatomic) AMGameContoller* gameController;
@property (strong, nonatomic) UISwipeGestureRecognizer* swipeUpRecognizer;
@property (strong, nonatomic) UISwipeGestureRecognizer* swipeDownRecognizer;
@property (assign, nonatomic) NSInteger selectedIndexInTableView;

@end

@implementation AMPlayViewController

#pragma mark - initialize and destroy

- (void)viewDidLoad {
    [super viewDidLoad];
    self.gameController = [AMGameContoller instance];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.wordView.layer.borderWidth = 3.0f;
    self.wordView.layer.borderColor = [UIColor redColor].CGColor;
    self.wordView.layer.cornerRadius = 10.0f;
    
    if ([self.gameController haveExtraQuest]) {
        self.extraQuestLabel.text = [self.gameController getExtraQuest];
    }
    self.halfAlphaViewWithTip.backgroundColor =
    [[UIColor blackColor] colorWithAlphaComponent:0.8f];
    self.viewWithTip.layer.borderWidth = 4.f;
    self.viewWithTip.layer.borderColor = [UIColor redColor].CGColor;
    self.viewWithTip.layer.cornerRadius = 10.0f;
    
    self.lastWordView.backgroundColor =
    [[UIColor blackColor] colorWithAlphaComponent:0.8f];
    self.lastWordView.transform =
    CGAffineTransformMakeTranslation(0, CGRectGetHeight(self.lastWordView.bounds));
    
    if (![self.gameController haveExtraQuest]) {
        self.halfAlphaViewWithTip.transform =
        CGAffineTransformMakeTranslation(0, CGRectGetHeight(self.halfAlphaViewWithTip.bounds));
        [self startGame];
    } else {
        self.toptipLabel.hidden = NO;
        self.extraQuestLabel.hidden = NO;
        self.endTipLabel.hidden = YES;
    }
    
    self.roundRemainLabel.text = [NSString stringWithFormat:@"%ld", (long)[self.gameController getRoundTime]];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private methods

- (void) startGame{
    self.swipeUpRecognizer =
    [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(handleSwipeUpRecognizer:)];
    
    self.swipeDownRecognizer =
    [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(handleSwipeDownRecognizer:)];
    
    self.swipeUpRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    self.swipeDownRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    
    [self.view addGestureRecognizer:self.swipeUpRecognizer];
    [self.view addGestureRecognizer:self.swipeDownRecognizer];
    
    NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self
                           selector:@selector(rountTimeRemainChangeNotificationHandle:)
                               name:AMGameControllerRoundTimeRemainChangeValueNotification
                             object:nil];
    
    [notificationCenter addObserver:self
                           selector:@selector(rountTimeUpNotificationHandle:)
                               name:AMGameControllerRoundTimeUpNotification
                             object:nil];
    
    
    [self.gameController startGameRound];
    self.wordLabel.text = [self.gameController getWord];
}

- (void) refreshAnsweredCountLabel {
    self.answeredLabel.text = [NSString stringWithFormat:@"+%ld", (long)[self.gameController getAnsweredCount]];
}

- (void) refreshNotAnsweredCountLabel {
    self.notAnsweredLabel.text = [NSString stringWithFormat:@"-%ld", (long)[self.gameController getNotAnsweredCount]];

}

- (void) turnOffGestures {
    [self.view removeGestureRecognizer:self.swipeDownRecognizer];
    [self.view removeGestureRecognizer:self.swipeUpRecognizer];
}

- (void) printNewWordAnimatedWithDirection:(AMAnimationDirection) animationDirection {
    CGFloat animationDuration = 0.18f;
    CGFloat yOffset = CGRectGetHeight(self.wordView.bounds) / 2;
    NSInteger directionFactor;
    
    if (animationDirection == AMAnimationDirectiomUp) {
        directionFactor = 1;
    } else {
        directionFactor = -1;
    }
    
    [UIView animateWithDuration:animationDuration
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.wordLabel.transform = CGAffineTransformMakeTranslation(0, yOffset * (-1) * directionFactor);
                         self.wordLabel.alpha = 0.f;
                     }
                     completion:^(BOOL finished) {
                         self.wordLabel.text = [self.gameController getWord];
                         self.wordLabel.transform = CGAffineTransformMakeTranslation(0, yOffset * directionFactor);
                         [UIView animateWithDuration:animationDuration
                                               delay:0
                                             options:UIViewAnimationOptionCurveLinear
                                          animations:^{
                                              self.wordLabel.transform = CGAffineTransformIdentity;
                                              self.wordLabel.alpha = 1.f;
                                          }
                                          completion:^(BOOL finished) {
                                          }];

                     }];
}


#pragma mark - Gestures handle

- (void) handleSwipeUpRecognizer:(UISwipeGestureRecognizer*) recognizer {
    [self.gameController addCorrectAnswer];
    [self refreshAnsweredCountLabel];
    [self printNewWordAnimatedWithDirection:AMAnimationDirectiomUp];
}

- (void) handleSwipeDownRecognizer:(UISwipeGestureRecognizer*) recognizer {
    [self. gameController addNotAnswered];
    [self refreshNotAnsweredCountLabel];
    [self printNewWordAnimatedWithDirection:AMAnimationDirectiomDown];
}

#pragma mark - Notification handles


- (void) rountTimeRemainChangeNotificationHandle:(NSNotification*) notification {
    NSDictionary* userInfo = notification.userInfo;
    NSNumber* roundTimeRemain =
    [userInfo objectForKey:AMGameControllerRoundTimeRemainChangeValueUserInfoKey];
    self.roundRemainLabel.text =
    [NSString stringWithFormat:@"%ld", (long)[roundTimeRemain integerValue]];
}

- (void) rountTimeUpNotificationHandle:(NSNotification*) notification {
    self.toptipLabel.hidden = YES;
    self.extraQuestLabel.hidden = YES;
    self.endTipLabel.hidden = NO;
    
    [self turnOffGestures];
    
    if ([self.gameController lastWordToEveryone]) {
        [self.lastWordTableView reloadData];
        self.lastWordLabel.text = self.wordLabel.text;
        [UIView animateWithDuration:0.3
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.lastWordView.transform = CGAffineTransformIdentity;
                         } completion:^(BOOL finished) {
                         }];
    } else {
        [UIView animateWithDuration:0.3
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.halfAlphaViewWithTip.transform = CGAffineTransformIdentity;
                         }
                         completion:^(BOOL finished) {
                         }];
    }
}

#pragma mark - Actions

- (IBAction)tipOkAction:(UIButton*)sender {
    if (self.endTipLabel.hidden) {
        [UIView animateWithDuration:0.3
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.halfAlphaViewWithTip.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(self.halfAlphaViewWithTip.bounds));
                         }
                         completion:^(BOOL finished) {
                         }];
        [self startGame];
    } else {
        if ([self.gameController isEndGame]) {
            [self performSegueWithIdentifier:@"EndGame" sender:self];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)lastWordOKAction:(UIButton *)sender {
    for (int i = 0; i < [[self.gameController getTeamsNamesInGame] count] + 1; i++) {
        UITableViewCell* cell = [self.lastWordTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
            if (i != 0) {
                [self.gameController addLastWordPointToTeamAtIndex:i - 1];
            }
            break;
        }
    }
    
    if ([self.gameController isEndGame]) {
        [self performSegueWithIdentifier:@"EndGame" sender:self];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }

}

- (void)backButtonAction:(UIButton *)sender {
    [self.gameController stopGame];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[self.gameController getTeamsNamesInGame] count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* teamIdentifier = @"TeamCell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:teamIdentifier];
    
    if (cell) {
        if (indexPath.row != 0) {
            NSArray* names = [self.gameController getTeamsNamesInGame];
            cell.textLabel.text = [names objectAtIndex:indexPath.row - 1];
        }
        
        if (indexPath.row == self.selectedIndexInTableView) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    
    
    return cell;
}

#pragma mark - UITableViewDelegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    for (int i = 0; i < [[self.gameController getTeamsNamesInGame] count] + 1; i++) {
        UITableViewCell* cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if (indexPath.row == i) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            self.selectedIndexInTableView = i;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
}


@end
