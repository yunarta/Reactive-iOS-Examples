//
//  BasicOperators.swift
//  Basic
//
//  Created by Yunarta on 3/9/18.
//

import XCTest
import RxSwift
import RxBlocking

class BasicOperators: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCombineLatest() {
        let a = Observable<Int>.create { (subscriber) -> Disposable in
            let elements = [1, 2, 3, 4, 5]
            for element in elements {
                subscriber.onNext(element)
                Thread.sleep(forTimeInterval: 0.5)
            }
            subscriber.onCompleted()
            return Disposables.create()
        }
        
        let b = Observable<String>.create { (subscriber) -> Disposable in
            let elements = ["a", "b"]
            for element in elements {
                subscriber.onNext(element)
                Thread.sleep(forTimeInterval: 0.5)
            }
            subscriber.onCompleted()
            return Disposables.create()
        }
        
        let background = ConcurrentDispatchQueueScheduler(qos: DispatchQoS.background)
        _ = try! Observable.combineLatest(a.subscribeOn(background), b.subscribeOn(background), resultSelector: { (a, b) -> (Int, String) in
                return (a, b)
            })
            .observeOn(MainScheduler.instance)
            .subscribeOn(MainScheduler.instance)
            .do(onNext: { (element) in
                print("❗️ On main thread = \(Thread.isMainThread), Next element = \(element)")
            }, onCompleted: {
                print("❗️ On main thread = \(Thread.isMainThread), Completed")
            }).toBlocking().toArray()
    }
}
