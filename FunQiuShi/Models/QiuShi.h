//
//  QiuShi.h
//  Test_Jason
//
//  Created by lakkey on 13-6-6.
//
//

#import <Foundation/Foundation.h>

@interface QiuShi : NSObject

// 作者
@property (nonatomic, copy) NSString* strAuthor;
// 糗事发表时间
@property (nonatomic, assign) NSTimeInterval publishTime;
// 用户Id
@property (nonatomic, copy) NSString*       strId;
// 被赞的次数
@property (nonatomic, assign) NSInteger     nSimleCount;
// 被踩的次数
@property (nonatomic, assign) NSInteger     nUnhappleCount;
// 糗事内容
@property (nonatomic, copy) NSString*       strContent;
// 小图片地址
@property (nonatomic, copy) NSString*       strSmallImage;
// 大图片地址
@property (nonatomic, copy) NSString*       strMidiumImage;

- (id)initWithDictionary:(NSDictionary* )dic;

@end







