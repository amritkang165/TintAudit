import TokamakShim
import JavaScriptKit

struct CodeExportView: View {
    let color: AppColor
    @Binding var selectedTab: ExportTab
    @State private var copiedFeedback = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Export Code")
                .font(.headline)

            // Tab bar
            HStack(spacing: 4) {
                ForEach(ExportTab.allCases, id: \.self) { tab in
                    Button(tab.rawValue) {
                        selectedTab = tab
                        copiedFeedback = false
                    }
                    .buttonStyle(
                        ExportTabButtonStyle(isSelected: selectedTab == tab)
                    )
                }
            }

            // Code block
            ScrollView(.horizontal, showsIndicators: true) {
                Text(codeContent)
                    .font(.system(.caption, design: .monospaced))
                    .foregroundColor(Color(red: 0.83, green: 0.83, blue: 0.83))
                    .padding(14)
                    .frame(minWidth: 0, maxWidth: .none, alignment: .leading)
            }
            .background(Color(red: 0.12, green: 0.12, blue: 0.12))
            .cornerRadius(8)

            // Copy button
            Button(action: copyCode) {
                HStack(spacing: 6) {
                    Text(copiedFeedback ? "Copied!" : "Copy")
                    if copiedFeedback {
                        Text("✓")
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.small)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(red: 0.96, green: 0.96, blue: 0.97))
        .cornerRadius(12)
    }

    private var codeContent: String {
        CodeExporter.code(for: selectedTab, color: color)
    }

    private func copyCode() {
        let text = codeContent
        // JavaScriptKit bridge: navigator.clipboard.writeText
        let navigator = JSObject.global.navigator
        if let clipboard = navigator.clipboard.object {
            _ = clipboard.writeText!(text)
        }
        copiedFeedback = true
        // Reset feedback after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            copiedFeedback = false
        }
    }
}

struct ExportTabButtonStyle: ButtonStyle {
    let isSelected: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.caption)
            .fontWeight(isSelected ? .semibold : .regular)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(isSelected ? Color.accentColor : Color.gray.opacity(0.1))
            .foregroundColor(isSelected ? .white : .primary)
            .cornerRadius(6)
            .opacity(configuration.isPressed ? 0.8 : 1)
    }
}
