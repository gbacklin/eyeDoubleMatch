//
//  RootViewControlleriPhone.m
//  eyeDoubleMatch
//
//  Created by Gene Backlin on 9/10/10.
//  Copyright 2010 MariZack Consulting. All rights reserved.
//

#import "AppSpecificValues.h"
#import "RootViewControlleriPhone.h"
#import "PropertyList.h"
#import "NSArray-Shuffle.h"
#import "AdViewController.h"
#import "GameCenterManager.h"
#import "GameCenterViewController.h"


#define kTransitionDuration	0.75
#define GROW_ANIMATION_DURATION_SECONDS 0.15    // Determines how fast a piece size grows when it is moved.
#define SHRINK_ANIMATION_DURATION_SECONDS 0.15  // Determines how fast a piece size shrinks when a piece stops moving.


@implementation RootViewControlleriPhone
@synthesize pile1;
@synthesize pile2;
@synthesize pile3;
@synthesize pile4;
@synthesize pile5;
@synthesize pile6;
@synthesize pile7;
@synthesize pile8;
@synthesize pileDeal;
@synthesize countLabel;
@synthesize scoreLabel;

@synthesize deck;
@synthesize shuffledDeck;
@synthesize cardPile;
@synthesize cardCount;
@synthesize matchedPairs;

@synthesize draggingImage;
@synthesize adView;
@synthesize bannerVisible;
@synthesize gameCenterEnabled;

@synthesize gameCenterManager;

@synthesize currentScore;
@synthesize cachedHighestScore;

@synthesize personalBestScoreDescription;
@synthesize personalBestScoreString;
@synthesize personalTodayBestScoreString;
@synthesize leaderboardHighScoreDescription;
@synthesize leaderboardHighScoreString;

@synthesize currentLeaderBoard;
@synthesize infoButton;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	[self setCurrentLeaderBoard:kEasyLeaderboardID];
	[self setCurrentScore:0];
	
    [super viewDidLoad];

	if([GameCenterManager isGameCenterAvailable]) {
		[self setGameCenterEnabled:YES];
		[self setGameCenterManager:[[GameCenterManager alloc] init]];
		[[self gameCenterManager] setDelegate:self];
		[[self gameCenterManager] authenticateLocalUser];
		
		[self updateCurrentScore];
	} else {
		[self setGameCenterEnabled:NO];
	}
	
	[scoreLabel setText:[NSString stringWithFormat:@"%lld", [self currentScore]]];
	[self loadAdView];
	
	NSDictionary *cardDeck = [NSDictionary dictionaryFromPropertyList:@"CardDeck"];
	[self setDeck:[cardDeck objectForKey:@"Deck"]];
	[self initGame];
    
    [[self infoButton] setTintColor:[UIColor whiteColor]];

    // resize to fit window
    [[self view] setFrame:[[UIScreen mainScreen] bounds]];
    [self view].autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
}

#pragma mark -
#pragma mark Game Methods

- (void)initGame {
	NSArray *keys = [[self deck] allKeys];
	
	[countLabel setText:@"44 cards remaining"];
	
	[self setShuffledDeck:[self generateShuffledDeck:[[keys shuffledArray] shuffledArray]]];
	[self dealCards];
	[self locatePairsInDealtPile];
}

- (IBAction)newGame:(id)sender {
	[pileDeal setImage:[UIImage imageNamed:@"back-blue-75-2.png"]];
	[draggingImage removeFromSuperview];
	[self initGame];
}

#pragma mark -
#pragma mark Card Methods

- (void)dealCards {
	NSDictionary *card = nil;
	NSMutableArray *pileArray = [[NSMutableArray alloc] init];
	
	for(int i=0;i<8;i++) {
		card = [[self shuffledDeck] objectAtIndex:i];
		[pileArray addObject:card];
		[card setValue:[NSNumber numberWithInt:i] forKey:@"pileIndex"];
		[self addCardToPile:card atIndex:i];
	}
	[self setCardPile:pileArray];
	[self setCardCount:[NSNumber numberWithInt:8]];
	[self setCurrentScore:[self currentScore]-8];

	[scoreLabel setText:[NSString stringWithFormat:@"%lld", [self currentScore]]];
}

