<p align="center">
  <img src="https://img.shields.io/badge/Swift-5.9+-F05138?style=flat-square&logo=swift&logoColor=white" alt="Swift 5.9+">
  <img src="https://img.shields.io/badge/Tokamak-0.12-5B5BFF?style=flat-square" alt="Tokamak 0.12">
  <img src="https://img.shields.io/badge/JavaScriptKit-0.19-F7DF1E?style=flat-square&logo=javascript&logoColor=black" alt="JavaScriptKit 0.19">
  <img src="https://img.shields.io/badge/WCAG_2.1-AA%20%7C%20AAA-success?style=flat-square" alt="WCAG 2.1">
  <img src="https://img.shields.io/badge/license-MIT-ff69b4?style=flat-square" alt="MIT">
</p>

<h1 align="center">
  🎨 TintAudit
</h1>

<p align="center">
  <b>A browser-based accessibility color studio</b><br>
  <i>Pick · Preview · Simulate · Export — all in your browser, no server needed.</i>
</p>

<br>

---

<br>

## ✨ Features

<table>
  <tr>
    <td width="50%" align="center">
      <h3>🎯 Live Contrast</h3>
      <p>Real-time WCAG 2.1 ratio as you drag sliders</p>
    </td>
    <td width="50%" align="center">
      <h3>👁️ Blindness Sims</h3>
      <p>Protanopia · Deuteranopia · Tritanopia</p>
    </td>
  </tr>
  <tr>
    <td width="50%" align="center">
      <h3>📋 Export Code</h3>
      <p>SwiftUI · CSS · Xcode Asset Catalog</p>
    </td>
    <td width="50%" align="center">
      <h3>🎨 Palette</h3>
      <p>Save colors, compare, reuse instantly</p>
    </td>
  </tr>
</table>

<br>

## 🌈 Quick Preview

```
┌─────────────────────────────────────────────────────┐
│  🎨 TintAudit                                        │
│                                                     │
│  ┌──────────────┐  ┌──────────────────────────────┐ │
│  │ R ═══════●══ │  │  Sample Heading Text          │ │
│  │ G ═══●══════ │  │  This is sample body text...  │ │
│  │ B ═════●════ │  │                              │ │
│  │ [#2D7FF9]    │  │  Contrast Ratio              │ │
│  │ 🎨 Add       │  │  ┌──────┬──────┬──────┐      │ │
│  │ Saved █ █ █  │  │  │ AA L │ AA ✅│ AAA ❌│      │ │
│  │ Bg: L D C    │  │  └──────┴──────┴──────┘      │ │
│  └──────────────┘  │  Normal ▸ Proto ▸ Deu ▸ Tri   │ │
│                    │  ┌────────────────────────────┐│ │
│                    │  │ Color(red: 0.176, ...)    ││ │
│                    │  │ [Copy]                     ││ │
│                    │  └────────────────────────────┘│ │
│                    └──────────────────────────────┘ │
└─────────────────────────────────────────────────────┘
```

<br>

## 🛠️ Tech Stack

| | |
|---|---|
| <img src="https://img.shields.io/badge/-Swift-F05138?style=flat-square&logo=swift&logoColor=white" width="90"> | **Language** — Swift 5.9+ |
| <img src="https://img.shields.io/badge/-Tokamak-5B5BFF?style=flat-square" width="90"> | **UI Framework** — SwiftUI for WebAssembly |
| <img src="https://img.shields.io/badge/-JavaScriptKit-F7DF1E?style=flat-square&logo=javascript&logoColor=black" width="90"> | **Browser Bridge** — Clipboard access |
| <img src="https://img.shields.io/badge/-Carton-6C5CE7?style=flat-square" width="90"> | **Build Tool** — SwiftWasm bundler |

<br>

## 🚀 Build & Run

```bash
# Prerequisites: Install swiftly + a swift.org toolchain
brew install swiftly && swiftly init && swiftly install 6.3

# 1. Install the WebAssembly Swift SDK
swift sdk install https://github.com/swiftwasm/swift/releases/download/swift-wasm-6.3-RELEASE/swift-wasm-6.3-RELEASE-wasm32-unknown-wasip1.artifactbundle.zip --checksum 6704d137e532f1ac31eafedd80658f9ee61239f2b6291216a02da32361ea9dcb

# 2. Build for WebAssembly
cd TintAudit
swift build --swift-sdk 6.3-RELEASE-wasm32-unknown-wasip1

# 3. Serve (use any static HTTP server)
python3 -m http.server 8080
```
> 🌐 Opens at **http://localhost:8080**

```bash
# 4. Build for production & deploy
swift build --swift-sdk 6.3-RELEASE-wasm32-unknown-wasip1 -c release
# Upload .build/wasm32-unknown-wasip1/release/ to any static host
```

<br>

## 📁 Project Structure

```
TintAudit/
├── 📦 Package.swift                  # Dependencies: Tokamak + JavaScriptKit
└── Sources/
    └── TintAudit/
        ├── 🚀 TintAuditApp.swift     # @main entry point
        ├── 📐 Models/
        │   ├── AppColor.swift        # sRGB · hex · normalized
        │   ├── ContrastResult.swift  # Ratio · grade · thresholds
        │   └── ColorBlindnessType.swift
        ├── 🧮 Logic/
        │   ├── ContrastCalculator.swift      # WCAG 2.1 luminance
        │   ├── ColorBlindnessSimulator.swift  # Matrix transforms
        │   └── CodeExporter.swift            # SwiftUI · CSS · Xcode
        └── 🖼️ Views/
            ├── ContentView.swift            # Root two-column layout
            ├── ColorPickerPanel.swift        # RGB sliders · hex input
            ├── PreviewPane.swift             # Text preview card
            ├── ContrastReportView.swift      # Ratio · AA · AAA badges
            ├── ColorBlindnessToggle.swift    # Simulation picker
            ├── PaletteView.swift             # Saved colors row
            └── CodeExportView.swift          # Tabbed code · copy
```

<br>

## 📐 WCAG Contrast Grades

| Grade | Ratio | Requirement |
|:-----:|:-----:|:------------|
| <span style="color:#10B981">✅ **AAA**</span> | ≥ 7.0 | Enhanced contrast for all text |
| <span style="color:#10B981">✅ **AA**</span> | ≥ 4.5 | Normal text (minimum) |
| <span style="color:#F59E0B">⚠️ **AA Large**</span> | ≥ 3.0 | Large text (≥18pt bold / ≥14pt) |
| <span style="color:#EF4444">❌ **Fail**</span> | < 3.0 | Does not meet minimum |

<br>

## 👁️ Color Blindness Simulations

| Type | Affected Cone | Matrix Applied |
|:-----|:--------------|:---------------|
| **Protanopia** | L-cone (red) | Red → green collapse |
| **Deuteranopia** | M-cone (green) | Green → red collapse |
| **Tritanopia** | S-cone (blue) | Blue → green collapse |

<br>

## 📄 License

<p align="center">
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-ff69b4?style=for-the-badge" alt="MIT"></a>
  <br>
  <sub>Built with 💜 using Swift + WebAssembly</sub>
</p>
