//
//  GRMarcos.h
//  Grindr
//
//  Created by mobi on 16/2/16.
//  Copyright © 2016年 mobimagic. All rights reserved.
//

#ifndef GRMacros_h
#define GRMacros_h

#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif

#define WEAKREF(ttttt) __weak __typeof__ (ttttt) w##ttttt = ttttt;
#define STRONGREF(ttttt) __strong __typeof__ (ttttt) s##ttttt = ttttt;

#pragma mark - common

#define UIColorFromRGBWithAlpha(rgbValue,a) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

FOUNDATION_EXPORT NSString * const Facebook;
FOUNDATION_EXPORT NSString * const Twitter;
FOUNDATION_EXPORT NSString * const Instagram;

FOUNDATION_EXPORT NSString * const kGetSecurityCodeKey;
FOUNDATION_EXPORT NSString * const kGrindrXtraAppStroeUrl;

//#define IS_GRDEBUG  1

FOUNDATION_EXPORT NSString   *const kGRHostPrimus;
FOUNDATION_EXPORT NSString   *const kGRHostCdns;
FOUNDATION_EXPORT NSString   *const kGRHostMain;
FOUNDATION_EXPORT NSString   *const kGRHostUpload;
FOUNDATION_EXPORT NSString   *const kGRDomainChat;
FOUNDATION_EXPORT NSString   *const kGRXmppChat;
FOUNDATION_EXPORT NSString   *const kGRLoginService;
FOUNDATION_EXPORT NSString   *const kGRImageCdn;

#endif /* GRMarcos_h */