- (NSArray *)generateShuffledDeck:(NSArray *)array {
	NSArray *keys = [array shuffledArray];
	NSMutableArray *shuffledCards = [[NSMutableArray alloc] init];
	int i = 0;
	
	for(i=0;i<[keys count];i++) {
		NSString *key = [keys objectAtIndex:i];
		NSDictionary *card = [[self deck] objectForKey:key];
		[card setValue:[NSNumber numberWithInt:i] forKey:@"pileIndex"];
		[shuffledCards addObject:card];
	}
	
	return shuffledCards;
}

- (BOOL)addCardToPile:(NSDictionary *)aCard atIndex:(int)aIndex {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:kTransitionDuration];
	NSString *aImageName = [aCard objectForKey:@"image"];
	
	[self setCurrentScore:[self currentScore]+1];
	[scoreLabel setText:[NSString stringWithFormat:@"%lld", [self currentScore]]];
	[self checkAchievements];
	
	switch(aIndex) {
		case 0:
			[UIView setAnimationTransition:(UIViewAnimationTransitionFlipFromRight)
								   forView:pile1 cache:YES];
			[pile1 setImage:[UIImage imageNamed:aImageName]];
			break;
			
		case 1:
			[UIView setAnimationTransition:(UIViewAnimationTransitionFlipFromRight)
								   forView:pile2 cache:YES];
			[pile2 setImage:[UIImage imageNamed:aImageName]];
			break;
			
		case 2:
			[UIView setAnimationTransition:(UIViewAnimationTransitionFlipFromRight)
								   forView:pile3 cache:YES];
			[pile3 setImage:[UIImage imageNamed:aImageName]];
			break;
			
		case 3:
			[UIView setAnimationTransition:(UIViewAnimationTransitionFlipFromRight)
								   forView:pile4 cache:YES];
			[pile4 setImage:[UIImage imageNamed:aImageName]];
			break;
			
		case 4:
			[UIView setAnimationTransition:(UIViewAnimationTransitionFlipFromRight)
								   forView:pile5 cache:YES];
			[pile5 setImage:[UIImage imageNamed:aImageName]];
			break;
			
		case 5:
			[UIView setAnimationTransition:(UIViewAnimationTransitionFlipFromRight)
								   forView:pile6 cache:YES];
			[pile6 setImage:[UIImage imageNamed:aImageName]];
			break;
			
		case 6:
			[UIView setAnimationTransition:(UIViewAnimationTransitionFlipFromRight)
								   forView:pile7 cache:YES];
			[pile7 setImage:[UIImage imageNamed:aImageName]];
			break;
			
		case 7:
			[UIView setAnimationTransition:(UIViewAnimationTransitionFlipFromRight)
								   forView:pile8 cache:YES];
			[pile8 setImage:[UIImage imageNamed:aImageName]];
			break;
			
		default:
			[UIView setAnimationTransition:(UIViewAnimationTransitionFlipFromRight)
								   forView:pileDeal cache:YES];
			[pileDeal setImage:[UIImage imageNamed:aImageName]];
			break;
	}
	[UIView commitAnimations];
	
	return YES;
}

- (void)locatePairsInDealtPile {
	NSArray *aCurrentCardPile = [self cardPile];
	NSMutableDictionary *currentMatchedPairs = [[NSMutableDictionary alloc] initWithCapacity:4];
	
	for(int i=0;i<[aCurrentCardPile count];i++) {
		NSDictionary *aCard = [aCurrentCardPile objectAtIndex:i];
		int aCardValue = [[aCard objectForKey:@"value"] intValue];
		NSArray *aCardPair = [currentMatchedPairs objectForKey:[NSNumber numberWithInt:aCardValue]];
		
		if([aCardPair count] < 2) {
			for(int j=i+1;j<[aCurrentCardPile count];j++) {
				NSDictionary *aCardToMatch = [aCurrentCardPile objectAtIndex:j];
				int aCardToMatchValue = [[aCardToMatch objectForKey:@"value"] intValue];
				if(aCardValue == aCardToMatchValue) {
					NSMutableArray *aMatchedPair = [[NSMutableArray alloc] initWithCapacity:2];
					[aMatchedPair addObject:aCard];
					[aMatchedPair addObject:aCardToMatch];
					
					[currentMatchedPairs setObject:aMatchedPair forKey:[NSNumber numberWithInt:aCardValue]];
					
				}
			}
		}
	}
	
	[self setMatchedPairs:currentMatchedPairs];
	
	if([currentMatchedPairs count] < 1) {
		[self notAWinner];
	}
}

