//
//  RoutineCollectionViewCell.h
//  HiplaStudent
//
//  Created by fnspl3 on 19/10/17.
//  Copyright © 2017 fnspl3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@protocol RoutineCollectionViewCellDelegate <NSObject>

@optional
- (void)dateCellTap:(id)sender;

@end

@interface RoutineCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblday;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UIView *backVW;
@property (weak, nonatomic) IBOutlet UIView *line;

@property (weak, nonatomic) id<RoutineCollectionViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *btnDate;

- (IBAction)actionBtnDate:(id)sender;

@end
