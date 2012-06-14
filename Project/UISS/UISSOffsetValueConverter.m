//
//  UISSOffsetValueConverter.m
//  UISS
//
//  Created by Robert Wijas on 5/9/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import "UISSOffsetValueConverter.h"
#import "UISSArgument.h"

@implementation UISSOffsetValueConverter

- (BOOL)canConvertPropertyWithName:(NSString *)name value:(id)value argumentType:(NSString *)argumentType;
{
    return [argumentType isEqualToString:[NSString stringWithCString:@encode(UIOffset) encoding:NSUTF8StringEncoding]];
}

- (id)convertValue:(id)value;
{
    if ([value isKindOfClass:[NSArray class]]) {
        NSArray *array = (NSArray *)value;
        CGFloat horizontal = 0, vertical = 0;
        
        if (array.count > 0) {
            horizontal = [[array objectAtIndex:0] floatValue];
        }
        
        if (array.count > 1) {
            vertical = [[array objectAtIndex:1] floatValue];
        } else {
            vertical = horizontal;
        }
        
        return [NSValue valueWithUIOffset:UIOffsetMake(horizontal, vertical)];
    } else if ([value isKindOfClass:[NSNumber class]]) {
        return [NSValue valueWithUIOffset:UIOffsetMake([value floatValue], [value floatValue])];
    }
    
    return nil;
}

- (NSString *)generateCodeForValue:(id)value
{
    id converted = [self convertValue:value];

    if (converted) {
        UIOffset offset = [converted UIOffsetValue];

        return [NSString stringWithFormat:@"UIOffsetMake(%.1f, %.1f)",
                        offset.horizontal, offset.vertical];
    } else {
        return @"UIOffsetZero";
    }
}

- (BOOL)canConvertValueForArgument:(UISSArgument *)argument
{
    return [self canConvertPropertyWithName:argument.name value:argument.value argumentType:argument.type];
}

@end