#pragma mark -
#pragma mark Gesture Methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	if([[touches anyObject] tapCount] > 1) {
		[self autoReplaceMatch];
	} else {
		[draggingImage removeFromSuperview];
		for (UITouch *touch in touches) {
			[self dispatchFirstTouchAtPoint:[touch locationInView:[self view]] forEvent:nil];
		}
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	for (UITouch *touch in touches) {
		[self dispatchTouchEvent:[touch view] toPosition:[touch locationInView:[self view]]];
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {	
	for (UITouch *touch in touches) {
		[self dispatchTouchEndEvent:[touch view] toPosition:[touch locationInView:[self view]]];
	}
	[self locatePairsInDealtPile];
	replacingCards = NO;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	//NSLog(@"touchesCancelled");
	replacingCards = NO;
}

#pragma mark -
#pragma mark Gesture Dispatch Methods

- (void)dispatchFirstTouchAtPoint:(CGPoint)touchPoint forEvent:(UIEvent *)event {
	if (CGRectContainsPoint([pileDeal frame], touchPoint)) {		
		//draggingImage = [self getPileDealCardImage];
		NSDictionary *pileDealCard = [[self shuffledDeck] objectAtIndex:[[self cardCount] intValue]];
		draggingImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[pileDealCard objectForKey:@"image"]]];
		[[self view] addSubview:draggingImage];
		
		draggingImage.center = pileDeal.center;
		cardMatchPoint = pileDeal.center;
		
		[self animateFirstTouchAtPoint:touchPoint forView:draggingImage];
	}
}

- (void)dispatchTouchEvent:(UIView *)theView toPosition:(CGPoint)position {
	if (CGRectContainsPoint([draggingImage frame], position)) {
		[draggingImage setCenter:position];
	}
	
	if (CGRectContainsPoint([pile1 frame], position)) {
		[self checkForMatch:[[self cardPile] objectAtIndex:0]];
	} else if (CGRectContainsPoint([pile2 frame], position)) {
		[self checkForMatch:[[self cardPile] objectAtIndex:1]];
	} else if (CGRectContainsPoint([pile3 frame], position)) {
		[self checkForMatch:[[self cardPile] objectAtIndex:2]];
	} else if (CGRectContainsPoint([pile4 frame], position)) {
		[self checkForMatch:[[self cardPile] objectAtIndex:3]];
	} else if (CGRectContainsPoint([pile5 frame], position)) {
		[self checkForMatch:[[self cardPile] objectAtIndex:4]];
	} else if (CGRectContainsPoint([pile6 frame], position)) {
		[self checkForMatch:[[self cardPile] objectAtIndex:5]];
	} else if (CGRectContainsPoint([pile7 frame], position)) {
		[self checkForMatch:[[self cardPile] objectAtIndex:6]];
	} else if (CGRectContainsPoint([pile8 frame], position)) {
		[self checkForMatch:[[self cardPile] objectAtIndex:7]];
	}
}

- (void)dispatchTouchEndEvent:(UIView *)theView toPosition:(CGPoint)position {   
	[self animateView:draggingImage toPosition:cardMatchPoint];
}

#pragma mark -
#pragma mark Gesture Utility Methods

- (UIImageView *)getPileDealCardImage {
	NSDictionary *pileDealCard = [[self shuffledDeck] objectAtIndex:[[self cardCount] intValue]];
	return [[UIImageView alloc] initWithImage:[UIImage imageNamed:[pileDealCard objectForKey:@"image"]]];
}

