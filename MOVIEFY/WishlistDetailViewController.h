//
//  WishlistDetailViewController.h
//  MOVIEFY
//
//  Created by Maximilian Kreutzer on 18.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WishlistDetailViewController : UIViewController <UISplitViewControllerDelegate>{
    
    IBOutlet UINavigationItem *naviTItel;
    IBOutlet UIImageView *imageOut;
    IBOutlet UILabel *datumLabel;
    IBOutlet UILabel *name1Label;
    IBOutlet UILabel *name2Label;
    IBOutlet UILabel *name3Label;
    IBOutlet UILabel *ratingLabel;
    IBOutlet UILabel *nameLabelVorne;
    IBOutlet UILabel *nameLabelVorne2;
}
@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end
