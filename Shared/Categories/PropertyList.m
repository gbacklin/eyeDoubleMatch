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
	NSString *errorDesc = nil; 
	NSPropertyListFormat format; 
	NSString *plistPath = [[NSBundle mainBundle] pathForResource:filename ofType:@"plist"]; 
	NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath]; 
	NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization 
										  propertyListFromData:plistXML 
										  mutabilityOption:NSPropertyListMutableContainersAndLeaves 
										  format:&format errorDescription:&errorDesc]; 
	if (!temp) { 
		NSLog(@"%@",errorDesc); 
	}
	
	return temp;
}

@end
