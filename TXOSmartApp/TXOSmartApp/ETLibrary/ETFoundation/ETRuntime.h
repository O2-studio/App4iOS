//
//  ETRuntime.h
//  ETShopping
//
//  Created by moxin.xt on 13-3-21.
//  Copyright (c) 2013年 etao. All rights reserved.
//

#import <Foundation/Foundation.h>

//
/*
 * C method
 **/
#if defined __cplusplus
extern "C" {
#endif
    
    /**
     获取类名
     */
    NSString* getClassName(Class cls);
    /**
     获得成员变量名称数组
     */
    NSArray* getPropertyNamesOfClass(Class cls);
    /**
     获得成员方法名称数组
     */
    NSArray* getMethodNamesOfClass(Class cls);
    /**
     获得成员变量
     */
    id getClassPropertyByName(Class cls, id clsInstance , const char* propertyName);
    /**
     修改成员方法
     */
    void ETSwapInstanceMethods(Class cls, SEL originalSel, SEL newSel);
    /**
     修改类方法
     */
    void ETSwapClassMethods(Class cls, SEL originalSel, SEL newSel);

#if defined __cplusplus
};
#endif

