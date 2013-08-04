//
//  ContentCell.m
//  FunQiuShi
//
//  Created by lakkey on 13-6-8.
//
//

#import "ContentCell.h"
#import "EGOImageButton.h"
#import "EGOImageView.h"
#import "QiuShi.h"
#import "PhotoVC.h"


@interface ContentCell () <EGOImageButtonDelegate>

// 作者名称
@property (nonatomic, strong) UILabel* lblAuthor;
// 糗事内容
@property (nonatomic, strong) UILabel* lblContent;
// 赞的按钮
@property (nonatomic, strong) UIButton* btnSimle;
// 踩的按钮
@property (nonatomic, strong) UIButton* btnUnhappy;
// 作者头像
@property (nonatomic, strong) UIImageView* imgvwAvatar;
// 收藏按钮
@property (nonatomic, strong) UIButton* btnFavorite;
// 糗事图片
@property (nonatomic, strong) EGOImageButton* imgbtnPhoto;
// 糗事图片的小图url
@property (nonatomic, copy) NSString* strSmallImgURL;
// 糗事图片的大图url
@property (nonatomic, copy) NSString* strMediumImgURL;
// 背景图像
@property (nonatomic, strong) UIImageView* imgvwBackground;
// 底部花边
@property (nonatomic, strong) UIImageView* imgvwFooter;


@end

@implementation ContentCell

- (void)dealloc
{
    self.lblAuthor = nil;
    self.lblContent = nil;
    self.btnSimle = nil;
    self.btnUnhappy = nil;
    self.imgvwAvatar = nil;
    self.btnFavorite = nil;
    self.imgbtnPhoto = nil;
    self.imgvwBackground = nil;
    self.imgvwFooter = nil;
    self.strSmallImgURL = nil;
    self.strMediumImgURL = nil;

    [super dealloc];
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 添加背景图片
        self.imgvwBackground = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"block_center_background.png"]] autorelease];
        [_imgvwBackground setFrame:CGRectMake(0, 0, 320, 280)];
        [self addSubview:_imgvwBackground];
        [_imgvwBackground release];
        
        // 作者头像
        self.imgvwAvatar = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"thumb_avatar.png"]] autorelease];
        [_imgvwAvatar setFrame:CGRectMake(15, 5, 24, 24)];
        [self addSubview:_imgvwAvatar];
        [_imgvwAvatar release];
        
        // 作者名称
        self.lblAuthor = [[[UILabel alloc] initWithFrame:CGRectMake(45, 5, 200, 30)] autorelease];
        _lblAuthor.text = @"匿名";
        _lblAuthor.backgroundColor = [UIColor clearColor];
        _lblAuthor.font = [UIFont fontWithName:@"Arial" size:14.f];
        _lblAuthor.textColor = [UIColor brownColor];
        [self addSubview:_lblAuthor];
        [_lblAuthor release];
        
        // _lblContent
        self.lblContent = [[UILabel alloc] initWithFrame:CGRectMake(20, 28, 280, 200)];
        _lblContent.lineBreakMode = NSLineBreakByTruncatingTail;
        _lblContent.numberOfLines = 0;
        _lblContent.textColor = [UIColor brownColor];
        _lblContent.font = [UIFont fontWithName:@"Arial" size:14.f];
        _lblContent.backgroundColor = [UIColor clearColor];
        [self addSubview:_lblContent];
        [_lblContent release];
        
        // _btnSimle
        self.btnSimle = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnSimle setFrame:CGRectMake(15, _lblContent.frame.size.height + 30, 70, 44)];
        [_btnSimle setBackgroundImage:[UIImage imageNamed:@"button_vote_enable.png"] forState:UIControlStateNormal];
        [_btnSimle setBackgroundImage:[UIImage imageNamed:@"button_vote_active.png"] forState:UIControlStateHighlighted];
        [_btnSimle setImage:[UIImage imageNamed:@"icon_for_enable.png" ] forState:UIControlStateNormal];
        [_btnSimle setImage:[UIImage imageNamed:@"icon_for_active.png"] forState:UIControlStateHighlighted];
        [_btnSimle setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 15)];
        [_btnSimle setTitle:@"0" forState:UIControlStateNormal];
        [_btnSimle setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
        [_btnSimle setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -15)];
        [self addSubview:_btnSimle];
        [_btnSimle release];
        
        // _btnUnhappy
        self.btnUnhappy = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnUnhappy setFrame:CGRectMake(105, _lblContent.frame.size.height + 30, 70, 44)];
        [_btnUnhappy setBackgroundImage:[UIImage imageNamed:@"button_vote_enable.png"] forState:UIControlStateNormal];
        [_btnUnhappy setBackgroundImage:[UIImage imageNamed:@"button_vote_active.png"] forState:UIControlStateHighlighted];
        [_btnUnhappy setImage:[UIImage imageNamed:@"icon_against_enable.png" ] forState:UIControlStateNormal];
        [_btnUnhappy setImage:[UIImage imageNamed:@"icon_against_active.png"] forState:UIControlStateHighlighted];
        [_btnUnhappy setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 15)];
        [_btnUnhappy setTitle:@"0" forState:UIControlStateNormal];
        [_btnUnhappy setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
        [_btnUnhappy setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -15)];
        [self addSubview:_btnUnhappy];
        [_btnUnhappy release];
        
        //
        self.btnFavorite = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnFavorite setFrame:CGRectMake(270, _lblContent.frame.size.height + 30, 35, 44)];
        [_btnFavorite setBackgroundImage:[UIImage imageNamed:@"button_vote_enable.png"] forState:UIControlStateNormal];
        [_btnFavorite setBackgroundImage:[UIImage imageNamed:@"button_vote_active.png"] forState:UIControlStateHighlighted];
        [_btnFavorite setImage:[UIImage imageNamed:@"icon_fav_enable.png"] forState:UIControlStateNormal];
        [_btnFavorite setImage:[UIImage imageNamed:@"icon_fav_active.png"] forState:UIControlStateHighlighted];
        [self addSubview:_btnFavorite];
        [_btnFavorite release];
        
        // _imgbtnPhoto
        self.imgbtnPhoto = [[[EGOImageButton alloc] initWithPlaceholderImage:[UIImage imageNamed:@"thumb_pic.png"] delegate:self] autorelease];
        // 点击图片按钮时的响应方法
        [_imgbtnPhoto addTarget:self action:@selector(imageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_imgbtnPhoto];
        [_imgbtnPhoto release];
        
        // 底部的花纹
        self.imgvwFooter = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"block_foot_background.png"]] autorelease];
        [_imgvwFooter setFrame:CGRectMake(0, _imgvwBackground.frame.size.height, 320, 15)];
        [self addSubview:_imgvwFooter];
        [_imgvwFooter release];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Custom Method

