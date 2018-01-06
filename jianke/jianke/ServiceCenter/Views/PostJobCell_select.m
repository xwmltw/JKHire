//
//  PostJobCell_select.m
//  jianke
//
//  Created by xiaomk on 16/4/18.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "PostJobCell_select.h"
#import "UIColor+Extension.h"
#import "MyEnum.h"

#import "PostJobModel.h"

@interface PostJobCell_select (){
    PostJobModel *_postJobModel;
}
@property (weak, nonatomic) IBOutlet UIView *bottomLine;

@end

@implementation PostJobCell_select

- (void)awakeFromNib{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *identifier = @"PostJobCell_select";
    PostJobCell_select *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        static UINib* _nib;
        if (!_nib) {
            _nib = [UINib nibWithNibName:@"PostJobCell_select" bundle:nil];
        }
        
        if (_nib) {
            cell = [[_nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
        }
        cell.backgroundColor = [UIColor whiteColor];
    }
    return cell;
}

- (void)setModel:(PostJobModel *)model jobCellType:(PostJobCellType)cellType{
    _postJobModel = model;
    self.bottomLine.hidden = NO;
    self.imgRightIcon.hidden = NO;
    if (model) {
        switch (cellType) {
            case PostJobCellType_jobType:{
                self.imgIcon.image = [UIImage imageNamed:@"v250_type"];
                self.labTitle.text = @"请选择岗位类型";
                self.imgRightIcon.image = [UIImage imageNamed:@"job_icon_push"];
                if (_postJobModel.service_classify_name.length) {
                    self.labTitle.text = _postJobModel.service_classify_name;
                }
                if (_postJobModel.job_classfie_name.length) {
                    self.labTitle.text = _postJobModel.job_classfie_name;
                }
            }
                break;
            case PostJobCellType_salaryJobArea:{
                self.imgIcon.image = [UIImage imageNamed:@"v250_iconfont"];
                self.labTitle.text = @"选择城市";
                self.imgRightIcon.image = [UIImage imageNamed:@"job_icon_push"];
                if (_postJobModel.city_id && _postJobModel.city_name.length > 0) {
                    self.labTitle.text = _postJobModel.city_name;
                }
            }
                break;
            default:
                break;
        }
    }
}

- (void)setModel:(PostJobModel *)model jobCellType:(NSNumber *)cellType sourceType:(ViewSourceType)sourceType{
    _postJobModel = model;
    self.bottomLine.hidden = NO;
    self.imgRightIcon.hidden = NO;
    PostJobCellType type = cellType.integerValue;
    if (model) {
        switch (type) {
            case PostJobCellType_chooseJob:{
                self.imgIcon.image = [UIImage imageNamed:@"choose_have_posted_job"];
                self.labTitle.text = @"选择已有的需求单";
                self.imgRightIcon.image = [UIImage imageNamed:@"job_icon_push"];
                self.bottomLine.hidden = YES;
            }
                break;
            case PostJobCellType_jobType:{
                self.imgIcon.image = [UIImage imageNamed:@"v250_type"];
                self.labTitle.text = @"请选择服务类型";
                self.imgRightIcon.image = [UIImage imageNamed:@"job_icon_push"];
                if (_postJobModel.service_classify_name.length) {
                    self.labTitle.text = _postJobModel.service_classify_name;
                }
                if (_postJobModel.job_classfie_name.length) {
                    self.labTitle.text = _postJobModel.job_classfie_name;
                }
                self.imgRightIcon.hidden = (sourceType == ViewSourceType_InvitePersonalJob || sourceType == ViewSourceType_InviteTeamJob);
            }
                break;
            case PostJobCellType_area:{
                self.imgIcon.image = [UIImage imageNamed:@"v250_iconfont"];
                self.labTitle.text = @"选择集合地点";
                self.imgRightIcon.image = [UIImage imageNamed:@"job_icon_push"];
                if (_postJobModel.working_place && _postJobModel.working_place.length > 0) {
                    self.labTitle.text = _postJobModel.working_place;
                }

            }
                break;
            case PostJobCellType_chooseCity:{
                self.imgIcon.image = [UIImage imageNamed:@"v250_iconfont"];
                self.labTitle.text = @"所在城市";
                self.imgRightIcon.image = [UIImage imageNamed:@"job_icon_push"];
                if (_postJobModel.city_name && _postJobModel.city_name.length > 0) {
                    self.labTitle.text = _postJobModel.city_name;
                    self.imgRightIcon.hidden = YES;
                }
            }
                break;
            case PostJobCellType_jobClassify:{
                self.imgIcon.image = [UIImage imageNamed:@"choose_job_classify"];
                self.labTitle.text = @"选择分类";
                self.imgRightIcon.image = [UIImage imageNamed:@"job_icon_push"];
                if (_postJobModel.service_type_classify_name) {
                    self.labTitle.text = _postJobModel.service_type_classify_name;
                }
            }
                break;
            case PostJobCellType_chooseSex:{
                self.imgIcon.image = [UIImage imageNamed:@"job_icon_sex"];
                self.labTitle.text = @"不限";
                self.imgRightIcon.image = [UIImage imageNamed:@"job_icon_xia"];
                if (_postJobModel.sex && ![_postJobModel.sex isEqual:[NSNull null]]) {
                    self.labTitle.text = (_postJobModel.sex.integerValue == 1)? @"男": @"女";
                }
            }
                break;
            default:
                break;
        }
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
