//
//  NSDictionary+Utility.m
//  DropBoxRss
//
//  Created by Sandeep Lakshmi Kandula on 14/07/14.
//  Copyright (c) 2014 Sandeep Lakshmi Kandula. All rights reserved.
//

#import "NSDictionary+Utility.h"

@implementation NSDictionary (Utility)

- (id)objectForKeyOrNil:(id)key {
    id val = [self objectForKey:key];
    if (val ==[NSNull null])
    {
        return nil;
    }
    return val;
}

@end
