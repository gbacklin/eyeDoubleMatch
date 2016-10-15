//
//  PropertyList.h
//  eyeHamTesterTechnician
//
//  Created by Gene Backlin on 7/24/09.
//  Copyright 2009 Gene Backlin. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDictionary(PropertyList)

+ (NSDictionary *)dictionaryFromPropertyList:(NSString *)filename;

@end
