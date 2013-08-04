//
//  CommentCell.h
//  FunQiuShi
//
//  Created by lakkey on 13-6-13.
//
//

#import <UIKit/UIKit.h>

@class Comment;

@interface CommentCell : UITableViewCell

- (void)configCommentCellWithComment:(Comment* )comment;

- (void)resizeCommentCellHeight;


@end





