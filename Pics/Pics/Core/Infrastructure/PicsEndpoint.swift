//
//  PicsEndpoint.swift
//  Pics
//
//  Created by Eduardo Vital Alencar Cunha on 13/06/2022.
//

import Foundation

enum PicsEndpoint {
    case list
    case show(_ id: String)
    case showDetails(_ id: String)

    var value: String {
        switch self {
        case .list:
            return "v2/list"
        case .show(let id):
            return "id/\(id)"
        case .showDetails(let id):
            return "v2/id/\(id)/info"
        }
    }
}
