//
//  AlertBase.swift
//  IncetroDeveloperKit
//
//  Created by incetro on 14/02/2017.
//  Copyright © 2017 Incetro. All rights reserved.
//

import UIKit

// MARK: - AlertBase

public class AlertBase: AlertProtocol {
    
    // MARK: - AlertProtocol
    
    public var type: UIAlertControllerStyle {
        fatalError("You should override this property in subclasses")
    }
    
    public var textFields: [UITextField] {
        return alert?.textFields ?? []
    }
    
    // MARK: - Properties
    
    /// UIAlertController instance
    internal var alert: UIAlertController?
    
    /// Delegate instance
    fileprivate var delegate: AlertDelegate? = nil
    
    // MARK: - Initializers
    
    /// Standard initializer
    ///
    /// - Parameters:
    ///   - title: Dialog title
    ///   - message: Dialog message
    public init(withTitle title: String, message: String) {
        alert = UIAlertController(title: title, message: message, preferredStyle: type)
    }
    
    /// Short initializer
    ///
    /// - Parameter message: Dialog message
    public init(withMessage message: String) {
        alert = UIAlertController(title: nil, message: message, preferredStyle: type)
    }
    
    // MARK: - Public
    
    /// Add simple button with red text
    ///
    /// - Parameter title: Button title
    /// - Returns: self
    public func addDestructiveButton(withTitle title: String) -> Self {
        alert?.addAction(UIAlertAction(title: title, style: .destructive, handler: { [weak self] _ in
            guard let `self` = self else {
                return
            }
            self.delegate?.willDisappear(self)
            self.delegate?.didDisappear(self)
        }))
        return self
    }
    
    /// Add simple button with bold text
    ///
    /// - Parameter title: Button title
    /// - Returns: self
    public func addCancelButton(withTitle title: String) -> Self {
        alert?.addAction(UIAlertAction(title: title, style: .cancel, handler: { [weak self] _ in
            guard let `self` = self else {
                return
            }
            self.delegate?.willDisappear(self)
            self.delegate?.didDisappear(self)
        }))
        return self
    }
    
    /// Add simple button with title
    ///
    /// - Parameter title: Button title
    /// - Returns: self
    public func addButton(withTitle title: String) -> Self {
        alert?.addAction(UIAlertAction(title: title, style: .default, handler: { [weak self] _ in
            guard let `self` = self else {
                return
            }
            self.delegate?.willDisappear(self)
            self.delegate?.didDisappear(self)
        }))
        return self
    }
    
    /// Add simple button with bold text, title and action
    ///
    /// - Parameters:
    ///   - title: Button title
    ///   - action: Button action
    /// - Returns: self
    public func addCancelButton(withTitle title: String, andAction action: @escaping (_ alert: AlertBase) -> ()) -> Self {
        alert?.addAction(UIAlertAction(title: title, style: .cancel, handler: { [weak self] _ in
            guard let `self` = self else {
                return
            }
            self.delegate?.willDisappear(self)
            action(self)
            self.delegate?.didDisappear(self)
        }))
        return self
    }
    
    /// Add simple button with red text, title and action
    ///
    /// - Parameters:
    ///   - title: Button title
    ///   - action: Button action
    /// - Returns: self
    public func addDestructiveButton(withTitle title: String, andAction action: @escaping (_ alert: AlertBase) -> ()) -> Self {
        alert?.addAction(UIAlertAction(title: title, style: .destructive, handler: { [weak self] _ in
            guard let `self` = self else {
                return
            }
            self.delegate?.willDisappear(self)
            action(self)
            self.delegate?.didDisappear(self)
        }))
        return self
    }
    
    /// Add simple button with title and action
    ///
    /// - Parameters:
    ///   - title: Button title
    ///   - action: Button action
    /// - Returns: self
    public func addButton(withTitle title: String, andAction action: @escaping (_ alert: AlertBase) -> ()) -> Self {
        alert?.addAction(UIAlertAction(title: title, style: .default, handler: { [weak self] _ in
            guard let `self` = self else {
                return
            }
            self.delegate?.willDisappear(self)
            action(self)
            self.delegate?.didDisappear(self)
        }))
        return self
    }
    
    /// Show alert controller
    ///
    /// - Parameter delegate: Current delegate
    public func show(`in` controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController, withDelegate delegate: AlertDelegate? = nil, completion: (() -> Void)? = nil) {
        if let delegate = delegate {
            self.delegate = delegate
        }
        if let alert = alert {
            DispatchQueue.main.async {
                delegate?.willShow(self)
                controller?.present(alert, animated: true, completion: {
                    completion?()
                    delegate?.didShow(self)
                })
            }
        }
    }
    
    /// Close current controller
    
    public func close() {
        delegate?.willDisappear(self)
        alert?.dismiss(animated: true) { [weak self] in
            guard let `self` = self else {
                return
            }
            self.delegate?.didDisappear(self)
        }
    }
    
    /// Show after time interval
    ///
    /// - Parameter timeInterval: time interval before showing
    public func show(after timeInterval: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + timeInterval) { [weak self] in
            self?.show()
        }
    }
    
    /// Show immediately
    ///
    /// - Parameter closeTimeInterval: time interval before closing
    public func show(andCloseAfter closeTimeInterval: Double) {
        show()
        close(after: closeTimeInterval)
    }
    
    /// Show after time interval and close after time interval
    ///
    /// - Parameters:
    ///   - showTimeInterval:  time interval before showing
    ///   - closeTimeInterval: time interval before closing
    public func show(after showTimeInterval: Double, andCloseAfter closeTimeInterval: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + showTimeInterval) { [weak self] in
            guard let `self` = self else {
                return
            }
            self.show()
            self.close(after: closeTimeInterval)
        }
    }
    
    // MARK: - Private
    
    /// Close after given interval
    ///
    /// - Parameter timeInterval: given interval
    private func close(after timeInterval: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + timeInterval) { [weak self] in
            guard let `self` = self else {
                return
            }
            self.close()
        }
    }
}
