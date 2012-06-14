//
//  MasterViewController.m
//  RPI Directory
//
//  Created by Brendon Justin on 4/13/12.
//  Copyright (c) 2012 Brendon Justin. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"

#import "Person.h"

const NSString *SEARCH_URL = @"http://rpidirectory.appspot.com/api?q=";     //  Base search URL
//const NSTimeInterval SEARCH_INTERVAL = 1.0f;                                //  3 seconds

@interface MasterViewController () {
    NSMutableArray      *m_people;
    NSTimer             *m_searchTimer;
    NSString            *m_searchString;
    NSString            *m_lastString;
    UITableView         *m_currentTableView;
    
//    dispatch_queue_t    m_queue;
    
//    Boolean             m_textChanged;
}

@end

@implementation MasterViewController

@synthesize detailViewController = _detailViewController;
@synthesize PersonSearchBar, resultsTableView;


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"RPI Directory";

//    self.PersonSearchBar = [[UISearchBar alloc] init];
//    self.PersonSearchBar.delegate = self;
    self.PersonSearchBar.showsCancelButton = YES;
//    [self.PersonSearchBar sizeToFit];
    self.PersonSearchBar.tintColor = [UIColor lightGrayColor];
    self.PersonSearchBar.autocorrectionType = UITextAutocorrectionTypeNo;

    
//    self.resultsTableView.tableHeaderView = PersonSearchBar;

    
    //  Update the array of people on the main thread, when a new array is available.
    //  Also make both table views reflect the new data.
 
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    } else {
        return YES;
    }
}
-(void) updateTable:(NSMutableArray *)p {
    m_people = [[NSMutableArray alloc] initWithArray:p];
    [self.searchDisplayController.searchResultsTableView reloadData];
    [self.resultsTableView reloadData];
}

#pragma mark - Search Delegate

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.PersonSearchBar resignFirstResponder];
}
-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {

    NSError *err = nil;
    NSString *query = [PersonSearchBar.text stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSString *searchUrl = [SEARCH_URL stringByAppendingString:query];
    NSString *resultString = [NSString stringWithContentsOfURL:[NSURL URLWithString:searchUrl]
                                                      encoding:NSUTF8StringEncoding
                                                         error:&err];
    
    if (err != nil) {
        NSLog(@"Error retrieving search results for string: %@", PersonSearchBar.text);
    } else {
        NSData *resultData = [resultString dataUsingEncoding:NSUTF8StringEncoding];
        id results = [NSJSONSerialization JSONObjectWithData:resultData
                                                     options:NSJSONReadingMutableLeaves
                                                       error:&err];
        
        if (results && [results isKindOfClass:[NSDictionary class]]) {
            NSMutableArray *people = [NSMutableArray array];
            
            for (NSDictionary *personDict in [results objectForKey:@"data"]) {
                NSMutableDictionary *editDict;
                Person *person = [[Person alloc] init];
                person.name = [personDict objectForKey:@"name"];
                
                //  Remove the 'name' field from the details dictionary
                //  as it is redundant.
                editDict = [personDict mutableCopy];
                if ([editDict objectForKey:@"name"] != nil) {
                    [editDict removeObjectForKey:@"name"];
                }
                person.details = editDict;
                
                [people addObject:person];
            }
            [self updateTable:people];
        }
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_people.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonCell"];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle 
                                      reuseIdentifier:@"PersonCell"];
    }
    
    Person *person = [m_people objectAtIndex:indexPath.row];
    cell.textLabel.text = [person name];
    
    NSString *subtitle = [[person details] objectForKey:@"year"];
    if (subtitle == nil) {
        subtitle = [[person details] objectForKey:@"title"];
    }
    
    if (subtitle != nil) {
        cell.detailTextLabel.text = subtitle;
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DetailViewController *personView = [[DetailViewController alloc] init];
    personView.person = [m_people objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:personView animated:YES];
    /*
    m_currentTableView = tableView;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        Person *person = [m_people objectAtIndex:indexPath.row];
        self.detailViewController.person = person;
    } else if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self performSegueWithIdentifier:@"showDetail" sender:self];
    }*/
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [m_currentTableView indexPathForSelectedRow];
        Person *person = [m_people objectAtIndex:indexPath.row];
        [[segue destinationViewController] setPerson:person];
    }
}

@end
