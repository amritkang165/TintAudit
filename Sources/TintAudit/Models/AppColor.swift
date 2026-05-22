import Foundation

struct AppColor: Equatable, Hashable, Codable {
    let r: Double
    let g: Double
    let b: Double

    init(r: Double, g: Double, b: Double) {
        self.r = max(0, min(255, r))
        self.g = max(0, min(255, g))
        self.b = max(0, min(255, b))
    }

    var hex: String {
        String(format: "#%02X%02X%02X", Int(r), Int(g), Int(b))
    }

    var cssRGB: String {
        "rgb(\(Int(r)), \(Int(g)), \(Int(b)))"
    }

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

    var normalized: (r: Double, g: Double, b: Double) {
        (r / 255.0, g / 255.0, b / 255.0)
    }
}
