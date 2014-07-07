//
//  TBCitySBMTOPRequest.h
//  iCoupon
//
//  Created by moxin.xt on 14-5-5.
//  Copyright (c) 2014年 Taobao.com. All rights reserved.
//

#if __buildForMTOP__
#import "TBCitySDKRequestModel.h"
#endif

#import "TBCitySBRequest.h"


//#define TBCityRequestCancelErrorCode     @"TBCityRequestCancelErrorCode"

#define kTBCityServiceActionWillStartNotification    @"kTBCityServiceActionWillStartNotification"
#define kTBCityServiceActionDidFinishNotification    @"kTBCityServiceActionDidFinishNotification"
#define kTBCityNotificationUserAuthenicationFailed   @"kTBCityNotificationUserAuthenicationFailed"
#define kTBCityServiceActionWillStartNotification    @"kTBCityServiceActionWillStartNotification"
#define kTBCityServiceActionDidFinishNotification    @"kTBCityServiceActionDidFinishNotification"

#define kTBMainClientNotificationUserLoggedIn    @"TBCity_MAIN_CLIENT_NOTIFICATION_USER_LOGGED_IN"
#define kTBMainClientNotificationUserLoggedOut   @"TBCity_MAIN_CLIENT_NOTIFICATION_USER_LOGGED_OUT"
#define kTBMainClientNotificationUserGiveUpLogin @"TBCity_MAIN_CLIENT_NOTIFICATION_USER_GIVE_UP_LOGIN"

/**
 *  适配层：SBMVC的第三方MTOP request
 *
 *  SBMVC => 1.1
 */

#if __buildForMTOP__
@interface TBCitySBMTOPRequest : TBCitySDKRequestModel<TBCitySBRequest>
#else
@interface TBCitySBMTOPRequest : NSObject
#endif

@end
