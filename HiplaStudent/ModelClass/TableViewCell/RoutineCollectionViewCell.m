//
//  RoutineCollectionViewCell.m
//  HiplaStudent
//
//  Created by fnspl3 on 19/10/17.
//  Copyright © 2017 fnspl3. All rights reserved.
//

#import "RoutineCollectionViewCell.h"

@implementation RoutineCollectionViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    [self prepareForReuse];
}

- (void)prepareForReuse {
    
    self.lblday.text = nil;
    self.lblDate.text = nil;
    
    [super prepareForReuse];
}

- (IBAction)actionBtnDate:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(dateCellTap:)]) {
        
        [self.delegate dateCellTap:self];
    }
    
}



@end
