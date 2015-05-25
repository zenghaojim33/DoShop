//
//  MessageTableViewCell.m
//  Dome
//
//  Created by BTW on 14/12/23.
//  Copyright (c) 2014年 jenk. All rights reserved.
//

#import "MessageTableViewCell.h"

@implementation MessageTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)updateCellWithModel:(DSMessage_ResultModel *)model
{
    
    self.messageTitle.text = model.title;
    self.messageDate.text = model.time;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
