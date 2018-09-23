//
//  KFDSMsgViewCell.m
//  feedback
//
//  Created by 萝卜丝·Bytedesk.com on 2017/2/18.
//  Copyright © 2017年 萝卜丝·Bytedesk.com. All rights reserved.
//

#import "KFDSMsgViewCell.h"
#import "KFDSBadgeView.h"
#import "UIView+KFDSUI.h"
#import "KFDSUConstants.h"

#import "KFDSMsgBaseContentView.h"
#import "KFDSMsgTextContentView.h"
#import "KFDSMsgImageContentView.h"
#import "KFDSMsgVoiceContentView.h"

@import AFNetworking;
//#import <AFNetworking/UIImageView+AFNetworking.h>

#define AVATAR_WIDTH_HEIGHT       40.0f
#define TIMESTAMp_HEIGHT          20.0f

@interface KFDSMsgViewCell ()<KFDSMsgBaseContentViewDelegate> {
    UILongPressGestureRecognizer *_longPressGesture;
}

@end

@implementation KFDSMsgViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        [self setQmui_shouldShowDebugColor:YES];
        [self addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGesturePress:)]];
    }
    return self;
}

- (void)initWithMessageModel:(BDMessageModel *)messageModel {
    _messageModel = messageModel;
    
    [self addSubviews];

    [self setNeedsLayout];
}

//- (void)awakeFromNib {
//    [super awakeFromNib];
//    // Initialization code
//}
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//    // Configure the view for the selected state
//}
//
//- (void)dealloc {
////    [self removeGestureRecognizer:_longPressGesture];
//}

- (BOOL)canBecomeFirstResponder  {
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
//    NSLog(@"%s", __PRETTY_FUNCTION__);
    if (action == @selector(mycopy:)) {
        return YES;
    }
    else if (action == @selector(mydelete:)) {
        return YES;
    }
    
    return NO;
}

- (void)mycopy:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if ([_messageModel.type isEqualToString:BD_MESSAGE_TYPE_TEXT]) {
        [[UIPasteboard generalPasteboard] setString:_messageModel.content];
    } else if ([_messageModel.type isEqualToString:BD_MESSAGE_TYPE_IMAGE]){
        if (_messageModel.image_url) {
            [[UIPasteboard generalPasteboard] setString:_messageModel.image_url];
        }
        else if (_messageModel.pic_url){
            [[UIPasteboard generalPasteboard] setString:_messageModel.pic_url];
        }
    }
    // TODO：其他类型消息记录
    
    //
    [self resignFirstResponder];
    _bubbleView.highlighted = NO;
}

-(void)mydelete:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if ([_delegate respondsToSelector:@selector(removeCellWith:)]) {
        [_delegate removeCellWith:self.tag];
    }
}

