//
//  KFDSUIApis.h
//  bdui
//
//  Created by 萝卜丝 on 2018/7/15.
//  Copyright © 2018年 Bytedesk.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <bytedesk-core/bdcore.h>

@interface BDUIApis : NSObject

+ (BDUIApis *)sharedInstance;

//- (void) connect;
//
//- (void) connectWithUsername:(NSString *)username withPassword:(NSString *)password;


#pragma mark - 访客端接口


+ (void)visitorPushChat:(UINavigationController *)navigationController
                    uId:(NSString *)uId
                    wId:(NSString *)wId
              withTitle:(NSString *)title;


+ (void)visitorPresentChat:(UINavigationController *)navigationController
                       uId:(NSString *)uId
                       wId:(NSString *)wId
              withTitle:(NSString *)title;



#pragma mark - 客服端接口

+ (void)agentPushChat:(UINavigationController *)navigationController
       withThreadModel:(BDThreadModel *)threadModel;

+ (void)agentPresentChat:(UINavigationController *)navigationController
      withThreadModel:(BDThreadModel *)threadModel;

+ (void)agentPushChat:(UINavigationController *)navigationController
      withContactModel:(BDContactModel *)contactModel;

+ (void)agentPresentChat:(UINavigationController *)navigationController
      withContactModel:(BDContactModel *)contactModel;

+ (void)agentPushChat:(UINavigationController *)navigationController
      withGroupModel:(BDGroupModel *)groupModel;

+ (void)agentPresentChat:(UINavigationController *)navigationController
      withGroupModel:(BDGroupModel *)groupModel;




#pragma mark - 公共接口




@end






