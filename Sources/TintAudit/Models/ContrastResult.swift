import Foundation

// WCAG 2.1 contrast grade thresholds:
//   AAA     → ratio >= 7.0
//   AA      → ratio >= 4.5
//   AA Large → ratio >= 3.0 (for text ≥18pt bold or ≥14pt)
//   Fail    → ratio < 3.0
enum ContrastGrade: String {
    case fail = "Fail"
    case aaLarge = "AA Large"
    case aa = "AA"
    case aaa = "AAA"
}

// Holds the computed contrast ratio and grade together with
// the foreground/background colors used in the calculation.
struct ContrastResult {
    let ratio: Double
    let grade: ContrastGrade
    let foreground: AppColor
    let background: AppColor
}
