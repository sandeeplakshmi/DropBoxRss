//
//  DBRRssItems.h
//  DropBoxRss
//
//  Created by Sandeep Lakshmi Kandula on 14/07/14.
//  Copyright (c) 2014 Sandeep Lakshmi Kandula. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBRRssItems : NSObject

@property (nonatomic, retain) NSString *itemTitle;
@property (nonatomic, retain) NSString *itemDescription;
@property (nonatomic, retain) NSString *itemImageURL;
@property (nonatomic, copy) UIImage *itemImage;


@end
