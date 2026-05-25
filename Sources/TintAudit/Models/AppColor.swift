import Foundation

// sRGB color stored in 0-255 range with clamping on init.
// Provides hex, CSS, and normalized representations.
struct AppColor: Equatable, Hashable, Codable {
    let r: Double
    let g: Double
    let b: Double

    init(r: Double, g: Double, b: Double) {
        self.r = max(0, min(255, r))
        self.g = max(0, min(255, g))
        self.b = max(0, min(255, b))
    }

    // Uppercase hex with # prefix, e.g. "#2D7FF9"
    var hex: String {
        String(format: "#%02X%02X%02X", Int(r), Int(g), Int(b))
    }

    // CSS rgb() function string
    var cssRGB: String {
        "rgb(\(Int(r)), \(Int(g)), \(Int(b)))"
    }

    // Initialize from hex string, accepting both "#RRGGBB" and "RRGGBB" formats.
    // Case-insensitive. Returns nil for invalid input.
    init?(hex: String) {
        var hexStr = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if hexStr.hasPrefix("#") {
            hexStr = String(hexStr.dropFirst())
        }
        guard hexStr.count == 6, let value = UInt64(hexStr, radix: 16) else {
            return nil
        }
        self.r = Double((value >> 16) & 0xFF)
        self.g = Double((value >> 8) & 0xFF)
        self.b = Double(value & 0xFF)
    }

    // Components normalized to [0, 1] for matrix operations and WCAG luminance
    var normalized: (r: Double, g: Double, b: Double) {
        (r / 255.0, g / 255.0, b / 255.0)
    }
}
