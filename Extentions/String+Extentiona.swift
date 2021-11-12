//
//  String+Extentiona.swift
//  RealTimeChatApp
//
//  Created by abdurhman elbosaty on 12/09/2021.
//

import UIKit

extension String {
    
    var trimmed: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
