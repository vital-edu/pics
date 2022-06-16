//
//  PicsApiClient.swift
//  Pics
//
//  Created by Eduardo Vital Alencar Cunha on 13/06/2022.
//

import Foundation
import Alamofire

struct PicsApiClient: ApiClientProtocol {
    let baseUrl = "https://picsum.photos"
    let session: Session

    init(session: Session = Session()) {
        self.session = session
    }
}
