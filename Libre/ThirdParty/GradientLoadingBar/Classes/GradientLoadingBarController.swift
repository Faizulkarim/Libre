//
//  GradientLoadingBarController.swift
//  GradientLoadingBar
//
//  Created by Felix Mau on 11.12.16.
//  Copyright © 2016 Felix Mau. All rights reserved.
//

import UIKit

// MARK: - Typealiases

/// Typealias for controller to match pod name.
public typealias GradientLoadingBar = GradientLoadingBarController

// MARK: - Controller

open class GradientLoadingBarController {

    // MARK: - Types

    /// Struct used for default parameters in initialization
    public struct DefaultValues {

        /// Height of gradient bar.
        public static let height = 2.0

        /// Configuration with durations for each animation.
        public static let durations = Durations(fadeIn: 0.33, fadeOut: 0.66, progress: 3.33)
        
        public static let gradientColors : [UIColor] = [
            UIColor.red , UIColor.yellow, UIColor.blue, UIColor.systemPink
        ]

    }

    // MARK: - Public properties

    /// Boolean flag, true if gradient view is currently visible, otherwise false.
    public var isVisible: Bool {
        return viewModel.isVisible
    }

    /// View containing the gradient layer.
    public let gradientView: GradientView

    /// Height of gradient bar.
    public private(set) var height = 0.0

    /// Superview that the gradient view is attached to.
    public private(set) var superview: UIView?

    /// Singleton instance.
    public static var shared: GradientLoadingBar = GradientLoadingBar()

    // MARK: - Private properties

    /// View model containing logic for the gradient view.
    private let viewModel = GradientLoadingBarViewModel()

    // MARK: - Initializers

    /// Creates a new gradient loading bar instance.
    ///
    /// Parameters:
    ///  - height:            Height of the gradient bar
    ///  - durations:         Configuration with durations for each animation
    ///  - gradientColorList: Colors used for the gradient
    ///  - superview:         View containing the gradient bar
    ///
    /// Returns: Instance with gradient bar
    public init(
        height: Double = DefaultValues.height,
        durations: Durations = DefaultValues.durations,
        gradientColorList: [UIColor] = DefaultValues.gradientColors,
        onView superview: UIView? = nil
    ) {
        self.height = height

        gradientView = GradientView(
            animationDurations: durations,
            gradientColorList: gradientColorList
        )

        viewModel.delegate = self

        if let superview = superview {
            // We have a custom superview given from the user, therefore add gradient view immediatly.
            self.superview = superview
            addGradientViewToSuperview()
        } else {
            // No superview given, let the view model notify us when `keyWindow` becomes available.
            viewModel.setupObserverForKeyWindow()
        }
    }

    deinit {
        if gradientView.superview != nil {
            gradientView.removeFromSuperview()
        }
    }

    // MARK: - Layout

    func addGradientViewToSuperview() {
        guard let superview = superview else { return }

        gradientView.translatesAutoresizingMaskIntoConstraints = false
        superview.addSubview(gradientView)
        setupConstraints()
    }

    /// Apply layout contraints for gradient loading view.
    open func setupConstraints() {
        guard let superview = superview else { return }

        let superViewTopAnchor: NSLayoutYAxisAnchor
        superViewTopAnchor = superview.bottomAnchor
       
        var constraints = [
            NSLayoutConstraint(item: gradientView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 4.0),
            gradientView.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: superview.trailingAnchor)
        ]
        
        if #available(iOS 11, *)
        {
            constraints.append(gradientView.bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor))
        }
        else
        {
            constraints.append(NSLayoutConstraint(item: gradientView, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1.0, constant: 0))
        }
        NSLayoutConstraint.activate(constraints)       
    }

    // MARK: - Show / Hide (proxy methods to hide view model implementation)

    /// Fade in the gradient loading bar.
    public func show() {
        viewModel.show()
    }

    /// Fade out the gradient loading bar.
    public func hide() {
        viewModel.hide()
    }

    /// Toggle visiblity of gradient loading bar.
    public func toggle() {
        viewModel.toggle()
    }
}

// MARK: - GradientLoadingBarViewModelDelegate

extension GradientLoadingBarController: GradientLoadingBarViewModelDelegate {
    func viewModel(_: GradientLoadingBarViewModel, didUpdateKeyWindow keyWindow: UIView) {
        guard superview == nil else {
            // The viewmodel informed us eventhough we already have a valid superview.
            // This isn't supposed to happen, therefore safely exit here.
            return
        }

        superview = keyWindow
        addGradientViewToSuperview()
    }

    func viewModel(_: GradientLoadingBarViewModel, didUpdateVisibility visible: Bool) {
        if visible {
            gradientView.show()
        } else {
            gradientView.hide()
        }
    }
}

// MARK: - Deprecated methods

extension GradientLoadingBarController {

    /// Creates a new gradient loading bar instance.
    ///
    /// Note:
    ///  - Deprecated!
    ///  - Please use `init(height: Double, durations: Durations, gradientColorList: [UIColor], onView: UIView?)` instead
    ///
    /// Parameters:
    ///  - height:         Height of the gradient bar
    ///  - durations:      Configuration with durations for each animation
    ///  - gradientColors: Colors used for the gradient
    ///  - superview:      View containing the gradient bar
    ///
    /// Returns: Instance with gradient bar
    @available(*, deprecated, message: "Please use `init(height: Double, durations: Durations, gradientColorList: [UIColor], onView: UIView?)` instead")
    public convenience init(
        height: Double = DefaultValues.height,
        durations: Durations = DefaultValues.durations,
        gradientColors: [CGColor],
        onView superview: UIView? = nil
    ) {
        self.init(height: height,
                  durations: durations,
                  gradientColorList: gradientColors.map({ UIColor(cgColor: $0) }),
                  onView: superview)
    }

    /// Saves the current instance for usage as singleton.
    ///
    /// Note:
    ///  - Deprecated!
    ///  - Please use `.shared` instead
    ///
    @available(*, deprecated, message: "Please use `.shared` instead")
    public func saveInstance() {
        type(of: self).shared = self
    }

    /// Singleton instance.
    ///
    /// Note:
    ///  - Deprecated!
    ///  - Please use `.shared` instead
    ///
    @available(*, deprecated, message: "Please use `.shared` instead")
    public static func sharedInstance() -> GradientLoadingBar {
        return shared
    }
}
