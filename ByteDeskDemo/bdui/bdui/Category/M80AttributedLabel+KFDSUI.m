//
//  M80AttributedLabel+FeedBack.m
//  feedback
//
//  Created by 萝卜丝·Bytedesk.com on 2017/2/24.
//  Copyright © 2017年 萝卜丝·Bytedesk.com. All rights reserved.
//

#import "M80AttributedLabel+KFDSUI.h"
#import "KFDSInputEmotionManager.h"
#import "KFDSInputEmotionParser.h"

@implementation M80AttributedLabel (KFDSUI)

- (void)bdui_setText:(NSString *)text {
    
    [self setText:@""];
    NSArray *tokens = [[KFDSInputEmotionParser currentParser] tokens:text];
    for (KFDSInputTextToken *token in tokens)
    {
        if (token.type == KFDSInputTokenTypeEmoticon)
        {
            KFDSInputEmotion *emoticon = [[KFDSInputEmotionManager sharedManager] emotionByText:token.text];
            NSLog(@"emotion text:%@  image:%@", token.text, emoticon.filename);
            
            if (emoticon) {
                UIImage *image = [UIImage imageNamed:emoticon.filename inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil];
//                UIImage *image = [UIImage imageNamed:emoticon.filename];
                if (image)
                {
                    NSLog(@"%s append image", __PRETTY_FUNCTION__);
                    [self appendImage:image
                              maxSize:CGSizeMake(18, 18)
                               margin:UIEdgeInsetsZero
                            alignment:M80ImageAlignmentCenter];
                }
                else {
                    NSLog(@"%s, image null", __PRETTY_FUNCTION__);
                    NSString *text = token.text;
                    [self appendText:text];
                }
            }
        }
        else
        {
            NSString *text = token.text;
            [self appendText:text];
        }
    }
}

@end