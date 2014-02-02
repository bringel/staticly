//
//  SLYAMLEntryCell.h
//  Staticly
//
//  Created by Bradley Ringel on 1/30/14.
//  Copyright (c) 2014 Bradley Ringel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JVFloatLabeledTextField/JVFloatLabeledTextField.h>

NS_ENUM(NSUInteger, SLEntryCellType){
    SLEntryCellTypeString,
    SLEntryCellTypeNumber,
    SLEntryCellTypeDate,
    SLEntryCellTypeToken
};


@interface SLYAMLEntryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *textField;
@property (nonatomic) enum SLEntryCellType entryCellType;

@end
