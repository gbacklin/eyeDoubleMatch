//
//  PropertyList.m
//  eyeHamTesterTechnician
//
//  Created by Gene Backlin on 7/24/09.
//  Copyright 2009 Gene Backlin. All rights reserved.
//

#import "PropertyList.h"


@implementation NSDictionary(PropertyList)

+ (NSDictionary *)dictionaryFromPropertyList:(NSString *)filename {
    NSError *error;
	NSPropertyListFormat format; 
	NSString *plistPath = [[NSBundle mainBundle] pathForResource:filename ofType:@"plist"]; 
	NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSDictionary *temp = [NSPropertyListSerialization propertyListWithData:plistXML options:NSPropertyListMutableContainersAndLeaves format:&format error:&error];
	if (!temp) {
		NSLog(@"%@", [error localizedDescription]);
	}
	
	return temp;
}

@end