- (UIImageView *)getCardBackImage {
	return [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back-blue-75-2.png"]];
}

- (void)checkForMatch:(NSDictionary *)aPileCard {
	int aPileCardValue = [[aPileCard objectForKey:@"value"] intValue];
	NSArray *aMatchedPair = [matchedPairs objectForKey:[NSNumber numberWithInt:aPileCardValue]];
	if(aMatchedPair) {
		if(!replacingCards) {
			aMatchedPair = [self includePileCard:aPileCard inMatchedPair:aMatchedPair];
			[self replacePileCards:aMatchedPair forCard:aPileCard];
			
			int index = [[self cardCount] intValue];
			unsigned long remaining = [[self shuffledDeck] count] - (index);
			[countLabel setText:[NSString stringWithFormat:@"%lu cards remaining", remaining]];
			
			if(remaining < 2) {
				[self congrats];
			}			
		}
	}
}

- (NSArray *)includePileCard:(NSDictionary *)aPileCard inMatchedPair:(NSArray *)aMatchedPair {
	int aPileCardValue = [[aPileCard objectForKey:@"value"] intValue];
	NSMutableArray *newMatchedPair = nil;
	
	NSDictionary *aMatchedCard1 = [aMatchedPair objectAtIndex:0];
	NSDictionary *aMatchedCard2 = [aMatchedPair objectAtIndex:1];
	
	//NSLog(@"aPileCard Index = %d", [[aPileCard objectForKey:@"pileIndex"] intValue]);
	//NSLog(@"aMatchedCard1 Index = %d", [[aMatchedCard1 objectForKey:@"pileIndex"] intValue]);
	//NSLog(@"aMatchedCard2 Index = %d", [[aMatchedCard2 objectForKey:@"pileIndex"] intValue]);
	
	if([[aPileCard objectForKey:@"pileIndex"] intValue] != [[aMatchedCard1 objectForKey:@"pileIndex"] intValue]) {
		if([[aPileCard objectForKey:@"pileIndex"] intValue] != [[aMatchedCard2 objectForKey:@"pileIndex"] intValue]) {
			newMatchedPair = [[NSMutableArray alloc] initWithCapacity:2];
			[newMatchedPair addObject:aPileCard];
			[newMatchedPair addObject:aMatchedCard1];
			[matchedPairs setObject:newMatchedPair forKey:[NSNumber numberWithInt:aPileCardValue]];
		} else {
			newMatchedPair = [[NSMutableArray alloc] initWithCapacity:2];
			[newMatchedPair addObject:aPileCard];
			[newMatchedPair addObject:aMatchedCard1];
			[matchedPairs setObject:newMatchedPair forKey:[NSNumber numberWithInt:aPileCardValue]];
		}
	} else {
		newMatchedPair = [aMatchedPair mutableCopy];
		[matchedPairs setObject:newMatchedPair forKey:[NSNumber numberWithInt:aPileCardValue]];
	}
	//NSLog(@"*********\n%@*********\ncount = %d", newMatchedPair, [newMatchedPair count]);
	return newMatchedPair;
}

- (void)autoReplaceMatch {
	NSArray *keys = [[self matchedPairs] allKeys];
	NSNumber *key = [keys objectAtIndex:0];
	NSArray *aMatchedPair = [matchedPairs objectForKey:key];
	
	[self checkForMatch:[aMatchedPair objectAtIndex:0]];
}

- (BOOL)replacePileCards:(NSArray *)aMatchedPair forCard:(NSDictionary *)aPileCard {
	replacingCards = YES;
	//NSLog(@"replacePileCards - start pair = %@ pileCard = %@", aMatchedPair, aPileCard);
	
	int aPileCardValue = [[aPileCard objectForKey:@"value"] intValue];
	
	NSDictionary *aMatchedCard1 = [aMatchedPair objectAtIndex:0];
	NSDictionary *aMatchedCard2 = [aMatchedPair objectAtIndex:1];
	
	//NSLog(@"aPileCard Index = %d", [[aPileCard objectForKey:@"pileIndex"] intValue]);
	//NSLog(@"aMatchedCard1 Index = %d", [[aMatchedCard1 objectForKey:@"pileIndex"] intValue]);
	//NSLog(@"aMatchedCard2 Index = %d\n-------------\n", [[aMatchedCard2 objectForKey:@"pileIndex"] intValue]);
	
	
	NSDictionary *aCurrentPileDealCard = [[self shuffledDeck] objectAtIndex:[[self cardCount] intValue]];
	NSDictionary *aNextPileDealCard = [[self shuffledDeck] objectAtIndex:[[self cardCount] intValue]+1];
	
	[self dealCard:aCurrentPileDealCard onCard:aMatchedCard1];
	[self dealCard:aNextPileDealCard onCard:aMatchedCard2];
	
	[matchedPairs removeObjectForKey:[NSNumber numberWithInt:aPileCardValue]];
	
	[self setCardCount:[NSNumber numberWithInt:[[self cardCount] intValue]+2]];
	
	//replacingCards = NO;
	//NSLog(@"replacePileCards - end");
	
	return YES;
}

- (BOOL)dealCard:(NSDictionary *)aCurrentPileDealCard onCard:(NSDictionary *)aMatchedCard {
	int aMatchedCardPileIndex = [[aMatchedCard objectForKey:@"pileIndex"] intValue];
	NSMutableArray *aCardPile = [[self cardPile] mutableCopy];
	NSString *aImageName = [aCurrentPileDealCard objectForKey:@"image"];
	
	[aCurrentPileDealCard setValue:[NSNumber numberWithInt:aMatchedCardPileIndex] 
							forKey:@"pileIndex"];
	
	switch (aMatchedCardPileIndex) {
		case 0:
			draggingImage.center = pile1.center;
			cardMatchPoint = pile1.center;
			[pile1 setImage:[UIImage imageNamed:aImageName]];
			break;
		case 1:
			draggingImage.center = pile2.center;
			cardMatchPoint = pile2.center;
			[pile2 setImage:[UIImage imageNamed:aImageName]];
			break;
		case 2:
			draggingImage.center = pile3.center;
			cardMatchPoint = pile3.center;
			[pile3 setImage:[UIImage imageNamed:aImageName]];
			break;
		case 3:
			draggingImage.center = pile4.center;
			cardMatchPoint = pile4.center;
			[pile4 setImage:[UIImage imageNamed:aImageName]];
			break;
		case 4:
			draggingImage.center = pile5.center;
			cardMatchPoint = pile5.center;
			[pile5 setImage:[UIImage imageNamed:aImageName]];
			break;
		case 5:
			draggingImage.center = pile6.center;
			cardMatchPoint = pile6.center;
			[pile6 setImage:[UIImage imageNamed:aImageName]];
			break;
		case 6:
			draggingImage.center = pile7.center;
			cardMatchPoint = pile7.center;
			[pile7 setImage:[UIImage imageNamed:aImageName]];
			break;
		case 7:
			draggingImage.center = pile8.center;
			cardMatchPoint = pile8.center;
			[pile8 setImage:[UIImage imageNamed:aImageName]];
			break;
		default:
			break;
	}	
	
	[draggingImage removeFromSuperview];
	[aCardPile replaceObjectAtIndex:aMatchedCardPileIndex withObject:aCurrentPileDealCard];
	[self setCardPile:aCardPile];
	
	return [self addCardToPile:aCurrentPileDealCard atIndex:aMatchedCardPileIndex];
}

#pragma mark -
#pragma mark Animation Methods

// Scales up a view slightly which makes the piece slightly larger, as if it is being picked up by the user.
- (void)animateFirstTouchAtPoint:(CGPoint)touchPoint forView:(UIImageView *)theView {
	// Pulse the view by scaling up, then move the view to under the finger.
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:GROW_ANIMATION_DURATION_SECONDS];
	theView.transform = CGAffineTransformMakeScale(1.0, 1.0);
	[UIView commitAnimations];
}

