# TintAudit

A browser-based accessibility color studio built with Swift, Tokamak (SwiftUI for WebAssembly), and JavaScriptKit. Runs entirely client-side – no backend, no server.

## Features

- Pick colors with RGB sliders or hex input
- Check WCAG 2.1 contrast ratios in real-time
- Simulate color blindness (Protanopia, Deuteranopia, Tritanopia)
- Export code for SwiftUI, CSS, and Xcode Asset Catalogs
- Save and compare colors in a palette

## Tech Stack

- **Language:** Swift 5.9+
- **UI Framework:** Tokamak (SwiftUI-compatible for WebAssembly)
- **Browser Bridge:** JavaScriptKit (clipboard access)
- **Build Tool:** Carton (SwiftWasm)

## Build & Run

1. **Install Carton:**

   ```bash
   brew install swiftwasm/tap/carton
   ```

2. **Run locally:**

   ```bash
   cd TintAudit
   carton dev
   ```

   Opens at `http://localhost:8080`.

3. **Build for production:**

   ```bash
   carton bundle
   ```

4. **Deploy:**

   Upload the `Bundle/` folder to any static host (Vercel, Netlify, GitHub Pages, etc.).

## Project Structure

```
TintAudit/
├── Package.swift
├── Sources/
│   └── TintAudit/
│       ├── TintAuditApp.swift         // Entry point
│       ├── Models/
│       │   ├── AppColor.swift
│       │   ├── ContrastResult.swift
│       │   └── ColorBlindnessType.swift
│       ├── Logic/
│       │   ├── ContrastCalculator.swift      // WCAG 2.1 formula
│       │   ├── ColorBlindnessSimulator.swift  // Matrix transforms
│       │   └── CodeExporter.swift            // SwiftUI/CSS/Xcode
│       └── Views/
│           ├── ContentView.swift
│           ├── ColorPickerPanel.swift
│           ├── PreviewPane.swift
│           ├── ContrastReportView.swift
│           ├── ColorBlindnessToggle.swift
│           ├── PaletteView.swift
│           └── CodeExportView.swift
```

## License

MIT
