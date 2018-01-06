//
//  PostJobCell_send.m
//  jianke
//
//  Created by xiaomk on 16/4/18.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "PostJobCell_send.h"
#import "PostJobModel.h"

@interface PostJobCell_send ()
@property (nonatomic, strong) PostJobModel *model;
@property (nonatomic, assign) ViewSourceType sourceType;   /*!< 来源页面类型 */
@property (weak, nonatomic) IBOutlet UILabel *labAccept;
@property (weak, nonatomic) IBOutlet UIButton *btnDelegate;


@end

@implementation PostJobCell_send

- (void)awakeFromNib{
    [super awakeFromNib];
    [self.btnSend addTarget:self action:@selector(postJobAction:) forControlEvents:UIControlEventTouchUpInside];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *identifier = @"PostJobCell_send";
    PostJobCell_send *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        static UINib* _nib;
        if (!_nib) {
            _nib = [UINib nibWithNibName:@"PostJobCell_send" bundle:nil];
        }
        
        if (_nib) {
            cell = [[_nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
        }
        cell.backgroundColor = [UIColor whiteColor];
    }
    return cell;
}

- (void)setSourceType:(ViewSourceType)sourceType withModel:(PostJobModel *)model{
    _model = model;
    _sourceType = sourceType;
    self.btnSend.tag = sourceType;
    switch (sourceType) {
        case ViewSourceType_PostNormalJob:{
            [self.btnSend setTitle:@"确认发布" forState:UIControlStateNormal];
        }
            break;
        case ViewSourceType_PostPersonalJob:
        case ViewSourceType_PostTeamJob:{
            [self.btnSend setTitle:@"下一步" forState:UIControlStateNormal];
            self.labAccept.text = @"让平台推荐更多人选?";
            self.btnAgreement.hidden = YES;
        }
            break;
        case ViewSourceType_InvitePersonalJob:{
            [self.btnSend setTitle:@"发起邀约" forState:UIControlStateNormal];
            self.labAccept.text = @"让平台推荐更多人选?";
            self.btnAgreement.hidden = YES;
        }
            break;
        case ViewSourceType_InviteTeamJob:{
            [self.btnSend setTitle:@"发起预约" forState:UIControlStateNormal];
            self.labAccept.hidden = YES;
        }
            break;
        default:{
            [self.btnSend setTitle:@"确认发布" forState:UIControlStateNormal];
        }
            break;
    }
}

- (void)postJobAction:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(btnSendOnClickWithActionType:)]) {
        [self.delegate btnSendOnClickWithActionType:sender.tag];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
