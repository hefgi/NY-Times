//
//  Result.swift
//  NYTimes
//
//  Created by François-Julien Alcaraz on 10/07/2018.
//  Copyright © 2018 Mokriya. All rights reserved.
//

import Foundation

enum Result<Value> {
    case success(Value)
    case failure(Error)
}

extension Result {
    init(_ value: () throws -> Value) {
        do {
            self = .success(try value())
        } catch {
            self = .failure(error)
        }
    }
}
