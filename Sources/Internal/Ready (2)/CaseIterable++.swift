//
//  CaseIterable++.swift of MijickCamera
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2024 Mijick. All rights reserved.


import Foundation

extension CaseIterable where Self: Equatable {
    func next() -> Self {
        guard let index = Self.allCases.firstIndex(of: self) else { return self }
        
        let nextIndex = Self.allCases.index(after: index)
        return Self.allCases[nextIndex == Self.allCases.endIndex ? Self.allCases.startIndex : nextIndex]
    }
}
