//
//  PhotoVC.m
//  FunQiuShi
//
//  Created by lakkey on 13-6-9.
//
//

#import "PhotoVC.h"
#import <QuartzCore/QuartzCore.h>

#define AnimationDuration 0.6f

@interface PhotoVC () <UIScrollViewDelegate>

@property (nonatomic, assign) CGPoint potCenter; // 保存图片的初始中心位置
@property (nonatomic, assign) CGAffineTransform trans; // 保存图片的初始变形

@property (nonatomic, strong) UIGestureRecognizer* tap; // 轻击手势
@property (nonatomic, assign) CGFloat fScale; // 保存缩放变化前的值
@property (nonatomic, strong) UIScrollView* scrollView;


@end

@implementation PhotoVC

- (void)dealloc
{
    NSLog(@"%@ dealloc...", self);
    [self.view removeGestureRecognizer:_tap];
    self.imgView = nil;
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    // 隐藏状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    // 添加点击手势
    self.tap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)] autorelease];
    [self.view addGestureRecognizer:self.tap];
    [_tap release];
    
    // _scrollView
    self.scrollView = [[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)] autorelease];
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    //
    [_imgView setFrame:_originFrame];
    [_scrollView addSubview:_imgView];
//    [_imgView release];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // 为图片的中心点属性设置动画
    CABasicAnimation* animCenter = [CABasicAnimation animationWithKeyPath:@"position"];
    // 保存图片的初始中心位置
    _potCenter = _imgView.center;
    animCenter.fromValue = [NSValue valueWithCGPoint:_imgView.center];
    animCenter.toValue = [NSValue valueWithCGPoint:self.view.center];
    
    // 为图片的缩放属性设置动画
    CABasicAnimation* animScale = [CABasicAnimation animationWithKeyPath:@"transform"];
    _trans = _imgView.transform;
    animScale.fromValue = [NSValue valueWithCGAffineTransform:_trans];
    float fWidthScale = 0;
    float fHeightScale = 0;
    fWidthScale = self.view.bounds.size.width / _imgView.bounds.size.width;
    fHeightScale = self.view.bounds.size.height / _imgView.bounds.size.height;

    _fScale = MIN(fWidthScale, fHeightScale);
    [_scrollView setMinimumZoomScale:_fScale];
    [_scrollView setMaximumZoomScale:_fScale * 4];
    
    
    animScale.toValue = [NSValue valueWithCGAffineTransform:CGAffineTransformMakeScale(_fScale, _fScale)];
   
    //
    CAAnimationGroup* group = [CAAnimationGroup animation];
    group.duration = AnimationDuration;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    group.animations = @[animCenter, animScale];
    group.delegate = self;
    [_imgView.layer addAnimation:group forKey:nil];
    
    // 设置动画结束后的实际位置
    _imgView.center = [animCenter.toValue CGPointValue];
    _imgView.transform = [animScale.toValue CGAffineTransformValue];
    

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 轻击手势的响应方法
- (void)handleTapGesture:(UITapGestureRecognizer* )tap {
    [_scrollView setZoomScale:_fScale];
    
    // 为图片的中心点属性设置动画
    CABasicAnimation* animaCenter = [CABasicAnimation animationWithKeyPath:@"position"];
    animaCenter.fromValue = [NSValue valueWithCGPoint:self.view.center];
    animaCenter.toValue = [NSValue valueWithCGPoint:_potCenter];
    
    // 为图片的缩放属性设置动画
    CABasicAnimation* animaScale = [CABasicAnimation animationWithKeyPath:@"transform"];
    animaScale.fromValue = [NSValue valueWithCGAffineTransform:_imgView.transform];
    animaScale.toValue = [NSValue valueWithCGAffineTransform:_trans];
    
    // group
    CAAnimationGroup* animGroup = [CAAnimationGroup animation];
    animGroup.animations = @[animaCenter, animaScale];
    animGroup.duration = AnimationDuration;
    animGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [_imgView.layer addAnimation:animGroup forKey:nil];
    
    // 设置动画完成后的值
    _imgView.center = [animaCenter.toValue CGPointValue];
    _imgView.transform = [animaScale.toValue CGAffineTransformValue];
    
    // 延迟解除模态视图
    [self performSelector:@selector(dismissSelf) withObject:nil afterDelay:AnimationDuration];
}

- (void)dismissSelf {
    // 重新显示状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    //
    UIWindow* window = [[UIApplication sharedApplication] keyWindow];
    [window.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIScrollViewDelegate
// 返回需要同步缩放的子视图
- (UIView* )viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imgView;
}

// 当scrollView完成缩放时
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView
                       withView:(UIView *)view
                        atScale:(float)scale {
    [scrollView setZoomScale:scale];
}

@end





