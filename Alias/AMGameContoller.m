//
//  AMGameContoller.m
//  Alias
//
//  Created by Alex Motor on 05.08.15.
//  Copyright (c) 2015 Alex Motor. All rights reserved.
//

#import "AMGameContoller.h"

extern NSString* const AMGameControllerRoundTimeRemainChangeValueNotification =
    @"AMGameControllerRoundTimeRemainChangeValueNotification";
extern NSString* const AMGameControllerRoundTimeUpNotification =
    @"AMGameControllerRoundTimeUpNotification";

extern NSString* const AMGameControllerRoundTimeRemainChangeValueUserInfoKey =
    @"AMGameControllerRoundTimeRemainChangeValueUserInfoKey";

@interface AMGameContoller ()

@property (strong, nonatomic) NSMutableArray* teams;
@property (strong, nonatomic) NSMutableArray* wordPackages;
@property (strong, nonatomic) AMGame* currentGame;
@property (strong, nonatomic) NSTimer* roundTimer;

@end

@implementation AMGameContoller

#pragma mark - Initialize

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.teams = [NSMutableArray array];
        self.wordPackages = [NSMutableArray array];
        
        NSArray* defaultTeamNames = [NSArray arrayWithObjects:@"Минеры", @"Декады", nil];
        
        for (int i = 0; i < 2; i++) {
            AMTeam* team = [[AMTeam alloc] initWithName:[defaultTeamNames objectAtIndex:i]];
            [self.teams addObject:team];
        }
        
        for (int i = 0; i < 3; i++) {
            AMWordPachage* pachage = [[AMWordPachage alloc] initPachageWithDifficulty:i];
            [self.wordPackages addObject:pachage];
        }
    }
    return self;
}

#pragma mark - Team manipulation

- (NSArray*) getTeamsList {
    NSMutableArray* teamsName = [NSMutableArray array];
    for (AMTeam* team in self.teams) {
        [teamsName addObject:team.name];
    }
    
    return teamsName;
}

- (NSArray*) getAllTeamsName {
    NSMutableArray* teamsName = [NSMutableArray array];
    for (AMTeam* team in self.currentGame.teams) {
        [teamsName addObject:team.name];
    }
    
    return teamsName;
}

- (NSArray*) getAllTeamsScore {
    NSMutableArray* teamsScore = [NSMutableArray array];
    
    for (AMTeam* team in self.currentGame.teams) {
        [teamsScore addObject:[NSString stringWithFormat:@"%ld", team.score]];
    }
    
    return teamsScore;
}

- (BOOL) addTeamWithName:(NSString *)name {
    
    BOOL uniqueName = [self isUniqueName:name];
    
    if (uniqueName) {
        AMTeam* team = [[AMTeam alloc] initWithName:name];
        
        [self.teams addObject:team];
    }
    
    return uniqueName;
}

- (BOOL) changeNameOfTeamAtIndex:(NSInteger)index toName:(NSString*) name {
    BOOL uniqueName = [self isUniqueName:name];
    
    if (uniqueName) {
        AMTeam* team = [self.teams objectAtIndex:index];
        team.name = name;
    }
    
    return uniqueName;
}

- (void) removeTeamAtIndex:(NSInteger) index {
    [self.teams removeObjectAtIndex:index];
}


#pragma mark - Private methods

- (BOOL) isUniqueName:(NSString*) name {
    for (AMTeam* team in self.teams) {
        if ([team.name isEqualToString:name]) {
            return NO;
        }
    }
    return YES;
}

#pragma mark - Game

- (void) createNewGameWithTeamsAtIndexes:(NSArray*) indexes{
    AMGame* game = [[AMGame alloc] init];
    self.currentGame = game;
    
    NSMutableArray* gameTeams = [NSMutableArray array];
    
    for (int i = 0; i < [indexes count]; i++) {
        NSInteger teamIndex = [[indexes objectAtIndex:i] integerValue];
        AMTeam* team = [self.teams objectAtIndex:teamIndex];
        
        [gameTeams addObject:team];
        
        if (i == 0) {
            self.currentGame.currentTeam = team;
        }
    }
    
    self.currentGame.teams = gameTeams;
}

- (void) setRoundTime:(NSInteger) roundTime wordCountToWin:(NSInteger)
                            wordCount lastWordToEveryone:(BOOL) lastWord andExtraQuest:(BOOL) extraQuest {
    if (self.currentGame) {
        AMGame* game = self.currentGame;
        
        game.roundTimeInSecond = roundTime;
        game.scoreToWin = wordCount;
        game.lastWordForEveryone = lastWord;
        game.extraQuest = extraQuest;
    }
}

- (NSArray*) getAllWordPackages {
    NSMutableArray* tempArray = [NSMutableArray array];
    for (AMWordPachage* package in self.wordPackages) {
        [tempArray addObject:package];
    }
    
    return tempArray;
}

