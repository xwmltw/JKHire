//
//  PersonalPostCell_Title.m
//  JKHire
//
//  Created by fire on 16/10/12.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "PersonalPostCell_Title.h"
#import "MyEnum.h"

#import "PostJobModel.h"

@interface PersonalPostCell_Title (){
    PostJobModel *_postJobModel;
    PostJobCellType _cellType;
}

- (IBAction)editingchanging:(id)sender;

@end

@implementation PersonalPostCell_Title

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(PostJobModel *)model jobCellType:(NSNumber *)cellType{
    _postJobModel = model;
    _cellType = cellType.integerValue;
    if (model) {
        switch (_cellType) {
            case PostJobCellType_title:{
                if (model.service_title && model.service_title.length > 0) {
                    self.utf.text = model.service_title;
                }
            }
                break;
            case PostJobCellType_salaryJobtitle:{
                if (model.job_title && model.job_title.length > 0) {
                    self.utf.text = model.job_title;
                }
            }
            default:
                break;
        }
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)editingchanging:(UITextField *)sender {
    if (sender.text.length > 20) {
        sender.text = [sender.text substringToIndex:20];
    }
    if (_cellType == PostJobCellType_title) {
        _postJobModel.service_title = sender.text;
    }else{
        _postJobModel.job_title = sender.text;
    }

}
@end
