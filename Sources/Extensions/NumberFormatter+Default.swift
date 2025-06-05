import Foundation

extension NumberFormatter {
    /// Formatter without grouping separator for consistent numeric input.
    static var defaultFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = false
        formatter.numberStyle = .decimal
        return formatter
    }()
}
