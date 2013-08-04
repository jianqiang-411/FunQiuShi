//
//  CommentVC.h
//  FunQiuShi
//
//  Created by lakkey on 13-6-13.
//
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
@class QiuShi;


@interface CommentVC : UIViewController

// 用于传递qsTV的高度
@property (nonatomic, assign) CGFloat fContentCellHeight;

// 用于传递当前的糗事内容
@property (nonatomic, strong) QiuShi* qs;

@property (nonatomic,strong)  ASIHTTPRequest *request;
@end













