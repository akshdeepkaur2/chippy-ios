//
//  Extensions.swift
//  Chippy Game
//
//  Created by TED Komputer on 10/7/19.
//  Copyright © 2019 Lars Bergqvist. All rights reserved.
//

import Foundation
extension Int {
    var degreesToRadians: Double { return Double(self) * .pi / 180 }
    var radiansToDegrees: Double { return Double(self) * 180 / .pi }
}