- (void)addSubviews {
//    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if (self.timestampLabel) {
        [self.timestampLabel removeFromSuperview];
        self.timestampLabel = nil;
    }
    if (self.avatarImageView) {
        [self.avatarImageView removeFromSuperview];
        self.avatarImageView = nil;
    }
    if (self.nicknameLabel) {
        [self.nicknameLabel removeFromSuperview];
        self.nicknameLabel = nil;
    }
    if (self.bubbleView) {
        [self.bubbleView removeFromSuperview];
        self.bubbleView = nil;
    }
    if (self.sendingStatusActivityIndicator) {
        [self.sendingStatusActivityIndicator removeFromSuperview];
        self.sendingStatusActivityIndicator = nil;
    }
    if (self.resendButton) {
        [self.resendButton removeFromSuperview];
        self.resendButton = nil;
    }
    if (self.audioUnplayedIcon) {
        [self.audioUnplayedIcon removeFromSuperview];
        self.audioUnplayedIcon = nil;
    }
    if (self.readLabel) {
        [self.readLabel removeFromSuperview];
        self.readLabel = nil;
    }
    
    if ([_messageModel.type isEqualToString:BD_MESSAGE_TYPE_TEXT]) {
        _bubbleView = [[KFDSMsgTextContentView alloc] initMessageContentView];
    } else if ([_messageModel.type isEqualToString:BD_MESSAGE_TYPE_IMAGE]) {
        _bubbleView = [[KFDSMsgImageContentView alloc] initMessageContentView];
    } else if ([_messageModel.type isEqualToString:BD_MESSAGE_TYPE_VOICE]) {
        _bubbleView = [[KFDSMsgVoiceContentView  alloc] initMessageContentView];
    } else {
        // 暂未处理的类型，全部当做text类型处理
        _bubbleView = [[KFDSMsgTextContentView alloc] initMessageContentView];
    }
    //
    _bubbleView.delegate = self;
    
    [self.contentView addSubview:self.timestampLabel];
    [self.contentView addSubview:self.avatarImageView];
    [self.contentView addSubview:self.nicknameLabel];
    [self.contentView addSubview:self.bubbleView];
    [self.contentView addSubview:self.sendingStatusActivityIndicator];
    [self.contentView addSubview:self.resendButton];
    [self.contentView addSubview:self.audioUnplayedIcon];
    [self.contentView addSubview:self.readLabel];
}


- (QMUILabel *)timestampLabel {
    if (!_timestampLabel) {
        _timestampLabel = [QMUILabel new];
        _timestampLabel.textColor = [UIColor grayColor];
        _timestampLabel.font = [UIFont systemFontOfSize:11.0f];
    }
    return _timestampLabel;
}

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.layer.cornerRadius = 5;
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.userInteractionEnabled = YES;
        //
        UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleAvatarClicked:)];
        [singleTap setNumberOfTapsRequired:1];
        [_avatarImageView addGestureRecognizer:singleTap];
    }
    return _avatarImageView;
}

- (QMUILabel *)nicknameLabel {
    if (!_nicknameLabel) {
        _nicknameLabel = [QMUILabel new];
        _nicknameLabel.textColor = [UIColor grayColor];
        _nicknameLabel.font = [UIFont systemFontOfSize:11.0f];
        _nicknameLabel.backgroundColor = [UIColor clearColor];
    }
    return _nicknameLabel;
}

//- (KFDSMsgBaseContentView *)bubbleView {
//    if (!_bubbleView) {
//        _bubbleView = [[KFDSMsgBaseContentView alloc] init];
//    }
//    return _bubbleView;
//}

- (UIActivityIndicatorView *)sendingStatusActivityIndicator {
    if (!_sendingStatusActivityIndicator) {
        _sendingStatusActivityIndicator = [UIActivityIndicatorView new];
    }
    return _sendingStatusActivityIndicator;
}

- (QMUIButton *)resendButton {
    if (!_resendButton) {
        _resendButton = [QMUIButton new];
    }
    return _resendButton;
}

- (KFDSBadgeView *)audioUnplayedIcon {
    if (!_audioUnplayedIcon) {
        _audioUnplayedIcon = [KFDSBadgeView new];
    }
    return _audioUnplayedIcon;
}

- (QMUILabel *)readLabel {
    if (!_readLabel) {
        _readLabel = [QMUILabel new];
    }
    return _readLabel;
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    [self layoutTimestampLabel];
    [self layoutAvatarImageView];
    [self layoutNicknameLabel];
    [self layoutContentView];
    [self layoutSendingStatusActivityIndicator];
    [self layoutResendButton];
    [self layoutAudioUnplayedIcon];
    [self layoutReadLabel];
}


- (void)layoutTimestampLabel {
    //
    NSString *timestampString = [BDUtils getOptimizedTimestamp:_messageModel.createdAt];
    CGSize timestampSize = [timestampString sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.0f]}];
    _timestampLabel.frame = CGRectMake((self.bounds.size.width - timestampSize.width - 10)/2,
                                       0.5f, timestampSize.width + 10.0f, timestampSize.height+1);
    [_timestampLabel setText:timestampString];
}

