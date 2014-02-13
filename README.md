UUID-guideline
==============

## 前置き: UUIDとUDID
  - **UUID**

    生成する度にユニークなID

  - **UDID**

    端末ごとにユニークなID


iOSではiOS5以降でUDIDは非推奨APIとなり、iOS7以降ではAPI自体が削除されている。
*「複数のアプリ間で共通して、端末を一意に識別可能な値」* はアプリ開発者には提供されない流れとなっている。

AndroidにおいてはUDIDに準じる値はいくつか取得可能であるが、それぞれに長所・短所がある。

このため、いずれのプラットフォームにおいても、端末を永続的に特定することに依存したアプリ設計は避け、生成したUUIDを一定期間（例えば、アプリがインストールされている間）保持する方式が推奨される。

## 目次

1. [iOSにおけるID生成方式](#iOS)

2. [AndroidにおけるID生成方式](#android)

3. [BEENOS推奨コード](#beenos%E6%8E%A8%E5%A5%A8%E3%82%B3%E3%83%BC%E3%83%89)

## <a id="iOS">iOSにおけるID生成方式</a>


### 1. `CFUUID`

#### 生成方法

```objective-c
CFUUIDRef cfuuid = CFUUIDCreate(kCFAllocatorDefault);
NSString *cfuuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, cfuuid));
```

#### pros
  * iOS2以降で利用可能

#### cons
  * C言語スタイルのAPI
  * 永続化する場合はNSUserDefaults, Keychain, Pastboardなどに保存する


### 2. `NSUUID`

#### 生成方法

```objective-c
NSString *uuid = [[NSUUID UUID] UUIDString];
```

#### pros
  * 機能的にはCFUUIDと同等
  * Objective-CスタイルのAPI

#### cons
  * iOS6以降で利用可能


### 3. `ASIdentifierManager#advertisingIdentifier`

#### 生成方法

```objective-c
NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
```

#### pros
  * 複数アプリで一貫した値を取得できる
  * リセットしない限り一貫した値を取得できる

#### cons
  * iOS6以降で利用可能
  * AdSupport.frameworkが必要
  * 右記操作により、リセットされることもある
    `設定 > プライバシー > 広告 > Advertising Identifierをリセット`

#### 備考
iOSの設定で
`プライバシー > 広告 > 追跡型広告を制限`
という項目があるが、これをONにしてもアプリからAdvertising Identifierが取得できなくなるわけではない。
この設定を尊重するかどうかはアプリ開発者に委ねられている。
http://bit.ly/1eMf1xq

### 4. `UIDevice#identifierForVendor`

#### 生成方法

```objective-c
NSString *idForVendor = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
```

#### pros
  * 同一アプリベンダー内で一貫した値を取得できる

#### cons
  * iOS6以降で利用可能
  * アプリ再インストールによりリセットされる（同一ベンダーのアプリが他に無かった場合）
  * 一部の端末で同一の値が返ってくる [参照](http://stackoverflow.com/questions/12605257/the-advertisingidentifier-and-identifierforvendor-return-00000000-0000-0000-000)

### 5. `UDID`
  iOS5以降で非推奨のため説明割愛

### 6. `OpenUDID`
  Appleのドキュメントで保証されたAPIではないので説明割愛（今後利用できなくなる可能性があるため）


## <a id="android">AndroidにおけるID生成方式</a>

[参照](http://android-developers.blogspot.jp/2011/03/identifying-app-installations.html)

### 1. `IMEI, MEID, or ESN`

#### 取得方法

```java
TelephonyManager.getDeviceId()
```

#### pros
  * 工場出荷状態にリセットしたとしても一貫した値を取得できる

#### cons
  * 電話以外のデバイスでは利用できない
  * READ_PHONE_STATEパーミッションが必要（嫌がられやすい権限のひとつ）
  * 一部の端末でバグが確認されている（0や*などを返す）

### 2. `Mac Address`
WiFiまたはBlueToothをOFFにしている場合は取得できないため非推奨

### 3. `Serial Number`

#### 取得方法

```java
android.os.Build.SERIAL
```

#### cons
  * API>=9 (Android 2.3以上) で利用可能

### 4. `ANDROID_ID`

#### 取得方法

```java
Settings.Secure.ANDROID_ID
```

#### pros
  * バグのない端末では概ねUDIDとして機能する
#### cons
  * API8 (Android 2.2) では信頼できない
  * root化されたAndroidでは値を任意に変更できる
  * 一部のベンダーの端末で全て同じ値([9774d56d682e549c](http://www.google.com/search?sourceid=chrome&ie=UTF-8&q=9774d56d682e549c))が返ってくる
  * 工場出荷状態にリセットしたらANDROID_IDもリセットされる

## BEENOS推奨コード

  1. iOS
    [iOS/NSUUID+Persistence.h](iOS/NSUUID+Persistence.h)
    [iOS/NSUUID+Persistence.m](iOS/NSUUID+Persistence.m)

  2. Android
    [android/UIID.java](android/UIID.java)
