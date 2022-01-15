//
//  ApiHandler.swift
//  IntroCombine
//
//  Created by Sagar on 15/01/22.
//

import Foundation
import Combine


class APIHandler {
    
    static func fetchUser (url : URL) -> AnyPublisher<[User], Never> {
        let publisher = URLSession.shared.dataTaskPublisher(for: url)
            .map({ $0.data })
            .decode(type: [User].self, decoder: JSONDecoder())
            .catch({ _ in
                Just([])
            })
                    .eraseToAnyPublisher()
                    return publisher
    }
}
