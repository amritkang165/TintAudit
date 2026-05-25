import TokamakShim

// Background modes for the preview pane
enum BackgroundMode: String, CaseIterable {
    case light = "Light"
    case dark = "Dark"
    case custom = "Custom"
}

// Root layout: two-column design with color controls on the left
// and live preview, contrast report, and export tools on the right.
struct ContentView: View {
    @State private var selectedColor = AppColor(r: 45, g: 127, b: 249)
    @State private var palette: [AppColor] = []
    @State private var activeBlindness: ColorBlindnessType = .normal
    @State private var selectedExportTab: ExportTab = .swiftUI
    @State private var bgMode: BackgroundMode = .light
    @State private var hexInput: String = "#2D7FF9"
    @State private var hexError: Bool = false
    @State private var customBgColor = AppColor(r: 200, g: 200, b: 200)

    private var backgroundColor: AppColor {
        switch bgMode {
        case .light:
            return AppColor(r: 255, g: 255, b: 255)
        case .dark:
            return AppColor(r: 0, g: 0, b: 0)
        case .custom:
            return customBgColor
        }
    }

    private var displayedForeground: AppColor {
        guard activeBlindness != .normal else { return selectedColor }
        return ColorBlindnessSimulator.simulate(selectedColor, for: activeBlindness)
    }

    private var displayedBackground: AppColor {
        guard activeBlindness != .normal else { return backgroundColor }
        return ColorBlindnessSimulator.simulate(backgroundColor, for: activeBlindness)
    }

    var body: some View {
        HStack(spacing: 0) {
            leftPanel
                .frame(width: 300)
                .background(Color(red: 0.96, green: 0.96, blue: 0.97))

            Divider()

            rightPanel
        }
        .frame(minWidth: 800, maxWidth: 1200)
        .frame(height: 700)
    }

    // MARK: - Left Panel

    private var leftPanel: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("A11y Color Studio")
                    .font(.title)
                    .fontWeight(.bold)

                ColorPickerPanel(
                    selectedColor: $selectedColor,
                    palette: $palette,
                    hexInput: $hexInput,
                    hexError: $hexError
                )

                Divider()

                PaletteView(palette: palette, selectedColor: selectedColor) { color in
                    selectedColor = color
                    hexInput = color.hex
                    hexError = false
                }

                Divider()

                backgroundSection
            }
            .padding()
        }
    }

    // MARK: - Background Mode

    private var backgroundSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Background")
                .font(.headline)

            HStack(spacing: 6) {
                ForEach(BackgroundMode.allCases, id: \.self) { mode in
                    Button(mode.rawValue) {
                        bgMode = mode
                    }
                    .buttonStyle(
                        BlindnessButtonStyle(isSelected: bgMode == mode)
                    )
                }
            }

            if bgMode == .custom {
                customBgControls
            }
        }
    }

    private var customBgControls: some View {
        VStack(spacing: 6) {
            HStack {
                Text("R")
                    .foregroundColor(.red)
                    .frame(width: 14)
                Slider(value: Binding(
                    get: { customBgColor.r },
                    set: { customBgColor = AppColor(r: $0, g: customBgColor.g, b: customBgColor.b) }
                ), in: 0...255, step: 1)
                Text("\(Int(customBgColor.r))")
                    .frame(width: 30, alignment: .trailing)
                    .font(.caption.monospacedDigit())
            }

            HStack {
                Text("G")
                    .foregroundColor(.green)
                    .frame(width: 14)
                Slider(value: Binding(
                    get: { customBgColor.g },
                    set: { customBgColor = AppColor(r: customBgColor.r, g: $0, b: customBgColor.b) }
                ), in: 0...255, step: 1)
                Text("\(Int(customBgColor.g))")
                    .frame(width: 30, alignment: .trailing)
                    .font(.caption.monospacedDigit())
            }

            HStack {
                Text("B")
                    .foregroundColor(.blue)
                    .frame(width: 14)
                Slider(value: Binding(
                    get: { customBgColor.b },
                    set: { customBgColor = AppColor(r: customBgColor.r, g: customBgColor.g, b: $0) }
                ), in: 0...255, step: 1)
                Text("\(Int(customBgColor.b))")
                    .frame(width: 30, alignment: .trailing)
                    .font(.caption.monospacedDigit())
            }

            RoundedRectangle(cornerRadius: 6)
                .fill(Color(red: customBgColor.r / 255,
                            green: customBgColor.g / 255,
                            blue: customBgColor.b / 255))
                .frame(height: 24)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.gray.opacity(0.3))
                )
        }
    }

    // MARK: - Right Panel

    private var rightPanel: some View {
        ScrollView {
            VStack(spacing: 20) {
                PreviewPane(
                    foreground: displayedForeground,
                    background: displayedBackground
                )

                ContrastReportView(
                    result: ContrastCalculator.check(selectedColor, backgroundColor)
                )

                ColorBlindnessToggle(selection: $activeBlindness)

                CodeExportView(
                    color: selectedColor,
                    selectedTab: $selectedExportTab
                )
            }
            .padding()
        }
    }
}
