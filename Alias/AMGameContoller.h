//
//  AMGameContoller.h
//  Alias
//
//  Created by Alex Motor on 05.08.15.
//  Copyright (c) 2015 Alex Motor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMGame.h"
#import "AMTeam.h"
#import "AMWordPachage.h"

extern NSString* const AMGameControllerRoundTimeRemainChangeValueNotification;
extern NSString* const AMGameControllerRoundTimeUpNotification;

extern NSString* const AMGameControllerRoundTimeRemainChangeValueUserInfoKey;

@interface AMGameContoller : NSObject

- (NSArray*) getTeamsList;
- (NSArray*) getAllTeamsName;
- (NSArray*) getAllTeamsScore;
- (BOOL) addTeamWithName:(NSString*) name;
- (BOOL) changeNameOfTeamAtIndex:(NSInteger)index toName:(NSString*) name;
- (void) removeTeamAtIndex:(NSInteger) index;

- (void) createNewGameWithTeamsAtIndexes:(NSArray*) indexes;
- (void) setRoundTime:(NSInteger) roundTime
       wordCountToWin:(NSInteger) wordCount
   lastWordToEveryone:(BOOL) lastWord
        andExtraQuest:(BOOL) extraQuest;
- (NSArray*) getAllWordPackages;
- (void) setWordPackageAtIndex:(NSInteger) index;
- (NSString*) getCurrentTeam;
- (NSString*) getWinnerTeam;

- (void) startGameRound;
- (void) addCorrectAnswer;
- (void) addNotAnswered;
- (NSString*) getWord;
- (BOOL) isEndGame;

- (BOOL) lastWordToEveryone;
- (BOOL) haveExtraQuest;
- (NSInteger) getRoundTime;
- (NSInteger) getAnsweredCount;
- (NSInteger) getNotAnsweredCount;

@end
