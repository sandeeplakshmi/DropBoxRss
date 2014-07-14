//
//  DBRViewController.m
//  DropBoxRss
//
//  Created by Sandeep Lakshmi Kandula on 14/07/14.
//  Copyright (c) 2014 Sandeep Lakshmi Kandula. All rights reserved.
//

#import "DBRViewController.h"
#import "NSDictionary+Utility.h"
#import "DBRRssItems.h"
#import "DBRRSSItemTableViewCell.h"
#import "DBRConstants.h"

@interface DBRViewController ()

@property (retain, nonatomic) NSMutableArray *rssParsedItems;
@property (nonatomic, retain) UIRefreshControl *refreshControl;
@property (nonatomic, assign) BOOL isRefreshed;

@end

@implementation DBRViewController

- (NSMutableArray *)rssParsedItems{
    
    if(!_rssParsedItems)
        _rssParsedItems = [[NSMutableArray alloc] init];
    
    return _rssParsedItems;
    
}

#pragma mark - Refresh Data Methods
- (void)refreshRssData {
    
    if(!_isRefreshed){
        
        _isRefreshed =  YES;
        [self loadRSSData];
        
    }

}

#pragma mark - Data Loading Methods
- (void)loadRSSData {
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        
        // Download JSON RSS Feed from URL
        NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://www.dropbox.com/s/g41ldl6t0afw9dv/facts.json?dl=1"]];
        
        //Somehow the input JSON data has special chars, so need to do 2 conversions
        //1. JSON data to string
        //2. JSON String back to data & the parse.
        NSString *intialJsonString = [[NSString alloc] initWithData: jsonData encoding: NSStringEncodingConversionAllowLossy];
        NSData *finalJSONData = [intialJsonString dataUsingEncoding:NSUTF8StringEncoding];
        
        NSError *error = nil;
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:finalJSONData options:NSJSONReadingAllowFragments error:&error];
        
        //IF error alert the user of it.
        if(error){
            
            UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error in fetching data" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
            
            //If error occured while pull to refresh then handle it properly
            if(_isRefreshed){
                _isRefreshed = NO;
                [self.refreshControl endRefreshing];
            }
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
            return;
            
        }
    
        NSLog(@"data->%@",dataDict);
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        //Parse & Display
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
            [self parseAndDisplayDataWithDictionary:dataDict];
            
        });
        
    });
    
}

#pragma mark - Parsing Methods
- (void)parseAndDisplayDataWithDictionary:(NSDictionary*)dict {
    
    if(_isRefreshed)
        self.rssParsedItems = nil;
    
    self.navigationItem.title = [dict objectForKeyOrNil:@"title"];
    
    NSArray *itemsArray = [dict objectForKey:@"rows"];
    
    //Iterate thru all the items & create an array list of RSS feed items.
    for (NSDictionary *itemDict in itemsArray) {
        
        DBRRssItems *item = [[DBRRssItems alloc] init];
        item.itemTitle = [itemDict objectForKeyOrNil:@"title"];
        item.itemDescription = [itemDict objectForKeyOrNil:@"description"];
        item.itemImageURL = [itemDict objectForKeyOrNil:@"imageHref"];
        
        [self.rssParsedItems addObject:item];
        [item release];
        
    }
    
    //Handle the pull to refresh after successfull data download.
    if(_isRefreshed){
        
        _isRefreshed = NO;
        [self.refreshControl endRefreshing];
        
    }
    
    [self.rssTableView reloadData];
    
}


#pragma mark - TableView Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.rssParsedItems count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIndentifier = @"feedItemCell";
    DBRRSSItemTableViewCell *cell=  (DBRRSSItemTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    
    if(cell == nil){
        
        cell = [[[DBRRSSItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier] autorelease];
    }
    
    DBRRssItems *item = [self.rssParsedItems objectAtIndex:indexPath.row];
        
    cell.itemTitleLabel.text = item.itemTitle ? item.itemTitle : @"";
    cell.itemDescriptionLabel.text = item.itemDescription ? item.itemDescription : @"";
    
    if(item.itemImage)
        cell.itemImageView.image = item.itemImage;
    
    else{
        
        // set default user image while image is being downloaded
        cell.itemImageView.image = [UIImage imageNamed:@""];
        
        // download the image asynchronously
        //This method takes a completion block & return back with downloaded data.
        [self downloadImageWithURL:[NSURL URLWithString:item.itemImageURL] completionBlock:^(BOOL succeeded, UIImage *image) {
            if (succeeded) {
                // change the image in the cell
                cell.itemImageView.image = image;
                
                // cache the image for use later (when scrolling up)
                item.itemImage = image;
            
            }else{
                
                cell.itemImageView.image = item.itemImage = [UIImage imageNamed:@"NoImage.png"];
                
            }
            
        }];
        
        
    }
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DBRRssItems *item = [self.rssParsedItems objectAtIndex:indexPath.row];
    
    CGSize titleLabelSize = [item.itemTitle sizeWithFont:[UIFont boldSystemFontOfSize:CELL_TITLE_LABEL_FONT_SIZE]
                                   constrainedToSize:CGSizeMake(CELL_TITLE_LABEL_MAX_WIDTH, MAX_CELL_HEIGHT)
                                       lineBreakMode:NSLineBreakByWordWrapping];
    
    CGSize descriptionLabelSize = [item.itemDescription sizeWithFont:[UIFont systemFontOfSize:CELL_DESCRIPTION_LABEL_FONT_SIZE]
                                                constrainedToSize:CGSizeMake(CELL_DESCRIPTION_LABEL_MAX_WIDTH, MAX_CELL_HEIGHT)
                                                    lineBreakMode:NSLineBreakByWordWrapping];
    
    CGFloat calculatedCellHeight =  titleLabelSize.height + descriptionLabelSize.height + 30;
    
    if(calculatedCellHeight < 100)
        return 100;
    else
        return calculatedCellHeight;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

#pragma mark - LazyLoading Images Method
- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   completionBlock(YES,image);
                               } else{
                                   completionBlock(NO,nil);
                               }
                           }];
    
}


#pragma mark - Life cycle methods
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Initialize Refresh control
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.rssTableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshRssData) forControlEvents:UIControlEventValueChanged];
    
    self.navigationItem.title = @"DropBox RSS";
    
    self.rssTableView.delegate = self;
    self.rssTableView.dataSource = self;
    
    //Load the RSS data from url.
    [self loadRSSData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    //Release all Items
    [self.rssParsedItems release];
    [self.refreshControl release];
    [self.rssTableView release];
    [super dealloc];
    
}

@end
