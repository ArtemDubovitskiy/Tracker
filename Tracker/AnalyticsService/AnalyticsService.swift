//
//  AnalyticsService.swift
//  Tracker
//
//  Created by Artem Dubovitsky on 11.01.2024.
//
import Foundation
import YandexMobileMetrica

struct AnalyticsService {
    static func activate() {
        guard let configuration = YMMYandexMetricaConfiguration(
            apiKey: "875d100c-2355-4cf2-8a93-d8fb9ec28bc1"
        ) else { return }
        YMMYandexMetrica.activate(with: configuration)
    }
    
    func report(event: String, params: [AnyHashable: Any]) {
        YMMYandexMetrica.reportEvent(event,
                                     parameters: params,
                                     onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)})
    }
}
