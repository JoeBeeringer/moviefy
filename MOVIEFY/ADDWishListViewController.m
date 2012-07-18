//
//  ADDWishListViewController.m
//  MOVIEFY
//
//  Created by Maximilian Kreutzer on 18.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ADDWishListViewController.h"
#define myQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define imdbURL [NSURL URLWithString:@"http://www.imdbapi.com/?i=&t=the+social+network"]
@interface ADDWishListViewController ()

@end

@implementation ADDWishListViewController

@synthesize personLabel;
@synthesize person2Label;
@synthesize slider;
@synthesize person3Label;




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
   
    personLabel = nil;
    [self setPersonLabel:nil];
    [self setPerson2Label:nil];
    [self setPerson3Label:nil];
    
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


// Speichere alle Eingaben in der lokalen Datei,
// schließe addviewcontroller
// und lade die WishList list.
- (IBAction)saveSeenFilm:(id)sender {
    
    // sammle mal die daten
    NSLog(@"Titel: %@", titleOut.text);

    // personen
    // 
    
    // temporäre Liste
    NSMutableArray *tempListMultiArray;
    
    
    // lese aus der aktuellen lokalen datei
    tempListMultiArray = [NSMutableArray arrayWithContentsOfFile:[NSString stringWithFormat:@"%@/Documents/WishList", NSHomeDirectory()]];
    
    //film wird nur dann geaddet, falls er nicht default ist 
    if ([titleOut.text isEqualToString: @"Enter movie.."]){
        UIAlertView *discard = [[UIAlertView alloc] initWithTitle:@"Enter Movie" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [discard show];
    }
    else
    {
        NSLog(@"vor text abfrage");
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
            NSString *filmDaten = [NSString stringWithFormat:@"%@((", titleOut.text];
            [tempListMultiArray insertObject:filmDaten atIndex:0];
            
            
            // schreibe die liste in die datei
            [tempListMultiArray writeToFile:[NSString stringWithFormat:@"%@/Documents/WishList", NSHomeDirectory()] atomically:YES];
            
            //speicher nachricht
            UIAlertView *discard = [[UIAlertView alloc] initWithTitle:@"Movie is saved to Database" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [discard show];
            //segue ausführen
            [self performSegueWithIdentifier:@"addWish" sender:self];
        }    
    }
    
    // schreibe die liste in die datei
    [tempListMultiArray writeToFile:[NSString stringWithFormat:@"%@/Documents/WishList", NSHomeDirectory()] atomically:YES];
}





@end
