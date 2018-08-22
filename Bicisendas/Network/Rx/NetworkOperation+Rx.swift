//
//  NetworkOperation+Rx.swift
//  Bicisendas
//
//  Created by Pablo Bendersky on 21/08/2018.
//  Copyright © 2018 Pablo Bendersky. All rights reserved.
//

import RxSwift

extension Reactive where Base: NetworkOperation {

    public func perform() -> Observable<Base.ResultType> {

        return Observable<Base.ResultType>.create { observer in
            self.base.perform(
                success: { (result) in

                    observer.on(.next(result))
                    observer.on(.completed)

                }, error: { (error) in

                    observer.on(.error(error))

                }
            )

            return Disposables.create()
        }

    }

}
