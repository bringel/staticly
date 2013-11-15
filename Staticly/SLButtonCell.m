//
//  SLButtonCell.m
//  Staticly
//
//  Created by Bradley Ringel on 11/12/13.
//  Copyright (c) 2013 Bradley Ringel. All rights reserved.
//

#import "SLButtonCell.h"

@implementation SLButtonCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self.buttonLabel setTextColor:self.tintColor];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
