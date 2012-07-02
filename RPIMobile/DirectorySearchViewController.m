//
//  MasterViewController.m
//  RPI Directory
//
//  Created by Brendon Justin on 4/13/12.
//  Copyright (c) 2012 Brendon Justin. All rights reserved.
//

#import "DirectorySearchViewController.h"

#import "DirectoryDetailViewController.h"
#import "ASIDownloadCache.h"
#import "Person.h"

const NSString *SEARCH_URL = @"http://rpidirectory.appspot.com/api?q=";     //  Base search URL
//const NSTimeInterval SEARCH_INTERVAL = 1.0f;                                //  3 seconds

@interface DirectorySearchViewController () {
    NSMutableArray      *m_people;
    NSTimer             *m_searchTimer;
    NSString            *m_searchString;
    NSString            *m_lastString;
    UITableView         *m_currentTableView;
    
//    dispatch_queue_t    m_queue;
    
//    Boolean             m_textChanged;
}

@end

@implementation DirectorySearchViewController

@synthesize detailViewController = _detailViewController;
@synthesize PersonSearchBar, resultsTableView;


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"RPI Directory";

    self.PersonSearchBar.delegate = self;
    self.PersonSearchBar.showsCancelButton = YES;
    self.PersonSearchBar.tintColor = [UIColor darkGrayColor];
    self.PersonSearchBar.autocorrectionType = UITextAutocorrectionTypeNo;
 
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
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

-(void) requestFinished:(ASIHTTPRequest *)request {
    
    NSLog(@"Results from request: %@", [request responseString]);

        NSData *resultData = [request responseData];
        id results = [NSJSONSerialization JSONObjectWithData:resultData
                                                     options:NSJSONReadingMutableLeaves
                                                       error:nil];
        
        if (results && [results isKindOfClass:[NSDictionary class]]) {
            NSMutableArray *people = [NSMutableArray array];
            if([[results objectForKey:@"data"] count] > 0) { 
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
            } else {
                //No people found
                NSLog(@"No people found!");
//                m_people = [NSMutableArray arrayWithCapacity:0];
//                [self.resultsTableView reloadData];
            }
        }
}
-(void) requestFailed:(ASIHTTPRequest *)request {

    NSLog(@"Error: %@", [request error]);
}
//Need to implement separate thread searching to keep UI from locking user out
-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *query = [PersonSearchBar.text stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSString *searchUrl = [SEARCH_URL stringByAppendingString:query];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:searchUrl]];
    [request setDelegate:self];
    [request startAsynchronous];
    
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
    
    DirectoryDetailViewController *personView = [[DirectoryDetailViewController alloc] init];
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
