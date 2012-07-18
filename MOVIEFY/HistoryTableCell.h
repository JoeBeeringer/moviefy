//
//  HistoryTableCell.h
//  MOVIEFY
//
//  Created by Felix Tripp on 18.07.12.
//  Copyright (c) 2012 User Interface Design GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryTableCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *ratingLabel;
@property (nonatomic, weak) IBOutlet UILabel *seenOnLabel;
@property (nonatomic, weak) IBOutlet UILabel *seenWithLabel;
@property (nonatomic, weak) IBOutlet UIImageView *thumbnailImageView;

@end
