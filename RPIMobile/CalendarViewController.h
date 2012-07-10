//
//  CalendarViewController.h
//  RPIMobile
//
//  Created by Stephen Silber on 7/3/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TapkuLibrary/TapkuLibrary.h>

#import "CalendarEntry.h"

@interface CalendarViewController : TKCalendarMonthTableViewController <NSFetchedResultsControllerDelegate> {
    NSMutableArray *eventArray; 
    NSMutableDictionary *dataDictionary;
    NSMutableArray *calendarData;
    

    
    NSManagedObjectContext *managedObjectContext;
    NSFetchedResultsController *fetchedResultsController;

}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;  
@property (retain,nonatomic) NSMutableArray *eventArray, *calendarData;
@property (retain,nonatomic) NSMutableDictionary *dataDictionary;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSDate *currentDate;

- (void) fetchRecords;  

@end