// Scales down the view and moves it to the new position. 
- (void)animateView:(UIView *)theView toPosition:(CGPoint)thePosition {
	[UIView beginAnimations:nil context:NULL];
	//[UIView setAnimationDuration:SHRINK_ANIMATION_DURATION_SECONDS];
	// Set the center to the final postion
	theView.center = thePosition;
	// Set the transform back to the identity, thus undoing the previous scaling effect.
	theView.transform = CGAffineTransformIdentity;
	
	[UIView commitAnimations];	
}

#pragma mark -
#pragma mark Alert Messages

- (IBAction)alertWelcome {
	welcome = NO;

	if([self isGameCenterEnabled]) {
		GameCenterViewController *controller = [[GameCenterViewController alloc] initWithNibName:@"GameCenterViewController" bundle:nil];
		[controller setDelegate:self];
		[controller setCurrentLeaderBoard:[self currentLeaderBoard]];
		[controller setGameCenterManager:[self gameCenterManager]];
		[controller setPersonalTodayBestScoreString:[self personalTodayBestScoreString]];
		[controller setPersonalBestScoreString:[self personalBestScoreString]];
		[controller setCachedHighestScore:[self cachedHighestScore]];
		[controller setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
		
        [self presentViewController:controller animated:YES completion:nil];
		
	} else {
		NSString *title = @"Double Match 6.0.10";
		NSString *mess = @"To play, you must deal cards to cover each set of pairs one pair at a time, or double tap the deal card for auto-match. \nIf you manage to deal the entire deck, You Win ! \nIf not, then you can try again.\n\nThank you for downloading Double Match and I hope you enjoy it !";
		// open a alert with an OK and cancel button
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:mess
													   delegate:self 
											  cancelButtonTitle:nil 
											  otherButtonTitles:@"Ok", nil];
		[alert show];
	}
	
}

