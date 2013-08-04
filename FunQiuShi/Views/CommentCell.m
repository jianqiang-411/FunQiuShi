//
//  CommentCell.m
//  FunQiuShi
//
//  Created by lakkey on 13-6-13.
//
//

#import "CommentCell.h"
#import "Comment.h"
@interface CommentCell ()

// 评论的作者
@property (nonatomic, strong) UILabel*      lblAuthor;
// 评论内容
@property (nonatomic, strong) UILabel*      lblContent;
// 楼层
@property (nonatomic, strong) UILabel*      lblFloor;
// 背景图
@property (nonatomic, strong) UIImageView*  imgvwBackground;
// 底部图案
@property (nonatomic, strong) UIImageView*  imgvwFooter; 

@end

@implementation CommentCell

- (void)dealloc
{
    self.lblAuthor = nil;
    self.lblContent = nil;
    self.lblFloor = nil;
    self.imgvwBackground = nil;
    self.imgvwFooter = nil;
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 背景图
        self.imgvwBackground = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"block_center_background.png"]] autorelease];
        [self addSubview:_imgvwBackground];
        [_imgvwBackground release];
        
        // _lblAuthor
        self.lblAuthor = [[[UILabel alloc] initWithFrame:CGRectMake(10, 4, 200, 30)] autorelease];
        _lblAuthor.text = @"匿名";
        _lblAuthor.backgroundColor = [UIColor clearColor];
        _lblAuthor.font = [UIFont fontWithName:@"Arial" size:14];
        _lblAuthor.textColor = [UIColor brownColor];
        [self addSubview:_lblAuthor];
        [_lblAuthor release];
        
        // _lblContent
        self.lblContent = [[[UILabel alloc] initWithFrame:CGRectMake(20, 28, 280, 200)] autorelease];
        _lblContent.backgroundColor = [UIColor clearColor];
        _lblContent.font = [UIFont fontWithName:@"Arial" size:14];
        _lblContent.textColor = [UIColor orangeColor];
        _lblContent.numberOfLines = 0;
        [self addSubview:_lblContent];
        [_lblContent release];
        
        // _lblFloor
        self.lblFloor = [[[UILabel alloc] initWithFrame:CGRectMake(290, 4, 50, 30)] autorelease];
        _lblFloor.backgroundColor = [UIColor clearColor];
        _lblFloor.text = @"1";
        _lblFloor.font = [UIFont fontWithName:@"Arial" size:14];
        _lblFloor.textColor = [UIColor brownColor];
        [self addSubview:_lblFloor];
        [_lblFloor release];
        
        // 底部的线条
        self.imgvwFooter = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"block_line.png"]] autorelease];
        [self addSubview:_imgvwFooter];
        [_imgvwFooter release];
    }
    return self;
}

- (void)configCommentCellWithComment:(Comment* )comment
{
    if (comment.strAuthor !=nil && ![comment.strAuthor isEqualToString:@""])
    {
        self.lblAuthor.text =comment.strAuthor;
    }
    if (comment.strContent !=nil && ![comment.strContent isEqualToString:@""])
    {
        self.lblContent.text = comment.strContent;
    }
    self.lblFloor.text =[NSString stringWithFormat:@"%i",comment.nFloor];
}
//调整cell的高度
- (void)resizeCommentCellHeight
{
    UIFont *font = [UIFont fontWithName:@"Arial" size:14];
    //在上面的字体大小下以下面的断字方式 _lblContent.text 占多大size
    //constrainedToSize把文字约束在CGSizeMake(280, 220)范围内
    //NSLineBreakByTruncatingTail表示超出的部分显示省略号
    CGSize size = [_lblContent.text sizeWithFont:font constrainedToSize:CGSizeMake(280, 220) lineBreakMode:NSLineBreakByTruncatingTail];
    
    [_lblContent setFrame:CGRectMake(20, 32, 280, size.height+15.f)];
    _imgvwBackground.frame = CGRectMake(0, 0, 320, size.height+45);
    _imgvwFooter.frame = CGRectMake(0, _imgvwBackground.frame.size.height-2, 320, 2);
}









- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}






@end
