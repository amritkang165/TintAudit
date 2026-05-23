import TokamakShim

struct ContrastReportView: View {
    let result: ContrastResult

    var body: some View {
        VStack(spacing: 12) {
            Text("Contrast Ratio")
                .font(.headline)

            Text(String(format: "%.2f:1", result.ratio))
                .font(.system(size: 48, weight: .bold))
                .foregroundColor(gradeColor)

            HStack(spacing: 8) {
                GradeBadge(grade: .aaaLarge, passed: result.ratio >= 3.0)
                GradeBadge(grade: .aa, passed: result.ratio >= 4.5)
                GradeBadge(grade: .aaa, passed: result.ratio >= 7.0)
            }

            Text(gradeDescription)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(red: 0.96, green: 0.96, blue: 0.97))
        .cornerRadius(12)
    }

    private var gradeColor: Color {
        switch result.grade {
        case .aaa:
            return .green
        case .aa:
            return .green
        case .aaLarge:
            return .yellow
        case .fail:
            return .red
        }
    }

    private var gradeDescription: String {
        switch result.grade {
        case .aaa:
            return "Passes all WCAG requirements"
        case .aa:
            return "Passes AA, fails AAA"
        case .aaLarge:
            return "Passes AA Large only (18pt+ bold or 14pt+ text)"
        case .fail:
            return "Does not meet WCAG minimum contrast"
        }
    }
}

struct GradeBadge: View {
    let grade: ContrastGrade
    let passed: Bool

    var body: some View {
        HStack(spacing: 4) {
            Text(passed ? "✅" : "❌")
                .font(.caption)
            Text(grade.rawValue)
                .font(.caption)
                .fontWeight(.semibold)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 4)
        .background(passed ? Color.green.opacity(0.15) : Color.red.opacity(0.15))
        .foregroundColor(passed ? .green : .red)
        .cornerRadius(6)
    }
}
