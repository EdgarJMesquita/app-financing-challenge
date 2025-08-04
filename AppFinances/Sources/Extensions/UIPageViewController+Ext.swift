//
//  UIPageViewController+Ext.swift
//  AppFinances
//
//  Created by Edgar on 30/07/25.
//

import UIKit

extension UIPageViewController {

    var scrollView: UIScrollView? {
        return view.subviews.first { $0 is UIScrollView } as? UIScrollView
    }

}
