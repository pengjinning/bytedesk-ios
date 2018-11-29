//
//  KFDSInputEmotionParser.h
//  feedback
//
//  Created by 萝卜丝 · bytedesk.com on 2018/2/22.
//  Copyright © 2018年 萝卜丝 · bytedesk.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger
{
    KFDSInputTokenTypeText,
    KFDSInputTokenTypeEmoticon,
    
} KFDSInputTokenType;

@interface KFDSInputTextToken : NSObject

@property (nonatomic,copy)      NSString    *text;

@property (nonatomic,assign)    KFDSInputTokenType   type;

@end


@interface KFDSInputEmotionParser : NSObject

+ (instancetype)currentParser;

- (NSArray *)tokens:(NSString *)text;

@end
