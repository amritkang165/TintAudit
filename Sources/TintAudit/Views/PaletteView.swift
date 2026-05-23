import TokamakShim

struct PaletteView: View {
    let palette: [AppColor]
    let onSelect: (AppColor) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Saved Colors")
                .font(.headline)

            if palette.isEmpty {
                Text("No saved colors yet")
                    .font(.caption)
                    .foregroundColor(.secondary)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(Array(palette.enumerated()), id: \.offset) { _, color in
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color(red: color.r / 255,
                                            green: color.g / 255,
                                            blue: color.b / 255))
                                .frame(width: 36, height: 36)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(Color.gray.opacity(0.3))
                                )
                                .onTapGesture { onSelect(color) }
                        }
                    }
                }
            }
        }
    }
}
