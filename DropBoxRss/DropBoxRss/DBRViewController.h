//
//  DBRViewController.h
//  DropBoxRss
//
//  Created by Sandeep Lakshmi Kandula on 14/07/14.
//  Copyright (c) 2014 Sandeep Lakshmi Kandula. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBRViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (retain, nonatomic) IBOutlet UITableView *rssTableView;

@end
