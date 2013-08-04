//
//  MenuVC.m
//  FunQiuShi
//
//  Created by lakkey on 13-6-5.
//
//

#import "MenuVC.h"
#import "ContentVC.h"
#import "AppDelegate.h"
@interface MenuVC ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSArray *arrDataSource;

@end

@implementation MenuVC

-(void)dealloc
{
    self.tableView = nil;
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
	// Do any additional setup after loading the view.
    //添加背景颜色
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"side_menu_textural@2x"]]];
    self.view.frame = CGRectMake(40, 0, 280, 548);
    
    
    
    self.arrDataSource = [NSArray arrayWithObjects:@"随便逛逛",@"精华",@"有图有真相",@"穿越", nil];

    //按钮
    UIButton *btnUser = [UIButton buttonWithType:UIButtonTypeCustom];
    btnUser.frame = CGRectMake(0, 0, 200, 44);
    [btnUser setBackgroundImage:[UIImage imageNamed:@"side_user_background"] forState:UIControlStateNormal];
    [self.view addSubview:btnUser];
    //按钮上的图片
    UIImageView *imgVC = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"side_user_avatar"]]autorelease];
    imgVC.frame = CGRectMake(10, 7, 30, 30);
    [btnUser addSubview:imgVC];
    //右边的按钮
    UIButton *btnSetting = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImageView *imgVCSetting = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"side_setting_icon_active"]]autorelease];
    imgVCSetting.frame = CGRectMake(11, 1.5, 44, 44);
    [btnSetting addSubview:imgVCSetting];
    btnSetting.frame = CGRectMake(200.3, 0, 119.7, 44);
    [btnSetting setBackgroundImage:[UIImage imageNamed:@"side_user_background"] forState:UIControlStateNormal];
    
    
    [self.view addSubview:btnSetting];
    //初始化tableView
    self.tableView = [[[UITableView alloc]initWithFrame:CGRectMake(0, 44, 320-50, SCREEN_HEIGHT-44) style:UITableViewStylePlain]autorelease];
    
    _tableView.backgroundColor = [UIColor clearColor];
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    

    _tableView.dataSource =self;
   _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_arrDataSource count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str = @"aaa";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        cell.selectedBackgroundView = [[[UIImageView alloc] init] autorelease];
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"side_menu_background_active"]];
        
        UIImageView *imgVC = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"side_menu_arrow"]];
        imgVC.frame = CGRectMake(0, 0, 44, 44);
        imgVC.backgroundColor = [UIColor clearColor];
        cell.accessoryView = imgVC;
        
        UIFont* font = [UIFont fontWithName:@"Arial" size:14.f];
        [cell.textLabel setFont:font];
        [cell.textLabel setTextColor:[UIColor whiteColor]];
       
                
        UIImage *imgCellBG = [UIImage imageNamed:@"side_menu_background@2x"];
        UIImageView *imgVC1 = [[[UIImageView alloc]initWithImage:imgCellBG]autorelease];
        cell.backgroundColor = [UIColor clearColor];
        cell.backgroundView = imgVC1;
    }

  
    
    cell.textLabel.text = [_arrDataSource objectAtIndex:indexPath.row];

    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *appdele = [UIApplication sharedApplication].delegate;
    
    switch (indexPath.row) {
        case 0:
            appdele.qsType = QiuShiTypeNew;
            break;
        case 1:
            appdele.qsType =QiuShiTimeDay;
            break;
        case 2:
            appdele.qsType = QiuShiTypePhoto;
            break;
        case 3:
            appdele.qsType = QiuShiTimeRandom;
            break;
        default:
            break;
    }
    [self.revealSideViewController popViewControllerAnimated:YES];
}




@end