- (void)notAWinner {
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"I'm Sorry, there are no more pairs to match."
															 delegate:self cancelButtonTitle:nil 
											   destructiveButtonTitle:@"Try Again" 
													otherButtonTitles:nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	[actionSheet showInView:self.view];
	[self addLose];
}

- (void)congrats {
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Congratulations, YOU DID IT !!!"
															 delegate:self cancelButtonTitle:nil 
											   destructiveButtonTitle:@"You Rock !" 
													otherButtonTitles:nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	[actionSheet showInView:self.view];	
	[self addWin];
}

#pragma mark -
#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if(welcome) {
		welcome = NO;
	} else {
		switch (buttonIndex) {
			case 0:
				//[draggingImage setHidden:YES];
				[pileDeal setImage:[UIImage imageNamed:@"back-blue-75-2.png"]];
				[self initGame];
				break;
			default:
				break;
		}
	}
}

#pragma mark -
#pragma mark - iAd related

- (void)loadAdView {
    if([self canLoadiAd]) {
        UIView *aView = (UIView *)adView;
        aView.frame = CGRectOffset(aView.frame, 0, -50);
		
        AdViewController *adBannerView = [[AdViewController alloc] initWithNibName:@"AdViewController" bundle:nil];
        id bView = [adBannerView view];
        [bView setBackgroundColor:[UIColor colorWithDisplayP3Red:111.0/255.0 green:113.0/255.0 blue:121.0/255.0 alpha:1.0]];
        [bView setDelegate:self];
        [adView addSubview:bView];
    }
}

