//
//  HistoryTableCell.m
//  MOVIEFY
//
//  Created by Felix Tripp on 18.07.12.
//  Copyright (c) 2012 User Interface Design GmbH. All rights reserved.
//

#import "HistoryTableCell.h"

@implementation HistoryTableCell

@synthesize titleLabel = _titleLabel;
@synthesize ratingLabel = _ratingLabel;
@synthesize seenOnLabel = _seenOnLabel;
@synthesize seenWithLabel =_seenWithLabel;
@synthesize thumbnailImageView = _thumbnailImageView;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
