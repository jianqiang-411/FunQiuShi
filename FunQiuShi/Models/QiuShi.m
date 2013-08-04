//
//  QiuShi.m
//  Test_Jason
//
//  Created by lakkey on 13-6-6.
//
//

#import "QiuShi.h"

@implementation QiuShi

- (void)dealloc
{
    self.strId = nil;
    self.strContent = nil;
    self.strSmallImage = nil;
    self.strMidiumImage = nil;
    [super dealloc];
}


- (id)initWithDictionary:(NSDictionary* )dic {
    if (self = [super init]) {
        //
        _publishTime = [[dic objectForKey:@"published_at"] doubleValue];
        //
        self.strId = [dic objectForKey:@"id"];
        //
        NSDictionary* dicTemp = [dic objectForKey:@"votes"];
        _nSimleCount = [[dicTemp objectForKey:@"up"] integerValue];
        _nUnhappleCount = [[dicTemp objectForKey:@"down"] integerValue];
        //
        self.strContent = [dic objectForKey:@"content"];
        //
        NSString* imgageURL = [dic objectForKey:@"image"];
        if (((NSNull* )imgageURL != [NSNull null]) && ![imgageURL isEqualToString:@""]) {
            // +
            NSString* strSubId = [_strId substringWithRange:NSMakeRange(0, 4)];
            self.strSmallImage = SmallImageURLString(strSubId, _strId, imgageURL);
            self.strMidiumImage = MidiumImageURLString(strSubId, _strId, imgageURL);
        }
        
        id user = [dic objectForKey:@"user"];
        if ((NSNull* )user != [NSNull null]) {
            self.strAuthor = [user objectForKey:@"login"];
            
        }
    }
    
    return self;
}

- (NSString* )description {
    return [NSString stringWithFormat:@"\n pulishTime = %g,\n id = %@,\n simleCount = %i,\n unhappycount = %i,\n content = %@,\n smallImage = %@,\n midiumImage = %@", _publishTime, _strId, _nSimleCount, _nUnhappleCount, _strContent, _strSmallImage, _strMidiumImage];
}


@end











