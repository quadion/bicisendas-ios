//
//  NetworkOperation.swift
//  Bicisendas
//
//  Created by Pablo Bendersky on 21/08/2018.
//  Copyright © 2018 Pablo Bendersky. All rights reserved.
//

import Alamofire
import CodableAlamofire

public protocol NetworkOperation {

    associatedtype ResultType

    var url: String { get }

    func perform(success: @escaping (ResultType) -> Void, error: @escaping (Error) -> Void)

}

extension NetworkOperation where ResultType: Decodable {

    func perform(success: @escaping (ResultType) -> Void, error: @escaping (Error) -> Void) {

        Alamofire.request(self.url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .debugLog()
            .responseDecodableObject { (response: DataResponse<ResultType>) in

                if response.result.isFailure {
                    response.result.withError(error)
                } else {
                    response.result.withValue(success)
                }
        }

    }

}
