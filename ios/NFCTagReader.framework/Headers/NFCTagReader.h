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
    EInkSizeType290,     // 分辨率(296, 128)黑白
    EInkSizeType420,     // 分辨率(400, 300)黑白
    EInkSizeType420R,    // 分辨率(400, 300)黑白红
    EInkSizeType750,     // 分辨率(800, 480)黑白
    EInkSizeType750HD,   // 分辨率(880, 528)黑白红
};


@interface NFCTagReader : NSObject

+ (instancetype)sharedSingleton;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (id)copy NS_UNAVAILABLE;
- (id)mutableCopy NS_UNAVAILABLE;

/*
 * image: 要发送的图片
 * type : 屏幕类型
 */
- (void)sendImage:(UIImage *)image einkSizeType:(EInkSizeType)type;


@end

NS_ASSUME_NONNULL_END
