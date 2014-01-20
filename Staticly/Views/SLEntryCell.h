//
//  SLEntryCell.h
//  Staticly
//
//  Created by Bradley Ringel on 1/3/14.
//  Copyright (c) 2014 Bradley Ringel. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ENUM(NSUInteger, SLEntryCellType){
    SLEntryCellTypeString,
    SLEntryCellTypeNumber,
    SLEntryCellTypeDate,
    SLEntryCellTypeToken
};


@interface SLEntryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic) enum SLEntryCellType entryCellType;
@end
