//
//  WeatherViewController.m
//  RPIMobile
//
//  Created by Stephen Silber on 6/21/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import "WeatherViewController.h"
#import "PrettyKit.h"
#import "UIImageView+WebCache.h"

#define start_color [UIColor colorWithHex:0xEEEEEE]
#define end_color [UIColor colorWithHex:0xDEDEDE]

/*
 To-do for RPI Weather page:
    -Add better design elements, especially images for corresponding weather conditions
    -Downsize images so that they aren't the main focus of the page
    -Clickable tableview cells with details such as humidity, wind speed, etc (expandable?)
    -Indicators on when data was last loaded?
 */

/* Settings for RPI Weather page:
    -Custom zip-code?
    -Cache period
    -Badge support for current temp on launch screen
 */

@implementation WeatherCondition
@synthesize dayOfWeek, tempC, tempF, low, high, iconURL, condition, wind, humidity;
@end

/*Solution found on http://atastypixel.com/blog/easy-rounded-corners-on-uitableviewcell-image-view/ */
@interface UIImage (TPAdditions)
- (UIImage*)imageScaledToSize:(CGSize)size;
@end

@implementation UIImage (TPAdditions)
- (UIImage*)imageScaledToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end

@implementation WeatherViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) updateTable {
    NSLog(@"weatherArr: %@", weatherArr);
    [self.tableView reloadData];
}


#pragma mark -
#pragma mark NSXMLParser

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
    
    NSLog(@"Element: %@", elementName);
    
    if([elementName isEqualToString:@"city"]) {
        if (!weatherDic)
            weatherDic = [[NSMutableDictionary alloc] init];
            weatherArr = [[NSMutableArray alloc] init];
        return;
    }
    
    if([elementName isEqualToString:@"forecast_date"]) {
        [weatherDic setObject:[attributeDict objectForKey:@"data"]  forKey:@"forecast_date"];
        return;
    }
    
    if([elementName isEqualToString:@"current_date_time"]) {
        [weatherDic setObject:[attributeDict objectForKey:@"data"] forKey:@"current_date_time"];
        return;
    }
    
    if([elementName isEqualToString:@"current_conditions"]) {
        if(condition)
            [condition release];
        condition = [[WeatherCondition alloc] init];
        return;
    }
    
    if([elementName isEqualToString:@"forecast_conditions"]) {
        if(condition)
            [condition release];
        condition = [[WeatherCondition alloc] init];
        return;
    }
    
    //For current day conditions
    if([elementName isEqualToString:@"wind"]) {
        condition.wind = [attributeDict objectForKey:@"data"];
        return;
    }
    if([elementName isEqualToString:@"humidity"]) {
        condition.humidity = [attributeDict objectForKey:@"data"];
        return;
    }
    if([elementName isEqualToString:@"temp_f"]) {
        condition.tempF = [attributeDict objectForKey:@"data"];
        return;
    }
    //For other day conditions
    if([elementName isEqualToString:@"day_of_week"]) {
        condition.dayOfWeek = [attributeDict objectForKey:@"data"];
        return;
    }
    if([elementName isEqualToString:@"low"]) {
        condition.low = [attributeDict objectForKey:@"data"];
        return;
    }
    if([elementName isEqualToString:@"high"]) {
        condition.high = [attributeDict objectForKey:@"data"];    
        return;
    }
    if([elementName isEqualToString:@"icon"]) {
        condition.iconURL = [attributeDict objectForKey:@"data"];
        return;
    }
    if([elementName isEqualToString:@"condition"]) {
        condition.condition = [attributeDict objectForKey:@"data"];
        return;
    }


}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if([elementName isEqualToString:@"current_conditions"]) {
        [weatherDic setObject:condition forKey:@"current_conditions"];
        [weatherArr addObject:condition];
        [condition release];
        return;
    }
    if([elementName isEqualToString:@"forecast_conditions"]) {
        [weatherDic setObject:condition forKey:condition.dayOfWeek];
        [weatherArr addObject:condition];
        [condition release];
        return;
    }
    if([elementName isEqualToString:@"weather"]) {
        NSLog(@"Parsing Complete");
        [self updateTable];
    }
}


