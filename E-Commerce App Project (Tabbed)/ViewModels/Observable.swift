//
//  Observable.swift
//  E-Commerce App Project (Tabbed)
//
//  Base class for MVVM data binding
//

import Foundation

class Observable<T> {
    
    typealias Listener = (T) -> Void
    
    private var listener: Listener?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ listener: @escaping Listener) {
        self.listener = listener
        listener(value)
    }
    
    func bindWithoutFire(_ listener: @escaping Listener) {
        self.listener = listener
    }
}
