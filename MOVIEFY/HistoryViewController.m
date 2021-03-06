//
//  HistoryViewController.m
//  MOVIEFY
//
//  Created by Maximilian Kreutzer on 05.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HistoryViewController.h"
#import "DetailViewController.h"
#import "HistoryTableCell.h"
@interface HistoryViewController ()

@end

@implementation HistoryViewController
@synthesize segment = _segment;
@synthesize data = _data;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // lade Daten aus der lokalen datei
    [self loadData];
    
    // wenn loadData leer ist, dann wurde
    // die Anwendung zum ersten mal gestartet.
    // erzeuge also das datenarray:
    if (! self.data) {
        self.data = [[NSMutableArray alloc] init];
        [self.data addObject:@"List empty. Add a movie."];
        [self.data addObject:@"List empty. Add a movie."];
        [self.data addObject:@"List empty. Add a movie."];
        [self.data addObject:@"List empty. Add a movie."];
    }
    // [self.data sortUsingSelector:@selector(compare:)];
}
- (void) viewWillAppear:(BOOL)animated{
    //[self viewDidLoad];
    [self loadData];
    [self.tableView reloadData];
}

- (void)viewDidUnload
{
    [self setSegment:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Länge der History List
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *historyTableIdentifier = @"HistoryTableCell";
    
    // alt: UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    HistoryTableCell *cell = (HistoryTableCell *)[tableView dequeueReusableCellWithIdentifier:historyTableIdentifier];
    
    if (cell == nil) {
        // Alloziiere eine neue Zelle
        // UITableViewCellStyleDefault definiert das Aussehen der zu ladenden Zelle
        // alt: cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HistoryTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSString *feldname = [self.data objectAtIndex:indexPath.row];
    NSArray *components = [feldname componentsSeparatedByString:@"(("];
    //cell.textLabel.text = components[indexPath.row];
    //cell.textLabel.numberOfLines = 2;
    //componente 0 = titel, comp 1 = datum, comp 2,3,4 = name1,2,3, comp5 = rating  
    // alt cell.textLabel.text = [components objectAtIndex:0];
    cell.titleLabel.text = [components objectAtIndex:0];
    cell.ratingLabel.text = [components objectAtIndex:5];
    cell.seenOnLabel.text = [components objectAtIndex:1];
    
    
    NSString *seenWith = [NSString stringWithFormat:@"%@, %@, %@", [components objectAtIndex:2], [components objectAtIndex:3], [components objectAtIndex:4]];
    cell.seenWithLabel.text = seenWith;
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Hier wird die Zeile gelöscht, die nach dem "edit" als gelöscht markiert wurde
        [_data removeObjectAtIndex:indexPath.row];
        [self saveData];
        // fette animation:
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}



 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }


 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"select");
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        NSLog(@"select2");
		[self performSegueWithIdentifier:@"showDetail" sender:self];
     // NSDate *object = [_data objectAtIndex:indexPath.row];
    	//self.detailViewController.detailItem = object;
        
	}
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"seg1");
	if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSLog(@"seg2");
    	NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    	NSDate *object = [_data objectAtIndex:indexPath.row];
    	[[segue destinationViewController] setDetailItem:object];
	}
}

// nach dem drücken von "done" (wenn fertig mit "edit")
- (IBAction)doneHistoryList:(id)sender {
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editHistoryList:)];   //donePressed Methode wird aufgerufen, bei drücken von "done"
    [self.navigationItem setLeftBarButtonItem:editButton animated:YES];
    
    [self.tableView setEditing:NO animated:YES];
}

// nach dem drücken von "edit"
- (IBAction)editHistoryList:(id)sender {
    
    // done-Button, der nach drücken des "edit" buttons auftauchen soll.
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneHistoryList:)];   //donePressed Methode wird aufgerufen, bei drücken von "done"
    [self.navigationItem setLeftBarButtonItem:doneButton animated:YES];
    
    
    // bei drücken des "Edit" Buttons in der History Liste:
    [self.tableView setEditing:YES animated:YES];
    
}



// Lade Daten aus der lokalen Datei
- (void) loadData {
    self.data = [NSMutableArray arrayWithContentsOfFile:[NSString stringWithFormat:@"%@/Documents/HistoryList", NSHomeDirectory()]];
}


// Speichere Daten in die lokale Datei
- (void) saveData {
    [self.data writeToFile:[NSString stringWithFormat:@"%@/Documents/HistoryList", NSHomeDirectory()] atomically:YES];
}

- (IBAction)sortMethod:(id)sender {
    if (_segment.selectedSegmentIndex == 0) {
        [self loadData];
    }
    else {
        [self.data sortUsingSelector:@selector(compare:)];
    }
    
    [self.tableView reloadData];
}
// verändere die größe der zellen (da sie mit thumbnail etc. größer wurden)
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 108;
}
@end
