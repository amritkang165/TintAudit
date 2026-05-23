import TokamakShim

struct ColorPickerPanel: View {
    @Binding var selectedColor: AppColor
    @Binding var palette: [AppColor]
    @Binding var hexInput: String
    @Binding var hexError: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Foreground Color")
                .font(.headline)

            // ——— Red slider ———
            HStack {
                Text("R").foregroundColor(.red).frame(width: 16)
                Slider(value: Binding(
                    get: { selectedColor.r },
                    set: {
                        selectedColor = AppColor(r: $0, g: selectedColor.g, b: selectedColor.b)
                        hexInput = selectedColor.hex
                        hexError = false
                    }
                ), in: 0...255, step: 1)
                Text("\(Int(selectedColor.r))")
                    .frame(width: 36, alignment: .trailing)
                    .font(.caption.monospacedDigit())
            }

            // ——— Green slider ———
            HStack {
                Text("G").foregroundColor(.green).frame(width: 16)
                Slider(value: Binding(
                    get: { selectedColor.g },
                    set: {
                        selectedColor = AppColor(r: selectedColor.r, g: $0, b: selectedColor.b)
                        hexInput = selectedColor.hex
                        hexError = false
                    }
                ), in: 0...255, step: 1)
                Text("\(Int(selectedColor.g))")
                    .frame(width: 36, alignment: .trailing)
                    .font(.caption.monospacedDigit())
            }

            // ——— Blue slider ———
            HStack {
                Text("B").foregroundColor(.blue).frame(width: 16)
                Slider(value: Binding(
                    get: { selectedColor.b },
                    set: {
                        selectedColor = AppColor(r: selectedColor.r, g: selectedColor.g, b: $0)
                        hexInput = selectedColor.hex
                        hexError = false
                    }
                ), in: 0...255, step: 1)
                Text("\(Int(selectedColor.b))")
                    .frame(width: 36, alignment: .trailing)
                    .font(.caption.monospacedDigit())
            }

            // ——— Hex input ———
            HStack {
                TextField("Hex (e.g. #2D7FF9)", text: $hexInput, onCommit: commitHex)
                    .textFieldStyle(.roundedBorder)
                    .font(.system(.body, design: .monospaced))
                Button("Set") {
                    commitHex()
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.small)
            }

            if hexError {
                let message: String = {
                    let trimmed = hexInput.trimmingCharacters(in: .whitespacesAndNewlines)
                    if trimmed.isEmpty { return "Hex value cannot be empty" }
                    let stripped = trimmed.hasPrefix("#") ? String(trimmed.dropFirst()) : trimmed
                    if stripped.count != 6 { return "Hex must be exactly 6 characters (e.g. #2D7FF9)" }
                    if stripped.range(of: "^[0-9A-Fa-f]{6}$", options: .regularExpression) == nil {
                        return "Hex contains invalid characters (use 0-9, A-F)"
                    }
                    return "Invalid hex value"
                }()
                Text(message)
                    .foregroundColor(.red)
                    .font(.caption)
            }

            // ——— Color swatch + Add to palette ———
            HStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(red: selectedColor.r / 255,
                                green: selectedColor.g / 255,
                                blue: selectedColor.b / 255))
                    .frame(width: 44, height: 44)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.3))
                    )

                Text(selectedColor.hex)
                    .font(.system(.body, design: .monospaced))

                Spacer()

                Button("Add to Palette") {
                    palette.append(selectedColor)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.small)
            }
        }
    }

    private func commitHex() {
        if let color = AppColor(hex: hexInput) {
            selectedColor = color
            hexInput = color.hex
            hexError = false
        } else {
            hexError = true
        }
    }
}
