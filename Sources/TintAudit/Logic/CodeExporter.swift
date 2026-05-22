import Foundation

enum ExportTab: String, CaseIterable {
    case swiftUI = "SwiftUI"
    case css = "CSS"
    case xcode = "Xcode Asset"
}

// Generates platform-specific color declarations
struct CodeExporter {

    // SwiftUI: Color(red:green:blue:) with 0-1 normalized values
    static func swiftUICode(for color: AppColor) -> String {
        let nr = ((color.r / 255.0) * 1000).rounded() / 1000
        let ng = ((color.g / 255.0) * 1000).rounded() / 1000
        let nb = ((color.b / 255.0) * 1000).rounded() / 1000
        return "Color(red: \(nr), green: \(ng), blue: \(nb))"
    }

    // CSS custom property with hex value
    static func cssCode(for color: AppColor) -> String {
        return "--my-color: \(color.hex);"
    }

    // Xcode Asset Catalog JSON matching Contents.json format for a .colorset
    static func xcodeAssetJSON(for color: AppColor) -> String {
        let nr = String(format: "%.3f", color.r / 255.0)
        let ng = String(format: "%.3f", color.g / 255.0)
        let nb = String(format: "%.3f", color.b / 255.0)
        return """
{
  "colors": [
    {
      "color": {
        "color-space": "srgb",
        "components": {
          "red": "\(nr)",
          "green": "\(ng)",
          "blue": "\(nb)",
          "alpha": "1.000"
        }
      },
      "idiom": "universal"
    }
  ],
  "info": {
    "author": "xcode",
    "version": 1
  }
}
"""
    }

    static func code(for tab: ExportTab, color: AppColor) -> String {
        switch tab {
        case .swiftUI:
            return swiftUICode(for: color)
        case .css:
            return cssCode(for: color)
        case .xcode:
            return xcodeAssetJSON(for: color)
        }
    }
}
