//
//  CompletionResultViewModel.swift
//  Bicisendas
//
//  Created by Pablo Bendersky on 18/09/2018.
//  Copyright © 2018 Pablo Bendersky. All rights reserved.
//

class CompletionResultViewModel {

    private let usigContainer: USIGContainer

    public var title: String {
        switch usigContainer.usigType {
        case .calle:
            return format(calle: usigContainer.usigObject as! CalleDAO)
        case .direccion:
            return format(direccion: usigContainer.usigObject as! DireccionDAO)
        }
    }

    public var shouldHideDirections: Bool {
        return usigContainer.usigType == .calle
    }

    private func format(direccion: DireccionDAO) -> String {
        let direccion = usigContainer.usigObject as! DireccionDAO

        if let calleCruce = direccion.calleCruce {
            return "\(direccion.calle.nombre) y \(calleCruce.nombre)"
        } else {
            return "\(direccion.calle.nombre) \(direccion.altura)"
        }
    }

    private func format(calle: CalleDAO) -> String {
        return calle.nombre
    }

    init(usigContainer: USIGContainer) {
        self.usigContainer = usigContainer
    }
}
