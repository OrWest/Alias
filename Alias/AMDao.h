//
//  AMDao.h
//  Alias
//
//  Created by Alex Motor on 10.08.15.
//  Copyright (c) 2015 Alex Motor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMDao : NSObject

- (void) saveProperties;
- (void) loadProperies;

- (NSMutableArray*) getTeams;
- (NSMutableArray*) getWordPackages;
- (NSMutableArray*) getExtraQuests;

- (void) addTeamWithName:(NSString*) name;
- (void) changeTeamNameAtIndex:(NSInteger) index withName:(NSString*) name;
- (void) removeTeamAtIndex:(NSInteger) index;

- (void) addExtraQuest:(NSString*) quest;

- (void) addWordPackageWithName:(NSString*) name difficulty:(NSInteger) difficulty andWords:(NSArray*) words;

- (void) startGame;
- (void) endGame;
- (BOOL) haveContinue;

- (void) createGameWithTeams:(NSArray*) teams;
- (void) setGameRoundTime:(NSInteger) rountTime scoreToWin:(NSInteger) scoreToWin lastWordForEveryone:(BOOL)lastWordForEveryOne andExtraQuest:(BOOL) extraQuest;
- (void) setRound:(NSInteger) round;
- (void) setCurrentTeamName:(NSString*) name;
- (void) setCurrentWordPackageName:(NSString*) name;
- (void) addScore:(NSInteger)addScore toTeamWithName:(NSString *)name;
- (void) removeGame;

- (NSArray*) getTeamsInGame;
- (NSArray*) getTeamsScore;
- (NSInteger) getRound;
- (NSInteger) getRoundTime;
- (NSInteger) getScoreToWin;
- (BOOL) lastWordForEveryone;
- (BOOL) haveExtraQuests;
- (NSString*) getCurrentTeamName;
- (NSString*) getCurrentWordPackageName;


@end
