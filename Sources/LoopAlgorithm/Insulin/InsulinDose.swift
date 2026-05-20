//
//  InsulinDose.swift
//
//  Copyright © 2023 LoopKit Authors. All rights reserved.
//

#if !arch(wasm32)
import Foundation
#else
import FoundationShim
#endif


public protocol InsulinDose: TimelineValue {
    var deliveryType: InsulinDeliveryType { get }
    var startDate: Date { get }
    var endDate: Date { get }
    var volume: Double { get }
    var insulinModel: ExponentialInsulinModel { get }
}

extension InsulinDose {
    public var duration: TimeInterval {
        return endDate.timeIntervalSince(startDate)
    }

    var unitsPerHour: Double {
        return volume / duration.hours
    }
}


public extension Collection where Element: InsulinDose {
    func effectsInterval() -> DateInterval? {
        guard count > 0 else {
            return nil
        }
        var minDate = first!.startDate
        var maxDate = first!.endDate
        for dose in self {
            if dose.startDate < minDate {
                minDate = dose.startDate
            }

            let doseEnd = dose.endDate.addingTimeInterval(dose.insulinModel.effectDuration)

            if doseEnd > maxDate {
                maxDate = doseEnd
            }
        }
        return DateInterval(start: minDate, end: maxDate)
    }
}
