//
//  NSUUID+Persistence.h
//
//  Copyright (c) 2014 BEENOS. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * UUIDをインストール毎に一貫させるためのカテゴリー
 *
 * iOS5以下をサポートする場合下記ライブラリなどで補う
 * @see https://github.com/0xced/NSUUID
 */
@interface NSUUID (Persistence)

/**
 * インストール毎にユニークなIDを返す
 */
- (NSString *)installationID;

/**
 * 可能な限りidentifierForVendorを利用しユニークなIDを返す
 *
 * 同一アプリベンダーのアプリがひとつでも残っている間は一貫したIDを返す。
 *
 * ただし、identifierForVendorのバグの影響を受けている
 * 端末の場合は個別のアプリインストール毎にユニークな値となる
 *
 * @see http://bit.ly/1lceynP
 * @see http://bit.ly/1kDCapJ
 * @see http://bit.ly/1lceB3b
 */
- (NSString *)installationID:(BOOL)forVendor;

@end
