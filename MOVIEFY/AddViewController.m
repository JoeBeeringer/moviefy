//
//  AddViewController.m
//  MOVIEFY
//
//  Created by Maximilian Kreutzer on 05.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddViewController.h"
#import <AddressBookUI/AddressBookUI.h>
#import "HistoryViewController.h"
#define myQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define imdbURL [NSURL URLWithString:@"http://www.imdbapi.com/?i=&t=the+social+network"]
@interface AddViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@end

@implementation AddViewController
@synthesize personLabel;
@synthesize person2Label;
@synthesize slider;
@synthesize person3Label;

@synthesize detailItem = _detailItem;
@synthesize detailDescriptionLabel = _detailDescriptionLabel;
@synthesize masterPopoverController = _masterPopoverController;

int senderTag = 0;
- (void)setDetailItem:(id)newDetailItem
{
	if (_detailItem != newDetailItem) {
    	_detailItem = newDetailItem;
        
    	// Update the view.
    	//[self configureView];
	}
    
	if (self.masterPopoverController != nil) {
    	[self.masterPopoverController dismissPopoverAnimated:YES];
	}   	 
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.#
    // [self.view addSubview:datePicker];
    //string manipulation
    
    search.delegate = self;
    NSDate *today = [NSDate dateWithTimeIntervalSinceNow:0];
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    df.dateStyle = NSDateFormatterMediumStyle;
    date.text = [NSString stringWithFormat:@"%@",[df stringFromDate:today]];
   
    if (_detailItem != NULL) {
        titleOut.text = _detailItem;
        [self push:self];
    }
    }
- (void)fetchedData:(NSData *)responseData {
    //parse out the json data
    
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          
                          options:kNilOptions 
                          error:&error];
    
    NSString* movieYear = [json objectForKey:@"Year"];
   // NSString* director = [json objectForKey:@"Director"];
    NSString* myTitle = [json objectForKey:@"Title"];
    
    id imagePath = [json objectForKey:@"Poster"];
    NSURL *myUrl = [NSURL URLWithString:imagePath];
    NSData *myData = [NSData dataWithContentsOfURL:myUrl];
    UIImage *myImage = [[UIImage alloc] initWithData:myData];
    
    
    NSLog(@"Year: %@", movieYear);
   // NSLog(@"Director: %@", director);
    
    //yearOut.text = movieYear;
    //nameOut.text = director;
    if (movieYear != NULL){
        titleOut.textColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:1];
        titleOut.text = myTitle;
        imageOut.image = myImage;
    }
    
    
}
- (void)viewDidUnload
{
    imageOut = nil;
    titleOut = nil;
    search = nil;
    datePicker = nil;
    date = nil;
    personLabel = nil;
    [self setPersonLabel:nil];
    [self setPerson2Label:nil];
    [self setPerson3Label:nil];
    hiddenSave = nil;
    Rating = nil;
    slider = nil;
    [self setSlider:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (BOOL)textFieldShouldReturn:textField{
    [textField resignFirstResponder];
    [self push:textField];
    NSLog(@"textfield should reutrn");
    return YES;
}


- (IBAction)push:(id)sender {
    NSString *filmName;
    //NSString *suche = search.text;
    if (_detailItem != NULL) {
        NSLog(@"gekommen in push über addWish");
        search.text = _detailItem;
        
    }
    filmName = search.text;
    
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

- (IBAction)ratingValue:(UISlider *)sender {
    Rating.text = [NSString stringWithFormat:@"%.1f", [sender value]];
}


- (IBAction)closeView:(id)sender {
    
    // Warne vor Datenverlust bei Abbruch der Eingabe:
    UIAlertView *discard = [[UIAlertView alloc] initWithTitle:@"Discard your input?" message:nil delegate:self cancelButtonTitle:@"Jeez now!!" otherButtonTitles:@"OK", nil];
    
    [discard show];
    
}


-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        // ok abbruch
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)pickerAction:(id)sender {
   
     NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [self.view addSubview:datePicker];
    
    df.dateStyle = NSDateFormatterMediumStyle;
    if(datePicker.hidden)
    datePicker.hidden = false;
    else {
        datePicker.hidden=true;
    }
  
    date.text = [NSString stringWithFormat:@"%@",[df stringFromDate:datePicker.date]];
}
//fuegt personen hinzu
- (IBAction)addPerson:(id)sender {
    if ([sender tag] == 1){
        senderTag = 1;
    }
    else if ([sender tag] == 2){
        senderTag = 2;
    }
    else {
        senderTag = 3;
    }
    ABPeoplePickerNavigationController *peoplePicker = [[ABPeoplePickerNavigationController alloc] init];
    peoplePicker.peoplePickerDelegate  =self;
    [self presentModalViewController:peoplePicker animated:YES];
    
}
- (void)peoplePickerNavigationControllerDidCancel:
(ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissModalViewControllerAnimated:YES];
}


- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    //if (personLabel.text == @"name.."){
    if (senderTag == 1){
        [self displayPerson:person:personLabel];
    [self dismissModalViewControllerAnimated:YES];
    }
    else if (senderTag == 2){
        
        [self displayPerson:person:person2Label];
        [self dismissModalViewControllerAnimated:YES];
        
    }
    else {
        [self displayPerson:person:person3Label];
        [self dismissModalViewControllerAnimated:YES];
    }
    return NO;
}

- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier
{
    return NO;
}
- (void) displayPerson: (ABRecordRef) person : (UILabel*) label {
    NSString *prename = (__bridge_transfer NSString*)ABRecordCopyValue(person,
                                                                       kABPersonFirstNameProperty);
    
    NSString *lastname = (__bridge_transfer NSString*)ABRecordCopyValue(person,
                                                                        kABPersonLastNameProperty);
    
    
    label.text = [NSString stringWithFormat:@"%@ %@",prename,lastname];
    
}

// Speichere alle Eingaben in der lokalen Datei,
// schließe addviewcontroller
// und lade die history list.
- (IBAction)saveSeenFilm:(id)sender {
    
    // sammle mal die daten
    NSLog(@"Titel: %@", titleOut.text);
    NSLog(@"Datum: %@", date.text);
    NSLog(@"rate: %@", Rating.text);
    // personen
    // 
    
    // temporäre Liste
    NSMutableArray *tempListMultiArray;
    // lese aus der aktuellen lokalen datei
    tempListMultiArray = [NSMutableArray arrayWithContentsOfFile:[NSString stringWithFormat:@"%@/Documents/HistoryList", NSHomeDirectory()]];
    NSArray *components;
    int count = [tempListMultiArray count];
       
      
    //film wird nur dann geaddet, falls er nicht default ist 
    if ([titleOut.text isEqualToString: @"Enter movie.."]){
        UIAlertView *discard = [[UIAlertView alloc] initWithTitle:@"Enter Movie" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
            [discard show];
    }
    else
    {
       // zerteilt string so das nur noch titel in object 0 steht
        
        if ([tempListMultiArray containsObject:titleOut.text]){
            NSLog(@"in der text abfrage");
            //verhindert doppelpost
             UIAlertView *discard = [[UIAlertView alloc] initWithTitle:@"Movie is allready in Database" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
            [discard show];

        }
        else
        {
            //film wird geaddet mit allen daten
            //stelle 1 = titel, 2 datum, 3,4,5 person1,2,3, 6 = rating
            NSString *filmDaten = [NSString stringWithFormat:@"%@((%@((%@((%@((%@((%@((", titleOut.text,date.text, personLabel.text,person2Label.text,person3Label.text,Rating.text];
            [tempListMultiArray insertObject:filmDaten atIndex:0];
            
            
            // schreibe die liste in die datei
            [tempListMultiArray writeToFile:[NSString stringWithFormat:@"%@/Documents/HistoryList", NSHomeDirectory()] atomically:YES];
            
            //speicher nachricht
            UIAlertView *discard = [[UIAlertView alloc] initWithTitle:@"Movie is saved to Database" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [discard show];
            //wenn _übergebedate voll, dann wird film gelöscht aus wishlist
            if (_detailItem != NULL) {
                NSLog(@"deletewishlist if");
                [self deleteWishlistMovie];
            }
                        
            //segue ausführen
            [self performSegueWithIdentifier:@"seg" sender:self];
        }    
    }
    
    // schreibe die liste in die datei
    [tempListMultiArray writeToFile:[NSString stringWithFormat:@"%@/Documents/HistoryList", NSHomeDirectory()] atomically:YES];
}

-(void) deleteWishlistMovie{
    // temporäre Wishlist Liste
     // lese aus der aktuellen lokalen datei
    
    NSMutableArray *tempListMultiArray = [NSMutableArray arrayWithContentsOfFile:[NSString stringWithFormat:@"%@/Documents/WishList", NSHomeDirectory()]];
    
    NSString *detail = [NSString stringWithFormat:@"%@((",_detailItem];
    //[tempListMultiArray indexOfObject:_detailItem]
    if ([tempListMultiArray containsObject:detail]) {
        
        [tempListMultiArray removeObjectAtIndex:[tempListMultiArray indexOfObject:detail]];
        [tempListMultiArray writeToFile:[NSString stringWithFormat:@"%@/Documents/WishList", NSHomeDirectory()] atomically:YES];
    
    }
    
   
    
    if ([tempListMultiArray containsObject:_detailItem]) {
        NSLog(@"Object immernoch drin");}
   // [tempListMultiArray removeObjectAtIndex:0];
    
}

//datepicker verschwindet
- (IBAction)tapBackground:(id)sender {
    [textField resignFirstResponder];
    if(datePicker.hidden==false){
        datePicker.hidden = true;
        NSDateFormatter *df = [[NSDateFormatter alloc]init];
        df.dateStyle = NSDateFormatterMediumStyle;
        date.text = [NSString stringWithFormat:@"%@",[df stringFromDate:datePicker.date]];}
    //[self textFieldShouldReturn:textField];
     }

@end
