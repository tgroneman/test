//
//  Validation.swift
//  E-Commerce App Project (Tabbed)
//
//  Converted to Swift
//

import Foundation
import UIKit

@objc class Validation: NSObject {
    
    @objc func requiredMinLengthValidator(_ requiredErrorMessage: String, integerforMinLength minLength: Int, minLengthErrorMessage: String, withLabelForValidationRules validationStatusLabel: UILabel) -> AJWValidator {
        let validator = AJWValidator(type: .string)!
        validator.addValidationToEnsurePresence(withInvalidMessage: NSLocalizedString(requiredErrorMessage, comment: ""))
        validator.addValidation(toEnsureMinimumLength: UInt(minLength), invalidMessage: NSLocalizedString(minLengthErrorMessage, comment: ""))
        validator.validatorStateChangedHandler = { [weak self] newState in
            switch newState {
            case .validationStateValid:
                self?.handleValid(validationStatusLabel)
            case .validationStateInvalid:
                self?.handleInvalid(validator, withLabelForError: validationStatusLabel)
            case .validationStateWaitingForRemote:
                self?.handleWaiting()
            default:
                break
            }
        }
        return validator
    }
    
    @objc func equalityValidator(_ password: Any, with validationStatusLabel: UILabel) -> AJWValidator {
        let validator = AJWValidator(type: .string)!
        validator.addValidation(toEnsureInstanceIsTheSameAs: password, invalidMessage: NSLocalizedString("Should be equal to 'password'", comment: ""))
        validator.validatorStateChangedHandler = { [weak self] newState in
            switch newState {
            case .validationStateValid:
                self?.handleValid(validationStatusLabel)
            case .validationStateInvalid:
                self?.handleInvalid(validator, withLabelForError: validationStatusLabel)
            case .validationStateWaitingForRemote:
                self?.handleWaiting()
            default:
                break
            }
        }
        return validator
    }
    
    @objc func emailValidator(_ validationStatusLabel: UILabel) -> AJWValidator {
        let validator = AJWValidator(type: .string)!
        validator.addValidationToEnsureValidEmail(withInvalidMessage: "Must be a valid email address!")
        validator.validatorStateChangedHandler = { [weak self] newState in
            switch newState {
            case .validationStateValid:
                self?.handleValid(validationStatusLabel)
            case .validationStateInvalid:
                self?.handleInvalid(validator, withLabelForError: validationStatusLabel)
            case .validationStateWaitingForRemote:
                self?.handleWaiting()
            default:
                break
            }
        }
        return validator
    }
    
    @objc func phoneValidator(_ validationStatusLabel: UILabel) -> AJWValidator {
        let validator = AJWValidator(type: .string)!
        validator.addValidationToEnsureRegularExpressionIsMet(withPattern: "^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\\s\\./0-9]*$", invalidMessage: NSLocalizedString("Please check your phone no again!", comment: ""))
        validator.validatorStateChangedHandler = { [weak self] newState in
            switch newState {
            case .validationStateValid:
                self?.handleValid(validationStatusLabel)
            case .validationStateInvalid:
                self?.handleInvalid(validator, withLabelForError: validationStatusLabel)
            case .validationStateWaitingForRemote:
                self?.handleWaiting()
            default:
                break
            }
        }
        return validator
    }
    
    @objc func requiredValidator(_ errorMessage: String, withLabelForValidationRules validationStatusLabel: UILabel) -> AJWValidator {
        let validator = AJWValidator(type: .string)!
        validator.addValidationToEnsurePresence(withInvalidMessage: NSLocalizedString(errorMessage, comment: ""))
        validator.validatorStateChangedHandler = { [weak self] newState in
            switch newState {
            case .validationStateValid:
                self?.handleValid(validationStatusLabel)
            case .validationStateInvalid:
                self?.handleInvalid(validator, withLabelForError: validationStatusLabel)
            case .validationStateWaitingForRemote:
                self?.handleWaiting()
            default:
                break
            }
        }
        return validator
    }
    
    @objc func minLengthValidator(_ errorMessage: String, withLabelForValidationRules validationStatusLabel: UILabel) -> AJWValidator {
        let validator = AJWValidator(type: .string)!
        validator.addValidation(toEnsureMinimumLength: 6, invalidMessage: NSLocalizedString(errorMessage, comment: ""))
        validator.validatorStateChangedHandler = { [weak self] newState in
            switch newState {
            case .validationStateValid:
                self?.handleValid(validationStatusLabel)
            case .validationStateInvalid:
                self?.handleInvalid(validator, withLabelForError: validationStatusLabel)
            case .validationStateWaitingForRemote:
                self?.handleWaiting()
            default:
                break
            }
        }
        return validator
    }
    
    private func handleValid(_ validationStatusLabel: UILabel) {
        validationStatusLabel.isHidden = false
        let validGreen = UIColor(red: 0.27, green: 0.63, blue: 0.27, alpha: 1)
        validationStatusLabel.backgroundColor = validGreen.withAlphaComponent(0.3)
        validationStatusLabel.text = NSLocalizedString("No errors", comment: "")
        validationStatusLabel.textColor = validGreen
        validationStatusLabel.isHidden = true
    }
    
    private func handleInvalid(_ validator: AJWValidator, withLabelForError validationStatusLabel: UILabel) {
        validationStatusLabel.isHidden = false
        let invalidRed = UIColor(red: 0.89, green: 0.18, blue: 0.16, alpha: 1)
        validationStatusLabel.backgroundColor = invalidRed.withAlphaComponent(0.3)
        if let errorMessages = validator.errorMessages as? [String] {
            validationStatusLabel.text = errorMessages.joined(separator: "\n")
        }
        validationStatusLabel.textColor = invalidRed
    }
    
    private func handleWaiting() {
        // Network activity indicator is deprecated in iOS 13+
    }
}
