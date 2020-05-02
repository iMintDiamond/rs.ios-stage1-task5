#import "Converter.h"

// Do not change
NSString *KeyPhoneNumber = @"phoneNumber";
NSString *KeyCountry = @"country";

@implementation PNConverter
- (NSDictionary*)converToPhoneNumberNextString:(NSString*)string; {
    NSDictionary *countryCodes = @{
        @"77"  : @"KZ",
        @"7"   : @"RU",
        @"373" : @"MD",
        @"374" : @"AM",
        @"375" : @"BY",
        @"380" : @"UA",
        @"992" : @"TJ",
        @"993" : @"TM",
        @"994" : @"AZ",
        @"996" : @"KG",
        @"998" : @"UZ"
    };
    
    NSString *inputNumber = [string copy];
    if ([inputNumber hasPrefix:@"+"]) {
        inputNumber = [inputNumber substringFromIndex:1];
    }
    if ([inputNumber length] > 12) {
        inputNumber = [inputNumber substringToIndex:12];
    }
    
    if ([inputNumber length] > 0) {
        NSMutableString *countryCode = [NSMutableString new];
        // dirty hack to make KZ before RU, :lol:
        NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil
                                                                         ascending:NO
                                                                          selector:@selector(localizedCompare:)];
        NSArray* sortedKeys = [[countryCodes allKeys] sortedArrayUsingDescriptors:@[sortDescriptor]];
        
        for (NSString *code in sortedKeys) {
            if ([inputNumber hasPrefix:code]) {
                countryCode = [countryCodes objectForKey:code];
                break;
            }
        }
        
        return @{KeyPhoneNumber: [self format:inputNumber with:countryCode],
                 KeyCountry: countryCode};
    }
    
    return @{KeyPhoneNumber: [self format:inputNumber with:@""],
             KeyCountry: @""};
}

- (NSString *) format:(NSString *)number with:(NSString *)code {
    NSDictionary *numberFormats = @{
        @"RU" : @"+x (xxx) xxx-xx-xx",
        @"KZ" : @"+x (xxx) xxx-xx-xx",
        @"MD" : @"+xxx (xx) xxx-xxx",
        @"AM" : @"+xxx (xx) xxx-xxx",
        @"BY" : @"+xxx (xx) xxx-xx-xx",
        @"UA" : @"+xxx (xx) xxx-xx-xx",
        @"TJ" : @"+xxx (xx) xxx-xx-xx",
        @"TM" : @"+xxx (xx) xxx-xxx",
        @"AZ" : @"+xxx (xx) xxx-xx-xx",
        @"KG" : @"+xxx (xx) xxx-xx-xx",
        @"UZ" : @"+xxx (xx) xxx-xx-xx"
    };
    NSSet *specialChars = [[NSSet alloc] initWithArray: @[@"+", @" ", @"(", @")", @"-"]];
    
    NSString *format = [numberFormats objectForKey:code];
    if (format) {
        NSString *formattedNumber = @"";
        int numberIterator = 0;
        for (int formatIterator = 0; formatIterator < [format length]; formatIterator++) {
            NSString *currentChar = [NSString stringWithFormat:@"%c", [format characterAtIndex:formatIterator]];
            if ([specialChars containsObject:currentChar]) {
                formattedNumber = [[NSString alloc] initWithFormat:@"%@%@", formattedNumber, currentChar];
            } else {
                formattedNumber = [[NSString alloc] initWithFormat:@"%@%c", formattedNumber, [number characterAtIndex:numberIterator]];
                numberIterator++;
                if (numberIterator == [number length]) {
                    break;
                }
            }
        }
        
        return formattedNumber;
    }
    
    return [NSString stringWithFormat:@"+%@", number];
}
@end