- (void)configContentCellWithQiuShi:(QiuShi *)qs {
    if ((qs.strAuthor != nil) && ![qs.strAuthor isEqualToString:@""]) {
        self.lblAuthor.text = qs.strAuthor;
    }
    else {
        self.lblAuthor.text = @"匿名";
    }
    
    self.lblContent.text = qs.strContent;
    
    [self.btnSimle setTitle:[NSString stringWithFormat:@"%i", qs.nSimleCount] forState:UIControlStateNormal];
    [self.btnUnhappy setTitle:[NSString stringWithFormat:@"%i", qs.nUnhappleCount] forState:UIControlStateNormal];
    
    
    if ((qs.strSmallImage != nil) && ![qs.strSmallImage isEqualToString:@""]) {
        self.strSmallImgURL = qs.strSmallImage;
        self.strMediumImgURL = qs.strMidiumImage;
//        // 开始加载小图
//        self.imgbtnPhoto.imageURL = [NSURL URLWithString:_strSmallImgURL];
    }
    else {
        self.strSmallImgURL = @"";
        self.strMediumImgURL = @"";
    }
}


-(void)adjustImageSize:(EGOImageButton*)imageButton
{
    UIImage* image = imageButton.imageView.image;
    
    CGFloat fWidthScale = 1.0f;
    CGFloat fHeightScale = 1.0f;
    if (image.size.width > 280) {
        fWidthScale = image.size.width / 280;
    }
    
    if (image.size.height > 125) {
        fHeightScale = image.size.height / 125;
    }
    
    CGFloat scale = MAX(fWidthScale, fHeightScale);
    CGRect rect = imageButton.frame;
    //    NSLog(@"image.size = %@", NSStringFromCGSize(image.size));
    rect.size.width = image.size.width / scale;
    rect.size.height = image.size.height / scale;
    imageButton.frame = rect;

}

- (void)resizeContentCellHeight {
    UIFont* font = [UIFont fontWithName:@"Arial" size:14.f];
    CGSize size = [_lblContent.text sizeWithFont:font constrainedToSize:CGSizeMake(280, 220) lineBreakMode:NSLineBreakByTruncatingTail];
    // 根据文字的大小重新调整控件的大小和位置
    [_lblContent setFrame:CGRectMake(20, 28, 280, size.height + 30.f)];
    // 载入糗事图片
    if ((_strSmallImgURL != nil) && ![_strSmallImgURL isEqualToString:@""]) {
        
        [_imgbtnPhoto setFrame:CGRectMake(30, size.height + 70 , 72, 72)];
        [_imgvwBackground setFrame:CGRectMake(0, 0, 320, size.height + 230)];
        _imgbtnPhoto.imageURL = [NSURL URLWithString:_strSmallImgURL];
        [self adjustImageSize:_imgbtnPhoto];
    }
    else {
        [_imgbtnPhoto cancelImageLoad];
        [_imgbtnPhoto setFrame:CGRectMake(30, size.height, 0, 0)];
        [_imgvwBackground setFrame:CGRectMake(0, 0, 320, size.height + 100)];
    }
    //
    CGFloat fBgEdge = _imgvwBackground.frame.size.height;
    [_imgvwFooter setFrame:CGRectMake(0, fBgEdge, 320, 15)];
    [_btnSimle setFrame:CGRectMake(15, fBgEdge - 38, 70, 44)];
    [_btnUnhappy setFrame:CGRectMake(105, fBgEdge - 38, 70, 44)];
    [_btnFavorite setFrame:CGRectMake(270, fBgEdge - 38, 35, 44)];
}

- (void)imageButtonClick:(id)sender {
    UIWindow* window = [[UIApplication sharedApplication] keyWindow];
    
    PhotoVC* photoVC = [[[PhotoVC alloc] initWithNibName:nil bundle:nil] autorelease];
    // 传递小图片到新的视图控制器
    photoVC.imgView = [[EGOImageView alloc] initWithPlaceholderImage:self.imgbtnPhoto.imageView.image delegate:photoVC];
    //
    photoVC.originFrame = [_imgbtnPhoto convertRect:_imgbtnPhoto.bounds toView:window];
    // 设置模态视图的动画模式
    [photoVC setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    
    [window.rootViewController presentViewController:photoVC animated:YES completion:nil];
}


#pragma mark - EGOImageButtonDelegate
//imageButton成功加载图片完成之后,回调该方法
- (void)imageButtonLoadedImage:(EGOImageButton *)imageButton {
    // 调整并限制imageButton的大小，宽不超过280，高不超过125
    [self adjustImageSize:imageButton];
}

- (void)imageButtonFailedToLoadImage:(EGOImageButton *)imageButton error:(NSError *)error {
    [imageButton cancelImageLoad];
}



@end