- (BOOL)canLoadiAd {
    NSArray *array = [[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"." ];
    NSString *majorVersion = [array objectAtIndex:0];
    int ver = [majorVersion intValue];
    if(ver < 4) {
        return NO;
    } else {
        return YES;
    }
}

#pragma mark -
#pragma mark iAd Banner display methods

- (void)hideAdBanner:(UIView *)banner {
    [UIView beginAnimations:@"animateBanner" context:NULL];
    // assumes the banner view is at the top of the screen.
    banner.frame = CGRectOffset(banner.frame, 0, -50);
    [UIView commitAnimations];
    [self setBannerVisible:NO];
}

- (void)showAdBanner:(UIView *)banner {
    [UIView beginAnimations:@"animateBanner" context:NULL];
    // assumes the banner view is at the top of the screen.
    banner.frame = CGRectOffset(banner.frame, 0, 50);
    [UIView commitAnimations];
    [self setBannerVisible:YES];
}

#pragma mark -
#pragma mark - iAd delegate methods

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave {
    BOOL shouldExecuteAction = [self canLoadiAd];
    if (!willLeave && shouldExecuteAction) {
        // insert code here to suspend any services that might conflict 
		// with the advertisement
    }
    return shouldExecuteAction;
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    if (![self isBannerVisible]) {
		[self showAdBanner:[self adView]];
		[self setBannerVisible:YES];
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
	if ([self isBannerVisible]) {
		[self hideAdBanner:[self adView]];
		[self setBannerVisible:NO];
	}
}

#pragma mark -
#pragma mark Game Center functionality

- (void)showAlertWithTitle:(NSString*)title message:(NSString*)message {
    /*
	UIAlertView* alert= [[UIAlertView alloc] initWithTitle:title message:message 
                                                  delegate:NULL cancelButtonTitle:@"OK" otherButtonTitles:NULL];
	//[alert show];
     */
}

#pragma mark -
#pragma mark Score Handlers

- (void)checkAchievements {
	NSString* identifier= NULL;
	double percentComplete= 0;
	int64_t score = self.currentScore;
	
	if(score >= 5000) {
		identifier= kAchievementGotFiveThousandPoints;
		percentComplete= 100.0;
	} else if(score >= 4500) {
		identifier= kAchievementGotFiveThousandPoints;
		percentComplete= 50.0;
	} else if(score >= 4000) {
		identifier= kAchievementGotFourThousandPoints;
		percentComplete= 100.0;
	} else if(score >= 3500) {
		identifier= kAchievementGotFourThousandPoints;
		percentComplete= 50.0;
	} else if(score >= 3000) {
		identifier= kAchievementGotThreeThousandPoints;
		percentComplete= 100.0;
	} else if(score >= 2500) {
		identifier= kAchievementGotThreeThousandPoints;
		percentComplete= 50.0;
	} else if(score >= 2000) {
		identifier= kAchievementGotTwoThousandPoints;
		percentComplete= 100.0;
	} else if(score >= 1500) {
		identifier= kAchievementGotTwoThousandPoints;
		percentComplete= 50.0;
	} else if(score >= 1000) {
		identifier= kAchievementGotOneThousandPoints;
		percentComplete= 100.0;
	} else if(score >= 750) {
		identifier= kAchievementGotSevenFiftyPoints;
		percentComplete= 100.0;
	} else if(score >= 500) {
		identifier= kAchievementGotFiveHundredPoints;
		percentComplete= 100.0;
	} else if(score >= 375) {
		identifier= kAchievementGotFiveHundredPoints;
		percentComplete= 75.0;
	} else if(score >= 250) {
		identifier= kAchievementGotTwoFiftyPoints;
		percentComplete= 100.0;
	} else if(score >= 125) {
		identifier= kAchievementGotTwoFiftyPoints;
		percentComplete= 50.0;
	} else if(score >= 100) {
		identifier= kAchievementGotOneHundredPoints;
		percentComplete= 100.0;
	} else if(score >= 50) {
		identifier= kAchievementGotOneHundredPoints;
		percentComplete= 50.0;
	}
	
	if(identifier!= NULL) {
		if([self isGameCenterEnabled]) {
			[[self gameCenterManager] submitAchievement:identifier percentComplete:percentComplete];
		}
	}
}

#pragma mark -
#pragma mark Game Center Action Methods

- (IBAction)submitHighScore:(id)sender {
	if(self.currentScore > [[self personalTodayBestScoreString] intValue]) {
		if([self isGameCenterEnabled]) {
			[[self gameCenterManager] reportScore:self.currentScore forCategory:self.currentLeaderBoard];
		}
	}
}

- (void)addWin {
	self.currentScore= self.currentScore + 100;
	[self updateCurrentScore];
	[self submitHighScore:self];
}

- (void)addLose {
	[self updateCurrentScore];
	[self submitHighScore:self];
}

- (void)updateCurrentScore {
	[self checkAchievements];
}

- (NSString*)currentLeaderboardHumanName {
	return NSLocalizedString(currentLeaderBoard, @"Mapping the Leaderboard IDS");
}

#pragma mark -
#pragma mark GameCenterDelegateProtocol Methods

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if([self isGameCenterEnabled]) {
		[[self gameCenterManager] authenticateLocalUser];
	}
}

- (void)processGameCenterAuth:(NSError*)error {
	if(error == NULL) {
		if([self isGameCenterEnabled]) {
			[[self gameCenterManager] reloadHighScoresForCategory:self.currentLeaderBoard];
			[[self gameCenterManager] reloadTodayHighScoresForCategory:self.currentLeaderBoard];
		}
	} else {
		NSLog(@"Proceeding without Game Center.");
		[self setGameCenterEnabled:NO];
		/*
		UIAlertView* alert= [[[UIAlertView alloc] initWithTitle:@"Game Center Account Required" 
														message:[NSString stringWithFormat:@"Reason:%@", [error localizedDescription]]
													   delegate:self cancelButtonTitle:@"Try Again..." otherButtonTitles:NULL] autorelease];
		[alert show];
		 */
	}
}

- (void)mappedPlayerIDToPlayer:(GKPlayer*)player error:(NSError*)error {
	if([self isGameCenterEnabled]) {
		if((error == NULL)&& (player != NULL)) {
			self.leaderboardHighScoreDescription= [NSString stringWithFormat:@"%@ got:", player.alias];
			
			if(self.cachedHighestScore != NULL) {
				self.leaderboardHighScoreString= self.cachedHighestScore;
			} else {
				self.leaderboardHighScoreString= @"-";
			}
		} else {
			self.leaderboardHighScoreDescription= @"GameCenter Scores Unavailable";
			self.leaderboardHighScoreDescription=  @"-";
		}
	}
}

- (void)reloadTodayScoresComplete:(GKLeaderboard*)leaderBoard error:(NSError*)error {
	if([self isGameCenterEnabled]) {
		if(error == NULL) {
			int64_t personalBest= leaderBoard.localPlayerScore.value;
			self.personalTodayBestScoreString= [NSString stringWithFormat:@"%lld", personalBest];
		} else {
			self.personalTodayBestScoreString=  @"-";
			[self showAlertWithTitle:@"Score Reload Failed!"
							 message:[NSString stringWithFormat:@"Reason:%@", [error localizedDescription]]];
		}
	}
}

- (void)reloadScoresComplete:(GKLeaderboard*)leaderBoard error:(NSError*)error {
	if([self isGameCenterEnabled]) {
		if(error == NULL) {
			int64_t personalBest= leaderBoard.localPlayerScore.value;
			self.personalBestScoreDescription= @"Your Best:";
			self.personalBestScoreString= [NSString stringWithFormat:@"%lld", personalBest];
			if([leaderBoard.scores count] >0) {
				self.leaderboardHighScoreDescription=  @"-";
				self.leaderboardHighScoreString=  @"";
				GKScore* allTime= [leaderBoard.scores objectAtIndex:0];
				self.cachedHighestScore= allTime.formattedValue;
				[[self gameCenterManager] mapPlayerIDtoPlayer:allTime.playerID];
			}
		} else {
			self.personalBestScoreDescription= @"GameCenter Scores Unavailable";
			self.personalBestScoreString=  @"-";
			self.leaderboardHighScoreDescription= @"GameCenter Scores Unavailable";
			self.leaderboardHighScoreDescription=  @"-";
			[self showAlertWithTitle:@"Score Reload Failed!"
							 message:[NSString stringWithFormat:@"Reason:%@", [error localizedDescription]]];
		}
	}
}

- (void)scoreReported:(NSError*)error {
	if([self isGameCenterEnabled]) {
		if(error == NULL) {
			[[self gameCenterManager] reloadHighScoresForCategory:self.currentLeaderBoard];
			[[self gameCenterManager] reloadTodayHighScoresForCategory:self.currentLeaderBoard];
			//NSLog(@"High Score Reported !");
			//[self showAlertWithTitle:@"High Score Reported!"
			//				 message:[NSString stringWithFormat:@"", [error localizedDescription]]];
		} else {
			[self showAlertWithTitle:@"Score Report Failed!"
							 message:[NSString stringWithFormat:@"Reason:%@", [error localizedDescription]]];
		}
	}
}

- (void)achievementSubmitted:(GKAchievement*)ach error:(NSError*)error {
	if([self isGameCenterEnabled]) {
		if((error == NULL) && (ach != NULL)) {
			if(ach.percentComplete == 100.0) {
				//NSLog(@"Achievement Earned !");
				//[self showAlertWithTitle: @"Achievement Earned!"
				//				 message: [NSString stringWithFormat: @"Great job!  You earned an achievement: \"%@\"", NSLocalizedString(ach.identifier, NULL)]];
			}
			else {
				if(ach.percentComplete > 0) {
					//NSLog(@"Achievement Progress !");
					//[self showAlertWithTitle: @"Achievement Progress!"
					//				 message: [NSString stringWithFormat: @"Great job!  You're %.0f\%% of the way to: \"%@\"",ach.percentComplete, NSLocalizedString(ach.identifier, NULL)]];
				}
			}
		} else {
			[self showAlertWithTitle: @"Achievement Submission Failed!"
							 message: [NSString stringWithFormat: @"Reason: %@", [error localizedDescription]]];
		}
	}
}

- (void)achievementResetResult:(NSError*)error {
	self.currentScore= 0;
	[scoreLabel setText:[NSString stringWithFormat:@"%lld", [self currentScore]]];

	if(error != NULL) {
		[self showAlertWithTitle: @"Achievement Reset Failed!"
						 message: [NSString stringWithFormat: @"Reason: %@", [error localizedDescription]]];
	}
}

#pragma mark -
#pragma mark SearchDetailViewController delegate methods

- (void)done {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark Memory methods

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	[self setAdView:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
