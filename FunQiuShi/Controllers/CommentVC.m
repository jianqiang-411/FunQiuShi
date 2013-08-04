//
//  CommentVC.m
//  FunQiuShi
//
//  Created by lakkey on 13-6-13.
//
//

#import "CommentVC.h"
#import "QiuShi.h"
#import "Comment.h"
#import "ContentCell.h"
#import "CommentCell.h"
#import "ASIHTTPRequest.h"
#import "JSONKit.h"

@interface CommentVC () <
    UITableViewDataSource,
    UITableViewDelegate
>

// 显示糗事内容的表格视图
@property (nonatomic, strong) UITableView* qsTV;
// 显示评论的表格视图
@property (nonatomic, strong) UITableView* commentTV;
// 保存评论的数组
@property (nonatomic, strong) NSMutableArray* arrCommentList;


@end

@implementation CommentVC

- (void)dealloc
{
    NSLog(@"%@ : dealloc", self);
    self.qs = nil;
    self.qsTV = nil;
    self.commentTV = nil;
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self ceartArrList];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    // 添加背景图片
    UIImage* imgBG = [UIImage imageNamed:@"main_background.png"];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:imgBG]];
    
    // 替换系统自带的返回按钮
    UIButton* btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack setBackgroundImage:[UIImage imageNamed:@"icon_back_enable.png"] forState:UIControlStateNormal];
    [btnBack setFrame:CGRectMake(0, 0, 40, 30)];
    [btnBack addTarget:self action:@selector(backToContentVC:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:btnBack] autorelease];
    
	
    // _qsTV
    self.qsTV = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.fContentCellHeight) style:UITableViewStylePlain] autorelease];
    //不使用分割线
    [_qsTV setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    //禁止选中cell
    [_qsTV setAllowsSelection:NO];
    //禁止滚动
    [_qsTV setScrollEnabled:NO];
    [_qsTV setBackgroundColor:[UIColor clearColor]];
    _qsTV.delegate = self;
    _qsTV.dataSource = self;
    //_qsTV.tableHeaderView
    //\_qsTV.tableFooterView
    [_qsTV release];
    // _commentTV
    self.commentTV = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 44) style:UITableViewStylePlain] autorelease];
    [_commentTV setTableHeaderView:_qsTV];
    //不使用分割线
    [_commentTV setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    //禁止选中cell
    [_commentTV setAllowsSelection:NO];
    
    [_commentTV setBackgroundColor:[UIColor clearColor]];
    _commentTV.dataSource = self;
    _commentTV.delegate = self;

    //_commentTV.tableFooterView =
    [self.view addSubview:_commentTV];
    [_commentTV release];
    
    
    
}

-(void)ceartArrList
{
    self.title = [NSString stringWithFormat:@"糗事%@",_qs.strId];
    //将存取数据的数组初始化
    if (_arrCommentList == nil) {
        _arrCommentList = [[NSMutableArray alloc]initWithCapacity:20];
    }
    [_arrCommentList removeAllObjects];
    
    
    NSString * strURL = CommentsURLString( _qs.strId);
    
    NSURL *url = [NSURL URLWithString:strURL];
    self.request = [ASIHTTPRequest requestWithURL:url];
    [_request setCompletionBlock:^{
        //JSONKIT
        //解码
        NSDictionary *dic = [[JSONDecoder decoder]objectWithData:_request.responseData] ;

//        NSError *error = nil;
 //       NSDictionary *dic4 = [NSJSONSerialization JSONObjectWithData:_request.responseData options:kNilOptions error:&error];
//        
        NSArray *arr = [dic objectForKey:@"items"];
        
        for (NSDictionary *tempDic in arr) {
            Comment *comment = [[[Comment alloc]initWithDictionary:tempDic]autorelease];
            [_arrCommentList addObject:comment];
        }
        
        [self.commentTV reloadData];
    }];
    
    [_request setFailedBlock:^{
    
        [AppUltility showBoxWithMessage:@"请求评论数据失败......"];
    
    }];
    [_request startAsynchronous];
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSourceDelegate

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    if (tableView == _qsTV) {
        return 1;
    }
    else {
        return [_arrCommentList count];
    }
}

- (UITableViewCell* )tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _qsTV) {
        static NSString* strIndetifier = @"QiuShiCell";
        ContentCell* contentCell = [tableView dequeueReusableCellWithIdentifier:strIndetifier];
        if (contentCell == nil) {
            contentCell = [[[ContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strIndetifier] autorelease];
        }
    
        [contentCell configContentCellWithQiuShi:_qs];
        [contentCell resizeContentCellHeight];
        return contentCell;
    }
    else {
        static NSString *strIndetifier = @"commentCell";
        CommentCell *commentcell = [tableView dequeueReusableCellWithIdentifier:strIndetifier];
        if (commentcell == nil) {
            commentcell = [[[CommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strIndetifier]autorelease];
        }
        [commentcell configCommentCellWithComment:[_arrCommentList objectAtIndex:indexPath.row]];
        [commentcell resizeCommentCellHeight];
        
        return commentcell;
    }
}

- (float)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _qsTV) {
        return _fContentCellHeight;
    }
    else {
        return [self getCellHeightWithIndexPath:indexPath];
    }
}


#pragma mark - Custom Method

- (void)backToContentVC:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(float)getCellHeightWithIndexPath:(NSIndexPath*)indexPath
{
   
    UIFont* font = [UIFont fontWithName:@"Arial" size:14.f];
     Comment* comment = [_arrCommentList objectAtIndex:indexPath.row];
    CGSize size = [comment.strContent sizeWithFont:font constrainedToSize:CGSizeMake(280, 220) lineBreakMode:NSLineBreakByTruncatingTail];
    return  size.height+45;
}

@end











