//
//  MapViewControllerViewController.h
//  RPIMobile
//
//  Created by Stephen Silber on 7/10/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewControllerViewController : UIViewController <MKMapViewDelegate> {
    IBOutlet MKMapView *campusMap;
}

@end
