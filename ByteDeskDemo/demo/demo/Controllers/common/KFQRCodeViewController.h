//
//  KFQRCodeViewController.h
//  demo
//
//  Created by 宁金鹏 on 2019/3/10.
//  Copyright © 2019 KeFuDaShi. All rights reserved.
//

#import <QMUIKit/QMUIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KFQRCodeViewController : QMUICommonTableViewController

- (void)initWithUid:(NSString *)uid;

- (void)initWithGid:(NSString *)gid;

@end

NS_ASSUME_NONNULL_END
