//
//  DetailViewController.m
//  MOVIEFY
//
//  Created by Maximilian Kreutzer on 12.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"
#define myQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define imdbURL [NSURL URLWithString:@"http://www.imdbapi.com/?i=&t=the+social+network"]
@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation DetailViewController

@synthesize detailItem = _detailItem;
@synthesize detailDescriptionLabel = _detailDescriptionLabel;
@synthesize masterPopoverController = _masterPopoverController;
#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
	if (_detailItem != newDetailItem) {
    	_detailItem = newDetailItem;
        
    	// Update the view.
    	[self configureView];
	}
    
	if (self.masterPopoverController != nil) {
    	[self.masterPopoverController dismissPopoverAnimated:YES];
	}   	 
}

- (void)configureView
{
	// Update the user interface for the detail item.
    if (self.detailItem) {
        NSString *filmDaten = [self.detailItem description];
        NSArray *components = [ filmDaten componentsSeparatedByString:@"(("];
        
        //daten von film laden und in die entsprechneneden labels schreiben
        //componente 0 = titel, comp 1 = datum, comp 2,3,4 = name1,2,3, comp5 = rating 
        
        self.detailDescriptionLabel.text = [components objectAtIndex:0];
        //naviTItel.title = self.detailDescriptionLabel.text;
        naviTItel.title = [components objectAtIndex:0];
        datumLabel.text =[components objectAtIndex:1];
        if ([[components objectAtIndex:2] isEqualToString:@"name.."]) {
                name1Label.text =@"Allein";
        }
        else {
            name1Label.text =[components objectAtIndex:2];
        }
        if ([[components objectAtIndex:3] isEqualToString:@"name.."]) {
            nameLabelVorne.hidden = true;
            name2Label.text =@"";
        }
        else {
            nameLabelVorne.hidden = false;
            name2Label.text =[components objectAtIndex:3];
        }
        if ([[components objectAtIndex:4] isEqualToString:@"name.."]) {
            nameLabelVorne2.hidden = true;
            name3Label.text =@"";
        }
        else {
            nameLabelVorne2.hidden = false;
            name3Label.text =[components objectAtIndex:4];
        }
        
      
        ratingLabel.text =[components objectAtIndex:5];
        NSLog(@"rating %@",[components objectAtIndex:5]);
        
       // [self loadImdBData];
        
    }
}

- (void)viewDidLoad
{
	[super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
	
    [self configureView];
        [self loadImdBData];
}

- (void)viewDidUnload
{
    imageOut = nil;
    naviTItel = nil;
    datumLabel = nil;
    nameLabelVorne = nil;
    nameLabelVorne2 = nil;
	[super viewDidUnload];
	// Release any retained subviews of the main view.
	self.detailDescriptionLabel = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
    	return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
	} else {
    	return YES;
	}
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
	barButtonItem.title = NSLocalizedString(@"Master", @"Master");
	[self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
	self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
	// Called when the view is shown again in the split view, invalidating the button and popover controller.
	[self.navigationItem setLeftBarButtonItem:nil animated:YES];
	self.masterPopoverController = nil;
}
- (void)fetchedData:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          options:kNilOptions 
                          error:&error];
    NSString* movieYear = [json objectForKey:@"Year"];
    
    id imagePath = [json objectForKey:@"Poster"];
    NSURL *myUrl = [NSURL URLWithString:imagePath];
    NSData *myData = [NSData dataWithContentsOfURL:myUrl];
    UIImage *myImage = [[UIImage alloc] initWithData:myData];
    
    
    NSLog(@"Year: %@", movieYear);
    // NSLog(@"Director: %@", director);
    
    //yearOut.text = movieYear;
    //nameOut.text = director;
    if (movieYear != NULL){
        imageOut.image = myImage;
    }
    
}
- (void) loadImdBData {
    //NSString *suche = search.text;
    //NSString *feldname = [self.data objectAtIndex:indexPath.row];
    NSArray *components = [ _detailDescriptionLabel.text componentsSeparatedByString:@"(("];
    //cell.textLabel.text = components[indexPath.row];

    //NSString *filmName = _detailDescriptionLabel.text;
    NSString *filmName = [components objectAtIndex:0];
    //filmName =[NSString stringWithString:@"Star Wars"];
    NSString *nameUrl = @"http://www.imdbapi.com/?i=&t=";
    NSString* nsFilmname = filmName;
    
    nsFilmname = [nsFilmname stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    nsFilmname = [nameUrl stringByAppendingString:nsFilmname];
    NSURL *dataFilmname = [NSURL URLWithString:nsFilmname ];
    NSLog(@"%@", nsFilmname);
    
    dispatch_async(myQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL:
                        dataFilmname];
        [self performSelectorOnMainThread:@selector(fetchedData:)
                               withObject:data waitUntilDone:YES];
    });
    
}
@end