- (void)layoutAvatarImageView {
//    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if ([_messageModel isSend]) {
        _avatarImageView.frame = CGRectMake(KFDSScreen.width - 50, TIMESTAMp_HEIGHT, AVATAR_WIDTH_HEIGHT, AVATAR_WIDTH_HEIGHT);
    }
    else {
        _avatarImageView.frame = CGRectMake(5, TIMESTAMp_HEIGHT, AVATAR_WIDTH_HEIGHT, AVATAR_WIDTH_HEIGHT);
    }
    [_avatarImageView setImageWithURL:[NSURL URLWithString:_messageModel.avatar] placeholderImage:[UIImage imageNamed:@"avatar"]];
}

- (void)layoutNicknameLabel {
    
    if ([_messageModel isSend]) {
        _nicknameLabel.frame = CGRectZero;
    }
    else {
        _nicknameLabel.frame = CGRectMake(50, TIMESTAMp_HEIGHT, 100, 20);
        _nicknameLabel.text = _messageModel.nickname;
    }
}


- (void)layoutContentView {
    //
    [_bubbleView refresh:_messageModel];
    [_bubbleView setNeedsLayout];
}

- (void)layoutSendingStatusActivityIndicator {
    
}

- (void)layoutResendButton {
    
}

- (void)layoutAudioUnplayedIcon {
    
}

- (void)layoutReadLabel {
    
}

#pragma mark - UILongPressGestureRecognizer

- (void)longGesturePress:(UIGestureRecognizer*)gestureRecognizer
{
//    if (gestureRecognizer.state != UIGestureRecognizerStateBegan || ![self becomeFirstResponder]) {
//        return;
//    }

    if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]] &&
        gestureRecognizer.state == UIGestureRecognizerStateBegan) {
    
        NSLog(@"%s", __PRETTY_FUNCTION__);
        
        [self becomeFirstResponder];//报错
        _bubbleView.highlighted = YES;
//        
////        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMenuWillShowNotification:) name:UIMenuControllerWillShowMenuNotification object:nil];
//
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setTargetRect:_bubbleView.frame inView:_bubbleView.superview];

        //添加你要自定义的MenuItem
        UIMenuItem *item = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(mycopy:)];
        UIMenuItem *item2 = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(mydelete:)];
        menu.menuItems = [NSArray arrayWithObjects:item,item2,nil];
        [menu setMenuVisible:YES animated:YES];
        
        if ([menu isMenuVisible]) {
            NSLog(@"menu visible");
        }
        else {
            NSLog(@"menu invisible");
        }
        
    }
}

#pragma mark - Notifications

- (void)handleMenuWillHideNotification:(NSNotification *)notification {
        NSLog(@"%s", __PRETTY_FUNCTION__);
    
        _bubbleView.highlighted = NO;
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIMenuControllerWillHideMenuNotification object:nil];
}

- (void)handleMenuWillShowNotification:(NSNotification *)notification {
        NSLog(@"%s", __PRETTY_FUNCTION__);
    
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIMenuControllerWillShowMenuNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMenuWillHideNotification:) name:UIMenuControllerWillHideMenuNotification object:nil];
}


- (void)handleAvatarClicked:(UIGestureRecognizer *)recognizer {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if ([_delegate respondsToSelector:@selector(avatarClicked:)]) {
        [_delegate avatarClicked:_messageModel];
    }
}

#pragma mark - KFDSMsgBaseContentViewDelegate

// TODO: 点击客服/访客头像，显示其相关信息

// TODO: text点击超链接

// TODO: 长按复制、删除消息

// TODO: 打开放大图片
- (void) imageViewClicked:(UIImageView *)imageView {
//    NSLog(@"%s, %@", __PRETTY_FUNCTION__, imageUrl);
    
    if ([_delegate respondsToSelector:@selector(imageViewClicked:)]) {
        [_delegate imageViewClicked:imageView];
    }
}


@end











