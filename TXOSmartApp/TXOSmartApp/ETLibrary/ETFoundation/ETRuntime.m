//
//  ETRuntime.m
//  ETShopping
//
//  Created by moxin.xt on 13-3-21.
//  Copyright (c) 2013年 etao. All rights reserved.
//

#import "ETRuntime.h"

#import <objc/runtime.h>

///////////////////////////////////////////////////////////////////////////////////////////////////
NSString* getClassName(Class cls)
{
    NSString* ret = @"";
    
    const char* name = class_getName(cls);
    
    if (name) {
        
        ret = [NSString stringWithUTF8String:name];
    }
    
    return ret;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
NSArray* getPropertyNamesOfClass(Class cls)
{
    NSMutableArray* ret = [NSMutableArray new];
    
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(cls, &outCount);
    
    for(i = 0; i < outCount; i++)
    {
        objc_property_t property = properties[i];
        const char *propName = property_getName(property);
        
        if(propName)
        {
            NSString *propertyName = [NSString stringWithUTF8String:propName];
            
            
            [ret addObject:propertyName];
        }
    }
    free(properties);
    
    return [ret copy];

}

///////////////////////////////////////////////////////////////////////////////////////////////////
NSArray* getMethodNamesOfClass(Class cls)
{
    NSMutableArray* ret = [NSMutableArray new];
    
    unsigned int count = 0;
    
    Method* method = class_copyMethodList(cls, &count);
    
    for (int i=0; i<count; i++)
    {
        
        SEL sel = method_getName(method[i]);
        
        const char* name = sel_getName(sel);
        
        if (name) {
            
            NSString* methodName = [NSString stringWithUTF8String:name];
            
            [ret addObject:methodName];
        }
    }
    
    return ret;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
id getClassPropertyByName(Class cls, id clsInstance , const char* propertyName)
{
    Ivar var = class_getInstanceVariable(cls, propertyName);
    return object_getIvar(clsInstance, var);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
void NISwapInstanceMethods(Class cls, SEL originalSel, SEL newSel) {
    Method originalMethod = class_getInstanceMethod(cls, originalSel);
    Method newMethod = class_getInstanceMethod(cls, newSel);
    method_exchangeImplementations(originalMethod, newMethod);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
void NISwapClassMethods(Class cls, SEL originalSel, SEL newSel) {
    Method originalMethod = class_getClassMethod(cls, originalSel);
    Method newMethod = class_getClassMethod(cls, newSel);
    method_exchangeImplementations(originalMethod, newMethod);
}