//
//  KFEmotionView.m
//  ChatViewController
//
//  Created by jack on 14-5-4.
//  Copyright (c) 2014年 appkefu.com. All rights reserved.
//

#import "KFEmotionView.h"

#define SCROLLVIEW_HEIGHT  150.0f
//#define SCROLLVIEW_WIDTH   320.0f

#define PAGESCROLL_HEIGHT   66.0f
#define PAGESCROLL_WIDTH    80.0f

#define EMOTION_LEFT_MARGIN 13.5f
#define EMOTION_TOP_MARGIN  19.0f

#define EMOTION_FACE_WIDTH  30.0f
#define EMOTION_FACE_HEIGHT 30.0f

#define SENDBUTTON_WIDTH    80.0f
#define SENDBUTTON_HEIGHT   40.0f
#define SENDBUTTON_RIGHT_MARGIN 15.0f

/*
 */
@interface KFEmotionFaceView ()

@property (nonatomic, assign) NSInteger m_scrollViewWidth;
@property (nonatomic, assign) NSInteger m_emotionFaceMargin;

@end

@implementation KFEmotionFaceView

@synthesize m_scrollViewWidth,
            m_emotionFaceMargin,
            delegate;

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        m_scrollViewWidth = [[UIScreen mainScreen] bounds].size.width;
        m_emotionFaceMargin = (m_scrollViewWidth - EMOTION_FACE_WIDTH*7)/8;
        
        //self.backgroundColor = [UIColor redColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;

        //横向旋转之后，表情分布需重新调整
        for (int page = 0; page < 5; page++) {
            
            for (int i = 0; i < 3; i++) {
                
                for (int j = 0; j < 7;  j++) {
                    
                    //
                    CGRect frame = CGRectMake(m_scrollViewWidth*page + m_emotionFaceMargin + (EMOTION_FACE_WIDTH + m_emotionFaceMargin)*j,
                                              EMOTION_TOP_MARGIN + (EMOTION_FACE_HEIGHT + EMOTION_TOP_MARGIN)*i,
                                              EMOTION_FACE_WIDTH,
                                              EMOTION_FACE_HEIGHT);
                    
                    UIButton *button = [[UIButton alloc] initWithFrame: frame];
                    [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"Expression_%d", 21*page + i*7 + (j+1)] inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
                    //
                    button.tag = 21*page + i*7 + (j + 1);
                    button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin;
                    [self addSubview:button];
                    
                    //
                    if (i*7 + (j+1) == 21) {
                        
                        [button setBackgroundImage:[UIImage imageNamed:@"DeleteEmoticonBtn_ios7" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
                        [button setBackgroundImage:[UIImage imageNamed:@"DeleteEmoticonBtnHL_ios7" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] forState:UIControlStateHighlighted];
                    }
                    
                    [button addTarget:self action:@selector(emotionFacePressed:) forControlEvents:UIControlEventTouchUpInside];
                }
            }
        }
    }
    
    return self;
}


-(void)emotionFacePressed:(id)sender
{
    
    if ([delegate respondsToSelector:@selector(emotionFaceButtonPressed:)])
    {
        [delegate performSelector:@selector(emotionFaceButtonPressed:) withObject:sender];
    }
    
}


@end



@interface KFEmotionView ()<UIScrollViewDelegate, KFEmotionFaceViewDelegate>

@property (nonatomic, strong) UIView            *topLineView;
@property (nonatomic, strong) UIScrollView      *scrollView;
@property (nonatomic, strong) KFEmotionFaceView *emotionFaceView;
@property (nonatomic, strong) UIPageControl     *pageControl;
@property (nonatomic, strong) UIButton          *sendButton;

@property (nonatomic, assign) NSInteger m_scrollViewWidth;


@end

@implementation KFEmotionView

@synthesize topLineView,
            scrollView,
            emotionFaceView,
            pageControl,
            sendButton,

            m_scrollViewWidth,
            delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        m_scrollViewWidth = [[UIScreen mainScreen] bounds].size.width;
        
        self.backgroundColor = UIColorFromRGB(0XEBEBEB);
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
        
        [self setUpViews];
    }
    return self;
}

-(void)dealloc
{
    topLineView = nil;
    scrollView = nil;
    emotionFaceView = nil;
    pageControl = nil;
    sendButton = nil;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)setUpViews
{
    [self addSubview:[self topLineView]];
    [self addSubview:[self scrollView]];
    [self addSubview:[self pageControl]];
    [self addSubview:[self sendButton]];
}

