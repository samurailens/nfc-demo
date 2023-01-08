//
//  NFCTagReader.h
//  WXEInkTag
//
//  Created by mac on 2020/7/1.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, EInkSizeType) {
    EInkSizeType154 = 0, // 分辨率(200, 200)黑白红
    EInkSizeType213,     // 分辨率(250, 122)黑白
    EInkSizeType270,     // 分辨率(264, 176)黑白
    EInkSizeType290,     // 分辨率(296, 128)黑白
    EInkSizeType290R,    // 分辨率(296, 128)黑白红
    EInkSizeType420,     // 分辨率(400, 300)黑白
    EInkSizeType420R,    // 分辨率(400, 300)黑白红
    EInkSizeType750,     // 分辨率(800, 480)黑白
    EInkSizeType750HD,   // 分辨率(880, 528)黑白红
};


@interface NFCTagReader : NSObject

/*
 * 使用单例创建
 */
+ (instancetype)shared;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (id)copy NS_UNAVAILABLE;
- (id)mutableCopy NS_UNAVAILABLE;

/*
 * sendImage: 要发送的图片
 * password : 如果有密码需要传入4-15位 如果没有密码可以不传
 * einkSizeType : 屏幕类型
 */
- (void)sendImage:(UIImage *)image password:(nullable NSString *)password einkSizeType:(EInkSizeType)type;

/*
 * 开启密码
 * openPassword : 旧密码
 */
- (void)openPassword:(NSString *)password;

/*
 * 关闭密码
 * closePassword : 旧密码
 */
- (void)closePassword:(NSString *)password;

/*
 * 修改密码
 * changeOldPassword : 旧密码
 * newPassword : 新密码
 */
- (void)changeOldPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword;

/*
 * 获取UID
 */
- (void)getUID;

/*
 * 返回UID
 */
typedef void (^GetUIDSuccessBlock)(NSString *UID);
@property (nonatomic, copy) GetUIDSuccessBlock UIDBlock;


@end

NS_ASSUME_NONNULL_END
