//
//  DBRRSSItemTableViewCell.m
//  DropBoxRss
//
//  Created by Sandeep Lakshmi Kandula on 14/07/14.
//  Copyright (c) 2014 Sandeep Lakshmi Kandula. All rights reserved.
//

#import "DBRRSSItemTableViewCell.h"
#import "DBRConstants.h"

@implementation DBRRSSItemTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        
        //Create title label
        self.itemTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.frame.size.width-20 , 10)];
        self.itemTitleLabel.textColor = [UIColor blueColor];
        self.itemTitleLabel.font = [UIFont systemFontOfSize:15.0];
        self.itemTitleLabel.numberOfLines = 0;
        self.itemTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.itemTitleLabel.tag = 10;
        
        //Create description label
        self.itemDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 210, 10)];
        self.itemDescriptionLabel.textColor = [UIColor blackColor];
        self.itemDescriptionLabel.font = [UIFont systemFontOfSize:13.0];
        self.itemDescriptionLabel.numberOfLines = 0;
        self.itemDescriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.itemDescriptionLabel.tag = 20;
        
        //Create Image view
        self.itemImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 30, 80, 60)];
        self.itemImageView.backgroundColor = [UIColor clearColor];
        self.itemImageView.tag = 30;
        
        //add all the items as subviews
        [self addSubview:self.itemTitleLabel];
        [self addSubview:self.itemDescriptionLabel];
        [self addSubview:self.itemImageView];
        
    }
    
    return self;
    
}

- (void)layoutSubviews {
    
    UILabel *titleLabel = (UILabel*)[self viewWithTag:10];
    
    // Calculate Title label size
    CGSize titleLabelSize = [titleLabel.text sizeWithFont:[UIFont boldSystemFontOfSize:15.0]
                                             constrainedToSize:CGSizeMake(CELL_TITLE_LABEL_MAX_WIDTH, MAX_CELL_HEIGHT)
                                                 lineBreakMode:NSLineBreakByWordWrapping];
    
    // Update title label frame
    titleLabel.frame = CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y, titleLabel.frame.size.width, titleLabelSize.height);
    
    
    UILabel *descLabel = (UILabel *)[self viewWithTag:20];
    // Calculate Description label size
    CGSize calculatedDescriptionLabelSize = [descLabel.text sizeWithFont:[UIFont systemFontOfSize:13.0]
                                                          constrainedToSize:CGSizeMake(CELL_DESCRIPTION_LABEL_MAX_WIDTH, MAX_CELL_HEIGHT)
                                                              lineBreakMode:NSLineBreakByWordWrapping];
    
    int descYOrdinate = titleLabel.frame.origin.y + titleLabelSize.height + 10.0;
    
    // Update Description label frame
    descLabel.frame = CGRectMake(descLabel.frame.origin.x, descYOrdinate, descLabel.frame.size.width, calculatedDescriptionLabelSize.height);
    

    UIImageView *imageView = (UIImageView *)[self viewWithTag:30];
    imageView.frame = CGRectMake(descLabel.frame.size.width+10.0, descYOrdinate, imageView.frame.size.width, imageView.frame.size.height);
    
    
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
