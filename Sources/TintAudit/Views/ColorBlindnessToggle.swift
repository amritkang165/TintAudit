import TokamakShim

struct ColorBlindnessToggle: View {
    @Binding var selection: ColorBlindnessType

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Color Blindness Simulation")
                .font(.headline)

            HStack(spacing: 6) {
                ForEach(ColorBlindnessType.allCases, id: \.self) { type in
                    Button(type.rawValue) {
                        selection = type
                    }
                    .buttonStyle(
                        BlindnessButtonStyle(isSelected: selection == type)
                    )
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(red: 0.96, green: 0.96, blue: 0.97))
        .cornerRadius(12)
    }
}

struct BlindnessButtonStyle: ButtonStyle {
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