-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (!currentStringValue) {
        // currentStringValue is an NSMutableString instance variable
        currentStringValue = [[NSMutableString alloc] initWithCapacity:50];
    }
    [currentStringValue appendString:string];
    
}

-(void) parseXMLData:(NSData *) data {
    if(weatherParser)
        [weatherParser release];
    
    BOOL success;
    weatherParser = [[NSXMLParser alloc] initWithData:data];
    [weatherParser setDelegate:self];
    [weatherParser setShouldResolveExternalEntities:YES];

    //Send data from ASIHTTPRequest to NSXMLParser for parsing
    success = [weatherParser parse];
    
}

#pragma mark -
#pragma mark ASIHTTPRequest
- (void)requestFinished:(ASIHTTPRequest *)request {
    NSLog(@"Weather data received, being sent to parser!");
    [self parseXMLData:[request responseData]];
}

-(void) requestFailed:(ASIHTTPRequest *) request {
    NSLog(@"Error: %@", [request error]);
}

- (void) setUpShadows {
    [PrettyShadowPlainTableview setUpTableView:self.tableView];
}

-(void) downloadData {
    weatherRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:@"http://www.google.com/ig/api?weather=12180"] usingCache:[ASIHTTPRequest defaultCache]];
    weatherRequest.delegate = self;
    weatherRequest.secondsToCache = 60*60*2; //Cache for 2 hours
    [weatherRequest startAsynchronous];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"RPI Weather";
    
    self.tableView.scrollEnabled = NO;
    weatherArr = [[NSMutableArray alloc] init];
    
    [self downloadData];
    
    self.tableView.rowHeight = 75;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];

    [self setUpShadows];
    
    // Refresh button for feed
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh 
																							target:self 
																							action:@selector(downloadData)] autorelease];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    [ASIHTTPRequest cancelPreviousPerformRequestsWithTarget:self];
}
-(void) dealloc {
    [super dealloc];
    [weatherArr release];
    [currentStringValue release];
    [weatherRequest release];
    [weatherParser release];
    [weatherDic release];
    [condition release];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(NSString *)getWeekName:(NSString *)abbr {
    if([abbr isEqualToString:@"Sat"])
        return @"Saturday";
    else if([abbr isEqualToString:@"Sun"])
        return @"Sunday";
    else if([abbr isEqualToString:@"Mon"])
        return @"Monday";
    else if([abbr isEqualToString:@"Tue"])
        return @"Tuesday";
    else if([abbr isEqualToString:@"Wed"])
        return @"Wednesday";
    else if([abbr isEqualToString:@"Thu"])
        return @"Thursday";
    else if([abbr isEqualToString:@"Fri"])
        return @"Friday";
    else 
        return @"Uknown day";
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [weatherArr count];

}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    return tableView.frame.size.height/5;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    PrettyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[PrettyTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        cell.tableViewBackgroundColor = tableView.backgroundColor;        
        cell.gradientStartColor = start_color;
        cell.gradientEndColor = end_color;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];

    if([weatherArr count] > 0) {
        WeatherCondition *cellCondition = [weatherArr objectAtIndex:indexPath.row];   

        NSString *imageName = [[cellCondition.iconURL componentsSeparatedByString:@"/ig/images/weather/"] lastObject];
        NSString *fileName = [[imageName componentsSeparatedByString:@".gif"] objectAtIndex:0];
            
        //Uses category defined above to resize UITableViewCell imageview image elegantly
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", fileName]];
        if (image) {
            cell.imageView.image = [image imageScaledToSize:CGSizeMake(45, 45)];
        }
        
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"Current Conditions";
                cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
                cell.detailTextLabel.numberOfLines = 2;
                cell.detailTextLabel.text = [NSString stringWithFormat:@"Temp: %@º\nCondition: %@",cellCondition.tempF,cellCondition.condition];
                break;
            default:
                cell.textLabel.text = [self getWeekName:cellCondition.dayOfWeek];
                cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
                cell.detailTextLabel.numberOfLines = 3;
                cell.detailTextLabel.text = [NSString stringWithFormat:@"High: %@º\n Low: %@º \nCondition: %@",cellCondition.high, cellCondition.low,cellCondition.condition];
                break; 
        }
    }
    [cell prepareForTableView:tableView indexPath:indexPath];


    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end
