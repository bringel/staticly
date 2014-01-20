//
//  SLEntryCell.m
//  Staticly
//
//  Created by Bradley Ringel on 1/3/14.
//  Copyright (c) 2014 Bradley Ringel. All rights reserved.
//

#import "SLEntryCell.h"

@implementation SLEntryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        switch(self.entryCellType){
            case SLEntryCellTypeString:
                break;
            case SLEntryCellTypeNumber:
                self.textField.keyboardType = UIKeyboardTypeNumberPad;
                break;
            case SLEntryCellTypeDate:
                //popover
                break;
            case SLEntryCellTypeToken:
                break;
            default:
                break;
        }
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
