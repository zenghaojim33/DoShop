//
//  MessageTableViewCell.h
//  Dome
//
//  Created by BTW on 14/12/23.
//  Copyright (c) 2014年 jenk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSMessage_ResultModel.h"
@interface MessageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *messageTitle;
@property (weak, nonatomic) IBOutlet UILabel *messageDate;



-(void)updateCellWithModel:(DSMessage_ResultModel*)model;
@end
