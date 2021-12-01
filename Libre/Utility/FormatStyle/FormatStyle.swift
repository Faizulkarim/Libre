//
//  FormatStyle.swift
//  FormatStyle
//
//  Created by Hyperlink on 18/07/19.
//  Copyright © 2019 . All rights reserved.
//

import UIKit


//Need Protocol to maintain typecast

protocol FormatStyle { }

protocol ViewStyle { }

extension UILabel: FormatStyle { }

extension UIButton: FormatStyle { }

extension UITextField: FormatStyle { }

extension UITextView: FormatStyle { }

extension UIBarButtonItem: FormatStyle { }

extension UIView: ViewStyle { }
