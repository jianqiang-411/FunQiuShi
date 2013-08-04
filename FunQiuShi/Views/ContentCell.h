//
//  ContentCell.h
//  FunQiuShi
//
//  Created by lakkey on 13-6-8.
//
//

#import <UIKit/UIKit.h>

@class QiuShi;

@interface ContentCell : UITableViewCell

- (void)configContentCellWithQiuShi:(QiuShi* )qs;

- (void)resizeContentCellHeight;


@end





