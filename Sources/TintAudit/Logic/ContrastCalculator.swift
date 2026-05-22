import Foundation

// WCAG 2.1 contrast ratio calculator
// https://www.w3.org/TR/WCAG21/#dfn-contrast-ratio
struct ContrastCalculator {

    // Relative luminance formula per WCAG 2.1
    // L = 0.2126 * R + 0.7152 * G + 0.0722 * B
    static func relativeLuminance(_ color: AppColor) -> Double {
        func linearize(_ channel: Double) -> Double {
            let s = channel / 255.0
            // sRGB linearization: small values use gamma 1/12.92, larger use gamma 2.4
            if s <= 0.03928 {
                return s / 12.92
            } else {
                return pow((s + 0.055) / 1.055, 2.4)
            }
        }
        let r = linearize(color.r)
        let g = linearize(color.g)
        let b = linearize(color.b)
        return 0.2126 * r + 0.7152 * g + 0.0722 * b
    }

    // Contrast ratio = (L1 + 0.05) / (L2 + 0.05) where L1 is the lighter luminance
    static func check(_ foreground: AppColor, _ background: AppColor) -> ContrastResult {
        let l1 = relativeLuminance(foreground)
        let l2 = relativeLuminance(background)
        let lighter = max(l1, l2)
        let darker = min(l1, l2)
        let ratio = (lighter + 0.05) / (darker + 0.05)
        let rounded = (ratio * 100).rounded() / 100.0

        // WCAG 2.1 grade thresholds
        // AAA: ratio >= 7.0
        // AA:  ratio >= 4.5
        // AA Large: ratio >= 3.0
        let grade: ContrastGrade
        if rounded >= 7.0 {
            grade = .aaa
        } else if rounded >= 4.5 {
            grade = .aa
        } else if rounded >= 3.0 {
            grade = .aaLarge
        } else {
            grade = .fail
        }

        return ContrastResult(
            ratio: rounded,
            grade: grade,
            foreground: foreground,
            background: background
        )
    }
}
