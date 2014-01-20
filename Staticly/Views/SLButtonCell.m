//
//  SLButtonCell.m
//  Staticly
//
//  Created by Bradley Ringel on 1/16/14.
//  Copyright (c) 2014 Bradley Ringel. All rights reserved.
//

#import "SLButtonCell.h"

@implementation SLButtonCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
