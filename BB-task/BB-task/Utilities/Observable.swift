//
//  Observable.swift
//  BB-task
//
//  Created by KonstanTanos on 25/05/2023.
//

import Foundation

final class Observable<T> {
    
    typealias ObserverCompletion = (T) -> ()
    
    struct Observer<Type> {
        
        weak var observer: AnyObject?
        let completion: ObserverCompletion
    }
    
    private var observers = [Observer<T>]()
    
    var value: T {
        didSet {
            notifyObservers()
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func observe(on observer: AnyObject, observerCompletion: @escaping ObserverCompletion) {
        observers.append(Observer(observer: observer, completion: observerCompletion))
        observerCompletion(self.value)
    }
    
    func remove(observer: AnyObject) {
        observers = observers.filter { $0.observer !== observer }
    }
    
}

private
extension Observable {
    
    func notifyObservers() {
        observers.forEach {
            $0.completion(self.value)
        }
    }
}
