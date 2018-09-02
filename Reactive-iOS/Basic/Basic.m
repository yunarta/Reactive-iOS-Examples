//
//  Basic.m
//  Basic
//
//  Created by Yunarta on 2/9/18.
//

#import <XCTest/XCTest.h>
@import ReactiveObjC;

@interface Basic : XCTestCase

@end

@implementation Basic

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testObservableCreate {
    [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"1"];
        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"\n❗️ Next element = %@", x);
    } completed:^{
        NSLog(@"\n❗️ Completed");
    }];
}

- (void)testObservableThreading {
    [[[[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"1"];
        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"\n❗️ On main thread = %d, Disposed", [NSThread isMainThread]);
        }];
    }]
        subscribeOn:[RACScheduler scheduler]]
       doNext:^(id  _Nullable x) {
           NSLog(@"\n❗️ On main thread = %d, Next element = %@", [NSThread isMainThread], x);
       }]
      deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(id  _Nullable x) {
         NSLog(@"\n❗️ On main thread = %d, Next element = %@", [NSThread isMainThread], x);
     } completed:^{
         NSLog(@"\n❗️ On main thread = %d, Completed", [NSThread isMainThread]);
     }];
}

@end
