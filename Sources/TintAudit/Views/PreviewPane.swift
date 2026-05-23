import TokamakShim

struct PreviewPane: View {
    let foreground: AppColor
    let background: AppColor

    var body: some View {
        VStack(spacing: 12) {
            Text("Sample Heading Text")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(Color(red: foreground.r / 255,
                                       green: foreground.g / 255,
                                       blue: foreground.b / 255))

            Text("This is sample body text for previewing your color combination.")
                .font(.system(size: 16))
                .foregroundColor(Color(red: foreground.r / 255,
                                       green: foreground.g / 255,
                                       blue: foreground.b / 255))
                .multilineTextAlignment(.center)
        }
        .padding(32)
        .frame(maxWidth: .infinity)
        .background(Color(red: background.r / 255,
                          green: background.g / 255,
                          blue: background.b / 255))
        .cornerRadius(12)
    }
}
