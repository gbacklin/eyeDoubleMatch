//
//  NSArray-Shuffle.m
//  eyeHamExam
//
//  Created by Gene Backlin on 7/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NSArray-Shuffle.h"


@implementation NSArray(Shuffle)

-(NSArray *)shuffledArray {
	NSMutableArray *array = [NSMutableArray arrayWithCapacity:[self count]];
	NSMutableArray *copy = [self mutableCopy];
	
	while ([copy count] > 0) {
		int index = arc4random()% [copy count];
		id objectToMove = [copy objectAtIndex:index];
		[array addObject:objectToMove];
		[copy removeObjectAtIndex:index];
	}
	
	return array;
}

@end