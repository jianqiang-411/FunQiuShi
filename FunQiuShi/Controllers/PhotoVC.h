//
//  PhotoVC.h
//  FunQiuShi
//
//  Created by lakkey on 13-6-9.
//
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"


@interface PhotoVC : UIViewController <EGOImageViewDelegate>

// 用于异步加载图片
@property (nonatomic, strong) EGOImageView* imgView;
// 小图片的原始位置
@property (nonatomic, assign) CGRect originFrame;

@end





