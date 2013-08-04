//
//  ContentVC.m
//  FunQiuShi
//
//  Created by lakkey on 13-6-5.
//
//

#import "ContentVC.h"
#import "AppDelegate.h"
#import "QiuShi.h"
#import "ContentCell.h"
#import "CommentVC.h"


@interface ContentVC () <
    PullingRefreshTableViewDelegate,
    UITableViewDelegate,
    UITableViewDataSource,
    UIScrollViewDelegate,
    SliderSwitchDelegate
>


@property (nonatomic, strong) PullingRefreshTableView* refreshTV;
@property (nonatomic, strong) NSMutableArray*       arrDataList;
@property (nonatomic, assign) BOOL bIsRefreshing; // 是否正在刷新
@property (nonatomic, assign) NSInteger nPage; // 保存当前页数

//滑块
@property (nonatomic,strong) UIImageView *imgVWS2;
@property (nonatomic,strong) UIImageView *imgVWS3;

@property (nonatomic,strong) SliderSwitch *slider2;
@property (nonatomic,strong) SliderSwitch *slider3;


@end

@implementation ContentVC

#define kPageCount 10


- (void)dealloc
{
    self.arrDataList = nil;
    
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    //设置导航栏左侧的按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:@"side_icon@2x"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnSideCliked:) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(0, 0, 32, 32);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
    //
    self.imgVWS2 = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"top_tab_background2"]]autorelease];
    _imgVWS2.userInteractionEnabled = YES;
    _imgVWS2.frame = CGRectMake(0, 0, 120, 29);
    
    self.imgVWS3 = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"top_tab_background3"]]autorelease];
     _imgVWS3.userInteractionEnabled = YES;
    _imgVWS3.frame = CGRectMake(0, 0, 180, 29);

    
    
    self.slider2 = [[SliderSwitch alloc]init];
    //设置滑块的大小,分2段,圆角4.f
    [_slider2 setFrameHorizontal:CGRectMake(0, 0, 120, 29) numberOfFields:2 withCornerRadius:4.f];
    //设置滑块上的字体
    [_slider2 setText:@"嫩草" forTextIndex:1];
    [_slider2 setText:@"干货" forTextIndex:2];
    //设置滑块上的字体颜色
    [_slider2 setTextColor:[UIColor brownColor]];
    //清空背景色
    [_slider2 setFrameBackgroundColor:[UIColor clearColor]];
    
    [_slider2 setSwitchFrameColor:[UIColor brownColor]];
    //设置滑块的边框粗细
    [_slider2 setSwitchBorderWidth:2.f];
    _slider2.delegate =self;
    [_imgVWS2 addSubview:_slider2];
    
    
    self.slider3 = [[SliderSwitch alloc]init];
    [_slider3 setFrameHorizontal:CGRectMake(0, 0, 180, 29) numberOfFields:3 withCornerRadius:4.f];
    [_slider3 setTextColor:[UIColor brownColor]];
    [_slider3 setText:@"日" forTextIndex:1];
    [_slider3 setText:@"周" forTextIndex:2];
    [_slider3 setText:@"月" forTextIndex:3];
    [_slider3 setFrameBackgroundColor:[UIColor clearColor]];
    [_slider3 setSwitchFrameColor:[UIColor brownColor]];
    [_slider3 setSwitchBorderWidth:2.f];
    _slider3.delegate =self;
     [_imgVWS3 addSubview:_slider3];
    
    
    // 添加背景图片
    UIImage* imgBG = [UIImage imageNamed:@"main_background.png"];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:imgBG]];
    
    // 替换默认的主视图为可刷新表格视图
    self.refreshTV = [[[PullingRefreshTableView alloc] initWithFrame:self.view.frame pullingDelegate:self] autorelease];
    self.view = _refreshTV;
    [_refreshTV release];
    [_refreshTV setDataSource:self];
    [_refreshTV setDelegate:self];
    
    // 实例化数组
    self.arrDataList = [[[NSMutableArray alloc] initWithCapacity:40] autorelease];
    
    [_refreshTV launchRefreshing];
    //kvo添加观察者
    AppDelegate *appDele = [UIApplication sharedApplication].delegate;
    [appDele addObserver:self forKeyPath:@"qsType" options:NSKeyValueObservingOptionNew context:nil];
    appDele.qsType = QiuShiTypeNew;
    
}

-(void)btnSideCliked:(id)sender
{
    [self.revealSideViewController pushOldViewControllerOnDirection:PPRevealSideDirectionLeft withOffset:50.f animated:YES];
}




//当appdele.qsType的值发生变化时调用该方法
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    AppDelegate *appdele = [UIApplication sharedApplication].delegate;
    switch (appdele.qsType) {
        case QiuShiTypeNew:
        case QiuShiTypeTop:{
            self.navigationItem.titleView = _imgVWS2;
        
        }
            break;
        case QiuShiTimeDay:
        case QiuShiTimeWeek:
        case QiuShiTimeMonth:{
            
            self.navigationItem.titleView = _imgVWS3;
        }
            break;
        case QiuShiTypePhoto:{
            UILabel *lblPhoto = [[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 29)]autorelease];
            lblPhoto.text = @"有图有真相";
            [lblPhoto setTextColor:[UIColor whiteColor]];
            lblPhoto.textAlignment = NSTextAlignmentCenter;
            lblPhoto.backgroundColor = [UIColor clearColor];
            self.navigationItem.titleView = lblPhoto;
        }
            break;
        case QiuShiTimeRandom:{
            UILabel *lblPhoto = [[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 29)]autorelease];
            lblPhoto.text = @"穿 越";
            [lblPhoto setTextColor:[UIColor whiteColor]];
            lblPhoto.textAlignment = NSTextAlignmentCenter;
            lblPhoto.backgroundColor = [UIColor clearColor];
            self.navigationItem.titleView = lblPhoto;
        }
            break;
        default:
            break;
    }
    
    
    
    [self.refreshTV launchRefreshing];
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSourceDelegate

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    NSLog(@"_arrDataList count = %i", [_arrDataList count]);
    return [_arrDataList count];
}

- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* strIndentifier = @"ContentVC_Cell";
    ContentCell* cell = [tableView dequeueReusableCellWithIdentifier:strIndentifier];
    
    if (!cell) {
        cell = [[[ContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strIndentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    QiuShi* qs = [_arrDataList objectAtIndex:indexPath.row];
    [cell configContentCellWithQiuShi:qs];
    [cell resizeContentCellHeight];
    
    return cell;
}

// 返回指定indexPath位置的Cell的高度
- (float)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self getCellHeightWithIndexPath:indexPath];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentVC* commentVC = [[CommentVC alloc] initWithNibName:nil bundle:nil];
    commentVC.qs = [_arrDataList objectAtIndex:indexPath.row];
    commentVC.fContentCellHeight = [self getCellHeightWithIndexPath:indexPath];
    
    [self.navigationController pushViewController:commentVC animated:YES];

}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_refreshTV tableViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [_refreshTV tableViewDidEndDragging:scrollView];
}


#pragma mark - PullingRefreshTableViewDelegate
// 开始刷新
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView {
    _bIsRefreshing = YES;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:0.1f];
}

// 开始加载更多
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView {
    [self performSelector:@selector(loadData) withObject:nil afterDelay:0.1f];
}

#pragma mark - 

-(void)slideView:(SliderSwitch *)slideswitch switchChangedAtIndex:(NSUInteger)index
{
    AppDelegate *appdele = [UIApplication sharedApplication].delegate;
    
    if (slideswitch == _slider2)
    {
        switch (index) {
            case 0:
                appdele.qsType = QiuShiTypeNew;
                break;
            case 1:
                appdele.qsType = QiuShiTypeTop;
                break;
            default:
                break;
        }
    }
    else
    {
        switch (index) {
            case 0:
                appdele.qsType = QiuShiTimeDay;
                break;
            case 1:
                appdele.qsType = QiuShiTimeWeek;
                break;
            case 2:
                appdele.qsType = QiuShiTimeMonth;
                break;
            default:
                break;
        }
    }
}

#pragma mark - Custum Method

- (void)loadData {
    if (_bIsRefreshing) { // 刷新
        _nPage = 1;
        [_arrDataList removeAllObjects];
        _refreshTV.reachedTheEnd = NO;
    }
    else { // 加载
        _nPage++;
        if (_nPage > 20) {
            _refreshTV.reachedTheEnd = YES;
            [_refreshTV tableViewDidFinishedLoadingWithMessage: @"下面木有了..."];
            return;
        }
    }
    
    NSURL* url = nil;
    switch ([self currentQiuShiType]) {
        case QiuShiTypeTop:
            break;
        
        case QiuShiTypeNew:
            url = [NSURL URLWithString:LastestURLString(kPageCount, _nPage)];
            break;
            
        case QiuShiTypePhoto:
            url = [NSURL URLWithString:ImageURLString(kPageCount, _nPage)];
            break;
            
        case QiuShiTimeDay:
            url = [NSURL URLWithString:DayURLString(kPageCount, _nPage)];
            break;
            
        case QiuShiTimeWeek:
            url = [NSURL URLWithString:WeakURlString(kPageCount, _nPage)];
            break;
            
        case QiuShiTimeMonth:
            url = [NSURL URLWithString:MonthURLString(kPageCount, _nPage)];
            break;
            
        case QiuShiTimeRandom:
            url = [NSURL URLWithString:SuggestURLString(kPageCount, _nPage)];
            break;
            
        default:
            break;
    }

    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:url];
    [request setCompletionBlock:^{
        NSError* error = nil;
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
        if (error) {
            NSLog(@"NSJSONSerialization error : %@", [error localizedDescription]);
            return;
        }
        
        NSArray* arrData = [dic objectForKey:@"items"];
        for (NSDictionary* dicTemp in arrData) {
            QiuShi* qs = [[[QiuShi alloc] initWithDictionary:dicTemp] autorelease];
            [_arrDataList addObject:qs];
        }
        
        [_refreshTV reloadData];
        _bIsRefreshing = NO;
        [_refreshTV tableViewDidFinishedLoading];
    }];
    
    [request setFailedBlock:^{
        _bIsRefreshing = NO;
        [_refreshTV tableViewDidFinishedLoading];
        [AppUltility showBoxWithMessage:@"网络连接异常，请检查网络环境..."];
    }];
    
    [request startAsynchronous];
}

// 获得当前需要显示的糗事类型
- (QiuShiType)currentQiuShiType {
    return ((AppDelegate* )[UIApplication sharedApplication].delegate).qsType;
}

// 获得指定indexPath位置的cell高度
- (float)getCellHeightWithIndexPath:(NSIndexPath* )index {
    QiuShi* qs = [_arrDataList objectAtIndex:index.row];
    UIFont* font = [UIFont fontWithName:@"Arial" size:14.f];
    CGSize size = [qs.strContent sizeWithFont:font constrainedToSize:CGSizeMake(280, 220) lineBreakMode:NSLineBreakByTruncatingTail];
    
    // 是否包含图片
    float rtnHeight = 0;
    if ((qs.strSmallImage != nil) && ![qs.strSmallImage isEqualToString:@""]) {
        rtnHeight = size.height + 250.f;
    }
    else {
        rtnHeight = size.height + 120.f;
    }
    
    return rtnHeight;
}

@end









