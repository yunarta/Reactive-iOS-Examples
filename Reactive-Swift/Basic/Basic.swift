//
//  Basic.swift
//  Basic
//
//  Created by Yunarta on 3/9/18.
//

import XCTest
import RxSwift
import RxBlocking

class Basic: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testObservableCreate() {
        _ = try! Observable<String>.create { (subscriber) -> Disposable in
            subscriber.onNext("A")
            subscriber.onCompleted()
            
            return Disposables.create()
            }
            .do(onNext: { (element) in
                
                print("❗️ Next element = \(element)")
            }, onCompleted: {
                print("❗️ Completed")
            })
            .toBlocking().toArray()
    }
    
    func testObservableThreading() {
        _ = try! Observable<String>.create { (subscriber) -> Disposable in
            subscriber.onNext("A")
            subscriber.onCompleted()
            
            return Disposables.create()
            }
            .observeOn(ConcurrentDispatchQueueScheduler(qos: DispatchQoS.background))
            .do(onNext: { (element) in
                print("❗️ On main thread = \(Thread.isMainThread), Next element = \(element)")
            })
            .subscribeOn(MainScheduler.instance)
            .do(onNext: { (element) in
                print("❗️ On main thread = \(Thread.isMainThread), Next element = \(element)")
            }, onCompleted: {
                print("❗️ On main thread = \(Thread.isMainThread), Completed")
            }).toBlocking().toArray()
    }
}
