//
//  DispatchQueue+Ext.swift
//  AppFinances
//
//  Created by Edgar on 01/07/25.
//

import Foundation

extension DispatchQueue {
    /// - Parameter closure: Closure to execute.
    func dispatchMainIfNeeded(_ closure: @escaping ()->Void) {
        guard self === DispatchQueue.main && Thread.isMainThread else {
            DispatchQueue.main.async(execute: closure)
            return
        }

        closure()
    }
}
