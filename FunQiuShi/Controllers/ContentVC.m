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


@interface ContentVC () <
    PullingRefreshTableViewDelegate,
    UITableViewDelegate,
    UITableViewDataSource,
    UIScrollViewDelegate
>


@property (nonatomic, strong) PullingRefreshTableView* refreshTV;
@property (nonatomic, strong) NSMutableArray*       arrDataList;
@property (nonatomic, assign) BOOL bIsRefreshing; // 是否正在刷新
@property (nonatomic, assign) NSInteger nPage; // 保存当前页数

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
    
    // 替换默认的主视图为可刷新表格视图
    self.refreshTV = [[[PullingRefreshTableView alloc] initWithFrame:self.view.frame pullingDelegate:self] autorelease];
    self.view = _refreshTV;
    [_refreshTV release];
    [_refreshTV setDataSource:self];
    [_refreshTV setDelegate:self];
    
    // 实例化数组
    self.arrDataList = [[[NSMutableArray alloc] initWithCapacity:40] autorelease];
    
    [_refreshTV launchRefreshing];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSourceDelegate

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [_arrDataList count];
}

- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* strIndentifier = @"ContentVC_Cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:strIndentifier];
    
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strIndentifier] autorelease];
    }
    
    QiuShi* qs = [_arrDataList objectAtIndex:indexPath.row];
    cell.textLabel.text = qs.strId;
    return cell;
}

#pragma mark - UITableViewDelegate


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

#pragma mark - Custum Method

- (void)loadData {
    if (_bIsRefreshing) { // 刷新
        _nPage = 1;
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
    }];
    
    [request startAsynchronous];
}

// 获得当前需要显示的糗事类型
- (QiuShiType)currentQiuShiType {
    return ((AppDelegate* )[UIApplication sharedApplication].delegate).qsType;
}



@end









