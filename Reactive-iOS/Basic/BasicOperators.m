//
//  BasicOperators.m
//  Basic
//
//  Created by Yunarta on 2/9/18.
//

#import <XCTest/XCTest.h>
@import ReactiveObjC;

@interface BasicOperators : XCTestCase

@end

@implementation BasicOperators

- (void)testCombineLatest {
    RACSignal* a = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSArray<NSNumber*>* elements = @[@1, @2, @3, @4, @5];
        for (NSNumber* element in elements) {
            [subscriber sendNext:element];
            [NSThread sleepForTimeInterval:0.5];
        }
        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
    
    RACSignal* b = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"a"];
        [NSThread sleepForTimeInterval:0.5];
        [subscriber sendNext:@"b"];
        [NSThread sleepForTimeInterval:0.5];
        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
    
    NSError* error = nil;
    [[[RACSignal combineLatest:@[[a subscribeOn:[RACScheduler scheduler]], [b subscribeOn:[RACScheduler scheduler]]]] doNext:^(RACTuple * _Nullable x) {
        NSLog(@"\n❗️ first = %@, second %@", [x first], [x second]);
    }] waitUntilCompleted: &error];
}

@end
