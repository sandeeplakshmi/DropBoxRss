//
//  DBRRssItems.m
//  DropBoxRss
//
//  Created by Sandeep Lakshmi Kandula on 14/07/14.
//  Copyright (c) 2014 Sandeep Lakshmi Kandula. All rights reserved.
//

#import "DBRRssItems.h"

@implementation DBRRssItems

- (void)dealloc {
    
    [_itemTitle release];
    [_itemDescription release];
    [_itemImageURL release];
    [_itemImage release];
    
    [super dealloc];
}

@end
