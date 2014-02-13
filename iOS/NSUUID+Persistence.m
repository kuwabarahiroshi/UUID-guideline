//
//  NSUUID+Persistence.m
//
//  Copyright (c) 2014 BEENOS. All rights reserved.
//

#import "NSUUID+Persistence.h"

/**
 * identifierForVendorの不具合の影響を受けている端末が返すID
 */
NSString * const kBUGGY_UUID = @"00000000-0000-0000-0000-000000000000";

/**
 * 生成したUUIDを保存する際のキー
 */
NSString * const kUUIDStorageKey = @"kUUIDStorageKey";


@implementation NSUUID (Persistence)

/**
 *
 */
- (NSString *)installationID {
  return [self installationID:NO];
}

/**
 *
 */
- (NSString *)installationID:(BOOL)forVendor {

  // ストレージから読込
  NSString *uuid = [self readFromStorage];

  // 正常に取得できた場合はそれを返す
  if ([self isValid:uuid]) {
    return uuid;
  }

  // 同一アプリベンダー間で可能な限り一貫させたい場合
  if (forVendor) {
    uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
  }

  // 妥当なUUIDが取得できていない場合、NSUUIDで生成
  if (![self isValid:uuid]) {
    uuid = [self UUIDString];
  }

  [self writeToStorage:uuid];

  return uuid;
}

/**
 * @private
 * UUIDが妥当な文字列かどうか判定
 */
- (BOOL)isValid:(NSString *)uuid {
  return ([uuid isKindOfClass:[NSString class]]
    && ![uuid isEqualToString:kBUGGY_UUID]);
}

/**
 * @private
 * ストレージから読込
 */
- (NSString *)readFromStorage {

  // ここでは簡易にNSUserDefaultsを使用
  // ストレージにKeychainを使う場合は下記参考
  // @see https://github.com/soffes/sskeychain

  return [[NSUserDefaults standardUserDefaults] valueForKey:kUUIDStorageKey];
}

/**
 * @private
 * ストレージに保存
 */
- (void)writeToStorage:(NSString *)uuid {

  // ここでは簡易にNSUserDefaultsを使用
  // ストレージにKeychainを使う場合は下記参考
  // @see https://github.com/soffes/sskeychain

  NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
  [ud setValue:uuid forKey:kUUIDStorageKey];
  [ud synchronize];
}

@end
