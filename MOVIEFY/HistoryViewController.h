//
//  HistoryViewController.h
//  MOVIEFY
//
//  Created by Maximilian Kreutzer on 05.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"
@interface HistoryViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *data;
- (IBAction)editHistoryList:(id)sender;
- (void) loadData;
- (void) saveData;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property (strong, nonatomic) DetailViewController *detaiViewController;
- (IBAction)sortMethod:(id)sender;

@end
