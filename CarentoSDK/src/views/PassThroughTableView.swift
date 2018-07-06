//
//  PassThroughTableView.swift
//  FLIX
//
//  Created by Kent Vu on 12/25/16.
//  Copyright © 2016 FlixViet. All rights reserved.
//

import UIKit

class PassThroughTableView: UITableView {
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        /// the height of the table itself.
        let height = self.bounds.size.height + self.contentOffset.y
        /// the bounds of the table.
        /// it's strange that the origin of the table view is actually the top-left of the table.
        let bounds = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: height)
        return bounds.contains(point)
    }

}

class PassThroughScrollView: UIScrollView {
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if let onlySubview = subviews.first {
            for subview in onlySubview.subviews {
                if (subview.frame.contains(point)) {
                    return true
                }
            }
            return false
        }
        return true
    }
    
}

class PassThroughView: UIView {
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for subview in subviews {
            if (subview.frame.contains(point)) {
                return true
            }
        }
        return false
    }
    
}
