//
//  NewsViewCellController.h
//  RPIMobile
//
//  Created by Stephen Silber on 5/20/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import "PrettyTableViewCell.h"
#import "PrettyKit.h"

@interface NewsViewCellController : UIView {
    IBOutlet UILabel *titleLabel, *summaryLabel;
}

@property (nonatomic, retain) IBOutlet UILabel *titleLabel, *summaryLabel;

//-(void) setTitle:(NSString *) t summary:(NSString *) s;
@end
