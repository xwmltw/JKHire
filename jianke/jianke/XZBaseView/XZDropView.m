//
//  XZDropView.m
//  lottery
//
//  Created by yanqb on 2017/3/17.
//  Copyright © 2017年 xsj. All rights reserved.
//

#import "XZDropView.h"

@interface XZDropView ()<UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, copy) xzDropViewBlock block;
@property (nonatomic, strong) UIWindow *window;

@end

@implementation XZDropView

+ (void)showDropViewWithItems:(NSArray <NSString *>*)items block:(xzDropViewBlock)block{
    [self showDropViewAtRect:CGRectZero withItems:items block:block];
}

+ (void)showDropViewAtRect:(CGRect)rect withItems:(NSArray <NSString *>*)items block:(xzDropViewBlock)block{
    XZDropView *dropView = [[XZDropView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    dropView.showRect = rect;
    if (CGSizeEqualToSize(rect.size, CGRectZero.size) || CGPointEqualToPoint(rect.origin, CGRectZero.origin)) {
        dropView.showRect = CGRectMake([UIScreen mainScreen].bounds.size.width - 100, 64, 100, 150);
    }
    dropView.dataSource = items;
    [dropView shwoWithBlock:block];
}

- (void)shwoWithBlock:(xzDropViewBlock)block{
    self.block = block;
    [self show];
    [self.tableView reloadData];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
//        [self setupViews];
        [self addGesture];
    }
    return self;
}

- (UITableView *)tableView{
    if (!_tableView) {
        self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.4];
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.showRect style:UITableViewStylePlain];
        tableView.backgroundColor = self.dropBackgroundColor;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.allowsSelection = YES;
        tableView.dataSource = self;
        tableView.delegate = self;
        _tableView = tableView;
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        
        [self addSubview:tableView];
    }
    return _tableView;
}

- (void)setupViews{

}

- (void)addGesture{
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGes:)];
    tapGes.delegate = self;
    [self addGestureRecognizer:tapGes];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = [self.dataSource objectAtIndex:indexPath.row];
    cell.textLabel.textColor = self.titleColor;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.block) {
        self.block(indexPath.row);
    }
    [self dismiss];
}

- (void)show{
    self.window = [[UIWindow alloc] init];
    self.window.backgroundColor = [UIColor clearColor];
    self.window.windowLevel = UIWindowLevelAlert + 1;
    self.window.hidden = NO;
    [self.window addSubview:self];
}

- (void)dismiss{
    [UIView animateWithDuration:0.3f animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (NSArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [[NSArray alloc] init];
    }
    return _dataSource;
}

- (void)tapGes:(UITapGestureRecognizer *)ges{
    [self dismiss];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}

- (UIColor *)dropBackgroundColor{
    if (!_dropBackgroundColor) {
        _dropBackgroundColor = [UIColor whiteColor];
    }
    return _dropBackgroundColor;
}

- (UIColor *)titleColor{
    if (!_titleColor) {
        _titleColor = [UIColor blackColor];
    }
    return _titleColor;
}

- (void)dealloc{
    NSLog(@"dealloc");
}

@end
