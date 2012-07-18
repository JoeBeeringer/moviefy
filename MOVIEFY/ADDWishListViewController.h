//
//  ADDWishListViewController.h
//  MOVIEFY
//
//  Created by Maximilian Kreutzer on 18.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADDWishListViewController : UIViewController <UITextFieldDelegate>{
    
    IBOutlet UILabel *titleOut;
    
    IBOutlet UIImageView *imageOut;
    IBOutlet UITextField *search;
   
    UITextField *textField;
   

    
} 
@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *personLabel;
@property (weak, nonatomic) IBOutlet UILabel *person2Label;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *person3Label;
- (IBAction)closeView:(id)sender;
- (IBAction)saveSeenFilm:(id)sender;
//- (IBAction)tapBackground:(id)sender;
- (IBAction)push:(id)sender;

@end
