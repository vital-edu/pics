//
//  ApiClientProtocol.swift
//  Pics
//
//  Created by Eduardo Vital Alencar Cunha on 13/06/2022.
//

import Foundation
import Alamofire

protocol ApiClientProtocol {
    var baseUrl: String { get }
    var session: Session { get }
}
