//
//  MapperModule.swift
//  luma
//
//  Created by Juan Carlos Velasco on 22/4/25.
//

import Factory

extension Container {
    var imageDomainErrorMapper: Factory<ImageDomainErrorMapper> {
        self {
            ImageDomainErrorMapper()
        }
        .singleton
    }
}
