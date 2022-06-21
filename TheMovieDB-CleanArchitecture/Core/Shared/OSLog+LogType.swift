//
//  OSLog+LogType.swift
//  TheMovieDB-CleanArchitecture
//
//  Created by Dulce Mejia Aguayo on 21/06/22.
//

import Foundation
import os.log

extension OSLog {
    private static var subsystem = Bundle.main.bundleIdentifier!
    /// APIError
    static let apiError = OSLog(subsystem: subsystem, category: "api_error")
}
