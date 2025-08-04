//
//  AFFormGroup.swift
//  App de Finanças
//
//  Created by Edgar on 22/06/25.
//
import UIKit
import Foundation

class AFFormGroup<Model> {
    
    private var model: Model
    private(set) var isValid: Bool = false
    private var fields: [AFAnyInput<Model>] = []
    
    
    init(model: Model) {
        self.model = model
    }
    
    
    func bind<Value, Input: AFBindableFormInput>(
        _ keyPath: WritableKeyPath<Model,Value>,
        input: Input
    ) where Input.Value == Value {
        fields.append(AFAnyInput(keyPath: keyPath, input: input))
    }
    
    
    func validate() -> Bool {
        isValid = fields.map { $0.validate() }.allSatisfy { $0 }
        return isValid
    }
    
    
    func getState() -> Model? {
        guard validate() else {
            return nil
        }
     
        fields.forEach { $0.apply(&model) }
        
        return model
    }
    
}

private class AFAnyInput<Model> {
    
    let validate: () -> Bool
    let apply: (inout Model) -> Void

    
    init<Value, Input: AFBindableFormInput>(
        keyPath: WritableKeyPath<Model, Value>,
        input: Input
    ) where Input.Value == Value{
        
        validate = {
            let isValid = input.validator.validate(value: input.getValue())
            input.didValidate(isValid: isValid)
            return isValid
        }

        apply = { model in
            if let value = input.getValue() {
                model[keyPath: keyPath] = value
            }
        }
        
    }
    
    
}

enum AFFieldValidator<T> {
    
    
    case email
    
    case text
    
    case number
    
    case nonNil
    
    func validate(value: T?) -> Bool {
        switch self {
        case .email:
            if let value = value as? String {
                let email = /^[a-z0-9.]+@[a-z0-9]+\.[a-z]+(\.[a-z]+)?$/.ignoresCase()
                return value.firstMatch(of: email) != nil
            }
            return false
           
        case .text:
            if let value = value as? String, !value.isEmpty {
                return true
            }
            return false
        case .number:
            if
                let value = value as? String,
                !value.isEmpty,
                NumberFormatter().number(from: value)?.doubleValue != nil
            {
                return true
            }
            
        case .nonNil:
            let isNotNil = value ?? nil
          
            return isNotNil != nil
        }
        
        return false
    }
    
    
}

protocol AFBindableFormInput: AnyObject {
    
    
    associatedtype Value
    
    var validator: AFFieldValidator<Value> { get }
    
    func didValidate(isValid: Bool)
    
    func getValue() -> Value?
    
    
}

extension AFBindableFormInput {
    

    var validator: AFFieldValidator<Value> {
        .text
    }
    
    
}