- (void) setWordPackageAtIndex:(NSInteger) index {
    if (self.currentGame) {
        AMWordPachage* wordPackage = [self.wordPackages objectAtIndex:index];
        self.currentGame.currentWordPocket = wordPackage;
    }
}

- (NSString*) getCurrentTeam {
    return self.currentGame.currentTeam.name;
}

- (NSString *)getWinnerTeam {
    NSInteger bestScore = 0;
    AMTeam* teamWithBestScore = nil;
    
    for (AMTeam* team in self.currentGame.teams) {
        if (team.score > bestScore) {
            bestScore = team.score;
            teamWithBestScore = team;
        }
    }
    
    return teamWithBestScore.name;
}

#pragma mark - Game manipulation

- (void) startGameRound {
    self.currentGame.secondRemain = self.currentGame.roundTimeInSecond;
    self.roundTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                       target:self
                                                     selector:@selector(everySecondAction)
                                                     userInfo:nil
                                                      repeats:YES];
}

- (void) addCorrectAnswer {
    self.currentGame.answeredCount++;
    
}

- (void) addNotAnswered {
    self.currentGame.notAnsweredCount++;
}

- (NSString *)getWord {
    NSMutableArray* unviewedWords = self.currentGame.currentWordPocket.unviewedWords;
    NSInteger randomIndex = arc4random_uniform((int)[unviewedWords count]);
    
    NSString* returnString = [unviewedWords objectAtIndex:randomIndex];
    [unviewedWords removeObjectAtIndex:randomIndex];
    
    return returnString;
}

- (void) endRound{
    AMTeam* currentTeam = self.currentGame.currentTeam;
    [self.currentGame.currentWordPocket refreshUnviewedWords];
    
    if ([currentTeam isEqual:[self.currentGame.teams lastObject]]) {
        self.currentGame.currentTeam = [self.currentGame.teams firstObject];
        self.currentGame.round++;
        
    } else {
        NSInteger indexOfCurrentTeam =
        [self.currentGame.teams indexOfObject:currentTeam];
        self.currentGame.currentTeam =
        [self.currentGame.teams objectAtIndex:indexOfCurrentTeam + 1];
    }
}

- (BOOL) isEndGame {
    NSArray* teams = self.currentGame.teams;
    
    AMTeam* currentTeam = self.currentGame.currentTeam;
    
    NSInteger scoreOnRound = self.currentGame.answeredCount - self.currentGame.notAnsweredCount;
    currentTeam.score += scoreOnRound;
    self.currentGame.answeredCount = 0;
    self.currentGame.notAnsweredCount = 0;
    
    if ([currentTeam isEqual:[self.currentGame.teams lastObject]]) {
        NSInteger bestScore = 0;
        AMTeam* teamWithBestScore = nil;
        
        for (AMTeam* team in teams) {
            if (team.score > bestScore) {
                bestScore = team.score;
                teamWithBestScore = team;
            }
        }
        
        if (bestScore > self.currentGame.scoreToWin) {
            NSInteger teamCountWithBestScore = 0;
            for (AMTeam* team in teams) {
                if (team.score == bestScore) {
                    teamCountWithBestScore++;
                }
            }
            
            if (teamCountWithBestScore > 1) {
                [self endRound];
                return NO;
            } else {
                return YES;
            }
        } else {
            [self endRound];
            return NO;
        }

    }
    [self endRound];
    return NO;
}


#pragma mark - Timer Action

- (void) everySecondAction {
    if (self.currentGame.secondRemain > 0) {
        self.currentGame.secondRemain--;
        NSLog(@"Timer: %ld", self.currentGame.secondRemain);
        [self postNotificationAboutRoundTimeRemain:self.currentGame.secondRemain];
    }
    else
    {
        NSLog(@"Game ended: %ld", self.currentGame.secondRemain);
        [self.roundTimer invalidate];
        [self postNotificationAboutRountTimeUp];
        //invoke end round
    }
}


#pragma mark - Notifications


- (void) postNotificationAboutRoundTimeRemain:(NSInteger) timeRemain {
    NSDictionary* userInfo = [NSDictionary dictionaryWithObject:[[NSNumber alloc] initWithInteger:timeRemain]
                                                         forKey:AMGameControllerRoundTimeRemainChangeValueUserInfoKey];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:AMGameControllerRoundTimeRemainChangeValueNotification
                                                        object:nil
                                                      userInfo:userInfo];
}

- (void) postNotificationAboutRountTimeUp {
    [[NSNotificationCenter defaultCenter]
     postNotificationName:AMGameControllerRoundTimeUpNotification object:nil];
}


#pragma mark - Getters

- (BOOL) lastWordToEveryone {
    return self.currentGame.lastWordForEveryone;
}

- (BOOL) haveExtraQuest {
    return self.currentGame.extraQuest;
}

- (NSInteger) getRoundTime {
    return self.currentGame.roundTimeInSecond;
}

- (NSInteger) getAnsweredCount {
    return self.currentGame.answeredCount;
}

- (NSInteger) getNotAnsweredCount {
    return self.currentGame.notAnsweredCount;
}



@end
