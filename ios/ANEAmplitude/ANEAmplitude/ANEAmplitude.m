/*
 * The MIT License (MIT)
 *
 * Copyright (c) 2017 Digital Strawberry LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#import "FlashRuntimeExtensions.h"
#import "FRETypeUtils.h"
#import "Amplitude.h"
#import "AMPConstants.h"

void ANEAmplitude_FREGetDictionaryFromArray(FREObject array, NSMutableDictionary *dictionary)
{
    uint32_t arrayLength = 0;
    uint32_t totalElements = 0;
    
    if(FREGetArrayLength(array, &arrayLength) != FRE_OK)
    {
        return;
    }
    totalElements = arrayLength / 2;
    
    if(totalElements == 0)
    {
        return;
    }
    
    uint32_t i;
    NSString *key;
    NSString *value;
    FREObject element;
        
    for(i = 0; i < totalElements; i++)
    {
        if(FREGetArrayElementAt(array, i * 2, &element) != FRE_OK)
        {
            continue;
        }
        if(FREGetObjectAsString(element, &key) != FRE_OK)
        {
            continue;
        }
            
        if(FREGetArrayElementAt(array, (i * 2) + 1, &element) != FRE_OK)
        {
            continue;
        }
        if(FREGetObjectAsString(element, &value) != FRE_OK)
        {
            continue;
        }
            
        [dictionary setValue:value forKey:key];
    }
}



DEFINE_ANE_FUNCTION(initialize)
{
    NSString *apiKey = nil;
    NSString *userId = nil;
    
    if(FREGetObjectAsString(argv[0], &apiKey) != FRE_OK)
    {
        return NULL;
    }
    
    // Get user id if provided
    if(argv[1] != nil)
    {
        if(FREGetObjectAsString(argv[1], &userId) != FRE_OK)
        {
            return NULL;
        }
    }
    // Enable session auto tracking if requested (before initializing Amplitude)
    uint32_t autoTrackSession = 0;
    FREGetObjectAsBool( argv[2], &autoTrackSession );
    if(autoTrackSession > 0)
    {
        [[Amplitude instance] setTrackingSessionEvents:YES];
    }
    
    // Initialize with user id
    if(userId != nil && ![userId isEqualToString:@""])
    {
        [[Amplitude instance] initializeApiKey:apiKey userId:userId];
    }
    // No user id
    else
    {
        [[Amplitude instance] initializeApiKey:apiKey];
    }
    
    return NULL;
}


DEFINE_ANE_FUNCTION(setUserId)
{
    NSString *userId = nil;
    if(FREGetObjectAsString(argv[0], &userId) == FRE_OK)
    {
        [[Amplitude instance] setUserId:userId];
    }
        
    return NULL;
}


DEFINE_ANE_FUNCTION(logEvent)
{
    NSString *eventName = nil;
    
    if(FREGetObjectAsString(argv[0], &eventName) != FRE_OK)
    {
        return NULL;
    }
    
    // Event with parameters
    if(argc == 2)
    {
        FREObject paramArray = argv[1];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        ANEAmplitude_FREGetDictionaryFromArray(paramArray, parameters);
        
        [[Amplitude instance] logEvent:eventName withEventProperties:parameters];
    }
    // No parameters
    else
    {
        [[Amplitude instance] logEvent:eventName];
    }
    
    return NULL;
}


DEFINE_ANE_FUNCTION(setUserProperties)
{
    FREObject paramArray = argv[0];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    ANEAmplitude_FREGetDictionaryFromArray(paramArray, parameters);
    
    [[Amplitude instance] setUserProperties:parameters];
    
    return NULL;
}


DEFINE_ANE_FUNCTION(logRevenue)
{
    NSString *productIdentifier = nil;
    int32_t quantity = 0;
    double price = 0;
    
    if(FREGetObjectAsString(argv[0], &productIdentifier) != FRE_OK ||
       FREGetObjectAsInt32(argv[1], &quantity) != FRE_OK ||
       FREGetObjectAsDouble(argv[2], &price) != FRE_OK)
    {
        return NULL;
    }
    
    NSInteger ns_quanity = (NSInteger) quantity;
    NSNumber *ns_price = [NSNumber numberWithDouble:price];
    
    AMPRevenue *revenue = [AMPRevenue revenue];
    [revenue setProductIdentifier:productIdentifier];
    [revenue setQuantity:ns_quanity];
    [revenue setPrice:ns_price];
    
    // We have receipt data
    if(argc == 4)
    {
        NSString *receipt = nil;
        if(FREGetObjectAsString(argv[3], &receipt) == FRE_OK)
        {
            NSData* data = [receipt dataUsingEncoding:NSUTF8StringEncoding];
            [revenue setReceipt:data];
        }
    }
    
    [[Amplitude instance] logRevenueV2:revenue];
    
    return NULL;
}


DEFINE_ANE_FUNCTION(getDeviceId)
{
    NSString *deviceId = [[Amplitude instance] getDeviceId];
    if(deviceId == nil)
    {
        return nil;
    }
    
    FREObject returnObject = nil;
    
    FRENewObjectFromString(deviceId, &returnObject);
    
    return returnObject;
}


DEFINE_ANE_FUNCTION(useAdvertisingIdForDeviceId)
{
    [[Amplitude instance] useAdvertisingIdForDeviceId];
    
    return NULL;
}


void ANEAmplitudeContextInitializer(void* extData, const uint8_t* ctxType, FREContext context, uint32_t* numFunctions, const FRENamedFunction** functions)
{
    // Define the functions that can be called from AS
    static FRENamedFunction functionMap[] =
    {
        MAP_FUNCTION(initialize, NULL),
        MAP_FUNCTION(setUserId, NULL),
        MAP_FUNCTION(logEvent, NULL),
        MAP_FUNCTION(setUserProperties, NULL),
        MAP_FUNCTION(logRevenue, NULL),
        MAP_FUNCTION(getDeviceId, NULL),
        MAP_FUNCTION(useAdvertisingIdForDeviceId, NULL)
    };
    
    *numFunctions = sizeof(functionMap) / sizeof(FRENamedFunction);
    *functions = functionMap;
}


void ANEAmplitudeContextFinalizer(FREContext context)
{
    
}


void ANEAmplitudeInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet,
                              FREContextFinalizer* ctxFinalizerToSet)
{
    *extDataToSet = NULL;
    *ctxInitializerToSet = &ANEAmplitudeContextInitializer;
    *ctxFinalizerToSet = &ANEAmplitudeContextFinalizer;
}


void ANEAmplitudeFinalizer(void* extData)
{
    
}
