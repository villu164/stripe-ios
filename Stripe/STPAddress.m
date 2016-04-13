//
//  STPAddress.m
//  Stripe
//
//  Created by Ben Guo on 4/13/16.
//  Copyright © 2016 Stripe, Inc. All rights reserved.
//

#import "STPAddress.h"
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"

@implementation STPAddress

- (instancetype)initWithABRecord:(ABRecordRef)record {
    self = [super init];
    if (self) {
        NSString *firstName = (__bridge_transfer NSString*)ABRecordCopyValue(record, kABPersonFirstNameProperty);
        NSString *lastName = (__bridge_transfer NSString*)ABRecordCopyValue(record, kABPersonLastNameProperty);
        NSString *first = firstName ?: @"";
        NSString *last = lastName ?: @"";
        _name = [@[first, last] componentsJoinedByString:@" "];
        _email = (__bridge_transfer NSString*)ABRecordCopyValue(record, kABPersonEmailProperty);
        _phone = (__bridge_transfer NSString*)ABRecordCopyValue(record, kABPersonPhoneProperty);

        ABMultiValueRef addressValues = ABRecordCopyValue(record, kABPersonAddressProperty);
        if (addressValues != NULL) {
            if (ABMultiValueGetCount(addressValues) > 0) {
                CFDictionaryRef dict = ABMultiValueCopyValueAtIndex(addressValues, 0);
                NSString *street = CFDictionaryGetValue(dict, kABPersonAddressStreetKey);
                if (street) {
                    _street = street;
                }
                NSString *city = CFDictionaryGetValue(dict, kABPersonAddressCityKey);
                if (city) {
                    _city = city;
                }
                NSString *state = CFDictionaryGetValue(dict, kABPersonAddressStateKey);
                if (state) {
                    _state = state;
                }
                NSString *zip = CFDictionaryGetValue(dict, kABPersonAddressZIPKey);
                if (zip) {
                    _postalCode = zip;
                }
                NSString *country = CFDictionaryGetValue(dict, kABPersonAddressCountryKey);
                if (country) {
                    _country = country;
                }
                CFRelease(dict);
            }
            CFRelease(addressValues);
        }
    }
    return self;
}

@end

#pragma clang diagnostic pop
