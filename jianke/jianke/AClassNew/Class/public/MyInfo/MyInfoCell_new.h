//
//  MyInfoCell_new.h
//  JKHire
//
//  Created by fire on 16/11/4.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyEnum.h"

typedef NS_ENUM(NSInteger, MyInfoCellType) {
    
    
    EPMyInfoCellType_login     =1,
    EPMyInfoCellType_moneyBag,
    
    EPMyInfoCellType_vip,
    EPMyInfoCellType_myFans,
    EPMyInfoCellType_contact,
    EPMyInfoCellType_QACenter,
    EPMyinfoCellType_aboutApp,
    
    EPMyInfoCellType_editService,
    EPMyInfoCellType_reciveServiceOrder,
    EPMyInfoCellType_applyService,
    EPMyInfoCellType_postedServiceList,
    
    EPMyInfoCellType_EPService,
    
    EPMyInfoCellType_inviteBalance,


    EPMyInfoCellType_contactMgr,
    EPMyInfoCellType_switchToJK,
    
    EPMyInfoCellType_vasService,    //付费推广
    EPMyInfoCellType_RecruitJob,    //在招岗位数
    
    EPMyInfoCellType_baozhao,   //包代招
    EPMyInfoCellType_CustomeService,    //定制服务
};

@class MyInfoCell_new, EPModel;
@protocol MyInfoCell_newDelegate <NSObject>

- (void)myInfoCellNew:(MyInfoCell_new *)cell actionType:(BtnOnClickActionType)actionType;

@end

@interface MyInfoCell_new : UITableViewCell

@property (nonatomic, weak) id<MyInfoCell_newDelegate> delegate;

@property (nonatomic, assign) MyInfoCellType cellType;
@property (nonatomic, strong) EPModel *epInfo;
@property (weak, nonatomic) IBOutlet UIButton *btnIM;
@property (weak, nonatomic) IBOutlet UIButton *btnCall;
@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UILabel *labNum;

@end
