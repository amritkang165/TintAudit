import Foundation

// Color blindness simulation using linear matrix transformations.
// These matrices model the loss of specific cone types in the human eye:
//
// Protanopia  (L-cone / red):   missing long-wavelength sensitivity
// Deuteranopia (M-cone / green): missing medium-wavelength sensitivity
// Tritanopia  (S-cone / blue):  missing short-wavelength sensitivity
//
// Each matrix maps linear sRGB to a simulated 2D color space.

struct ColorBlindnessSimulator {

    static func simulate(_ color: AppColor, for type: ColorBlindnessType) -> AppColor {
        let (r, g, b) = color.normalized
        var nr: Double
        var ng: Double
        var nb: Double

        switch type {
        case .normal:
            return color

        // Protanopia (red-blind): red channel collapsed into green
        case .protanopia:
            nr = 0.567 * r + 0.433 * g + 0.000 * b
            ng = 0.558 * r + 0.442 * g + 0.000 * b
            nb = 0.000 * r + 0.242 * g + 0.758 * b

        // Deuteranopia (green-blind): green channel collapsed into red
        case .deuteranopia:
            nr = 0.625 * r + 0.375 * g + 0.000 * b
            ng = 0.700 * r + 0.300 * g + 0.000 * b
            nb = 0.000 * r + 0.300 * g + 0.700 * b

        // Tritanopia (blue-blind): blue channel collapsed into green
        case .tritanopia:
            nr = 0.950 * r + 0.050 * g + 0.000 * b
            ng = 0.000 * r + 0.433 * g + 0.567 * b
            nb = 0.000 * r + 0.475 * g + 0.525 * b
        }

        return AppColor(r: nr * 255, g: ng * 255, b: nb * 255)
    }
}