-(UIView *)topLineView
{
    if (!topLineView) {
        
        topLineView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.bounds.size.width, 0.5f)];
        topLineView.backgroundColor = UIColorFromRGB(0X939698);
        topLineView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
    }
    
    return topLineView;
}

-(UIScrollView *)scrollView
{
    if (!scrollView) {
        
        CGRect scrollViewFrame = CGRectMake(0.0f,
                                  0.0f,
                                  m_scrollViewWidth,
                                  SCROLLVIEW_HEIGHT);
        
        scrollView = [[UIScrollView alloc] initWithFrame: scrollViewFrame];
        scrollView.pagingEnabled = YES;
        scrollView.contentSize = CGSizeMake(m_scrollViewWidth * 5, SCROLLVIEW_HEIGHT);
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.delegate = self;
        scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;

        CGRect faceViewFrame = CGRectMake(0.0f,
                                  0.0f,
                                  m_scrollViewWidth * 5,
                                  SCROLLVIEW_HEIGHT);
        
        KFEmotionFaceView *faceView = [[KFEmotionFaceView alloc] initWithFrame: faceViewFrame];
        faceView.delegate = self;
        
        [scrollView addSubview:faceView];
    }
    
    return scrollView;
}

-(UIPageControl *)pageControl
{
    if (!pageControl) {
        
        pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((m_scrollViewWidth - PAGESCROLL_WIDTH)/2,
                                                                      SCROLLVIEW_HEIGHT,
                                                                      PAGESCROLL_WIDTH,
                                                                      PAGESCROLL_HEIGHT)];
        pageControl.numberOfPages = 5;
        pageControl.currentPage = 0;
        [pageControl setCurrentPageIndicatorTintColor:UIColorFromRGB(0X8B8B8B)];
        [pageControl setPageIndicatorTintColor:UIColorFromRGB(0XBBBBBB)];
        pageControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [pageControl addTarget:self action:@selector(pageControlIndicatorPressed:) forControlEvents:UIControlEventValueChanged];
    }
    
    return pageControl;
}

-(UIButton *)sendButton
{
    if (!sendButton) {
        
        CGRect frame = CGRectMake(m_scrollViewWidth - SENDBUTTON_WIDTH,
                                  SCROLLVIEW_HEIGHT + (PAGESCROLL_HEIGHT - SENDBUTTON_HEIGHT),
                                  SENDBUTTON_WIDTH,
                                  SENDBUTTON_HEIGHT);
        
        sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [sendButton setFrame:frame];
        [sendButton setBackgroundImage:[UIImage imageNamed:@"EmotionsSendBtnGrey_ios7" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        [sendButton setBackgroundImage:[UIImage imageNamed:@"EmotionsSendBtnBlue" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] forState:UIControlStateHighlighted];
        
        [[sendButton titleLabel] setFont:[UIFont systemFontOfSize:15.0f]];
        [sendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [sendButton setTitle:@"发送" forState:UIControlStateNormal];
        
        sendButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin;
        
        [sendButton addTarget:self action:@selector(emotionViewSendButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return sendButton;
}


#pragma mark UIScrollViewDelegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)lscrollView
{
    [pageControl setCurrentPage:lscrollView.contentOffset.x/m_scrollViewWidth];
    [pageControl updateCurrentPageDisplay];
}

-(void)pageControlIndicatorPressed:(id)sender
{
    NSInteger currentIndex = pageControl.currentPage;
    [scrollView scrollRectToVisible:CGRectMake(m_scrollViewWidth*currentIndex, 0, m_scrollViewWidth, SCROLLVIEW_HEIGHT) animated:YES];
}

#pragma mark KFEmotionFaceViewDelegate

-(void)emotionFaceButtonPressed:(UIButton *)sender
{
    if ([delegate respondsToSelector:@selector(emotionFaceButtonPressed:)]) {
        [delegate performSelector:@selector(emotionFaceButtonPressed:) withObject:sender];
    }
}

#pragma mark 

-(void)emotionViewSendButtonPressed:(UIButton *)sender
{
    if ([delegate respondsToSelector:@selector(emotionViewSendButtonPressed:)]) {
        [delegate performSelector:@selector(emotionViewSendButtonPressed:) withObject:sender];
    }
}




@end















