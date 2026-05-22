import Foundation

enum ContrastGrade: String {
    case fail = "Fail"
    case aaLarge = "AA Large"
    case aa = "AA"
    case aaa = "AAA"
}

struct ContrastResult {
    let ratio: Double
    let grade: ContrastGrade
    let foreground: AppColor
    let background: AppColor
}
