import JavaScriptKit

@main struct TintAudit {
    static var app: BrowserApp?
    static func main() {
        app = BrowserApp()
    }
}

final class BrowserApp {
    let doc: JSObject
    var palette: [AppColor] = []

    init() {
        doc = JSObject.global.document.object!
        build()
        wireEvents()
    }

    func html() -> String {"""
    <style>
      *{margin:0;padding:0;box-sizing:border-box;font-family:-apple-system,BlinkMacSystemFont,Segoe UI,sans-serif}
      body{background:#f4f4f5;display:flex;justify-content:center;min-height:100vh;padding:24px}
      .app{width:960px;max-width:100%}
      h1{font-size:20px;font-weight:700;color:#18181b;margin-bottom:4px}
      .sub{font-size:13px;color:#71717a;margin-bottom:20px}
      .paste-area{background:#fff;border-radius:10px;padding:32px 24px;margin-bottom:16px;border:1px solid #e4e4e7;text-align:center}
      .paste-area textarea{width:100%;height:120px;padding:12px;border:1.5px dashed #d4d4d8;border-radius:8px;font-size:14px;font-family:SFMono,monospace;outline:none;transition:border-color .15s;resize:vertical;color:#52525b;background:#fafafa}
      .paste-area textarea:focus{border-color:#6366f1;border-style:solid;background:#fff}
      .paste-area .hint{font-size:13px;color:#a1a1aa;margin-top:10px;margin-bottom:14px}
      .paste-area .go-btn{padding:10px 32px;border-radius:8px;border:none;font-size:14px;font-weight:600;cursor:pointer;background:#6366f1;color:#fff;transition:all .15s}
      .paste-area .go-btn:hover{background:#4f46e5}
      .input-card{background:#fff;border-radius:10px;padding:16px 20px;margin-bottom:16px;border:1px solid #e4e4e7;display:none}
      .input-card h3{font-size:12px;font-weight:600;text-transform:uppercase;letter-spacing:.5px;color:#a1a1aa;margin-bottom:10px}
      .input-row{display:flex;gap:8px}
      .input-row input{flex:1;padding:8px 12px;border:1.5px solid #e4e4e7;border-radius:6px;font-size:13px;font-family:SFMono,monospace;outline:none;transition:border-color .15s}
      .input-row input:focus{border-color:#6366f1}
      .input-row input.err{border-color:#ef4444}
      .err-text{color:#ef4444;font-size:11px;margin-top:4px;min-height:16px}
      .palette{display:flex;gap:8px;flex-wrap:wrap;margin-top:8px}
      .color-chip{display:flex;align-items:center;gap:8px;background:#fafafa;border:1px solid #e4e4e7;border-radius:8px;padding:6px 10px 6px 6px}
      .color-chip .swatch{width:24px;height:24px;border-radius:4px;flex-shrink:0;border:1px solid rgba(0,0,0,.06)}
      .color-chip .label{font-size:12px;font-family:SFMono,monospace;color:#52525b}
      .color-chip .del{width:18px;height:18px;border-radius:4px;border:none;background:transparent;color:#a1a1aa;cursor:pointer;font-size:14px;line-height:1;padding:0;display:flex;align-items:center;justify-content:center}
      .color-chip .del:hover{color:#ef4444;background:#fef2f2}
      .clear-btn{padding:6px 14px;border-radius:6px;border:1.5px solid #e4e4e7;font-size:12px;font-weight:500;cursor:pointer;background:#fff;color:#71717a;transition:all .15s}
      .clear-btn:hover{background:#f4f4f5;color:#18181b}
      .add-btn{padding:6px 14px;border-radius:6px;border:none;font-size:12px;font-weight:500;cursor:pointer;background:#6366f1;color:#fff;transition:all .15s}
      .add-btn:hover{background:#4f46e5}
      .report{display:flex;flex-direction:column;gap:12px}
      .section{background:#fff;border-radius:10px;padding:16px 20px;border:1px solid #e4e4e7}
      .section h3{font-size:12px;font-weight:600;text-transform:uppercase;letter-spacing:.5px;color:#a1a1aa;margin-bottom:12px}
      .pair{display:flex;align-items:center;gap:10px;padding:8px 0;border-bottom:1px solid #f4f4f5}
      .pair:last-child{border-bottom:none;padding-bottom:0}
      .pair:first-child{padding-top:0}
      .pair-swatches{display:flex;align-items:center;gap:3px;font-size:11px;color:#a1a1aa;font-family:SFMono,monospace;min-width:130px}
      .pair-swatches .dot{width:16px;height:16px;border-radius:3px;border:1px solid rgba(0,0,0,.06)}
      .pair-ratio{font-size:15px;font-weight:700;min-width:50px}
      .pair-badges{display:flex;gap:4px;flex:1;flex-wrap:wrap}
      .badge{font-size:10px;font-weight:600;padding:2px 8px;border-radius:4px}
      .badge.pass{background:#dcfce7;color:#166534}
      .badge.fail{background:#fef2f2;color:#991b1b}
      .badge.warn{background:#ffedd5;color:#9a3412}
      .sim-row{display:flex;gap:8px;flex-wrap:wrap;margin-top:4px}
      .sim-group{flex:1;min-width:140px}
      .sim-group .sim-label{font-size:10px;font-weight:600;color:#a1a1aa;text-transform:uppercase;letter-spacing:.4px;margin-bottom:4px}
      .sim-swatches{display:flex;gap:3px;flex-wrap:wrap}
      .sim-swatches .dot{width:18px;height:18px;border-radius:3px;border:1px solid rgba(0,0,0,.06)}
      .summary{display:flex;gap:16px;flex-wrap:wrap}
      .stat{padding:12px 16px;background:#fafafa;border-radius:8px;flex:1;min-width:120px;border:1px solid #f4f4f5}
      .stat .num{font-size:24px;font-weight:700;color:#18181b}
      .stat .lbl{font-size:11px;color:#71717a;margin-top:2px}
      .stat .num.pass{color:#16a34a}
      .stat .num.fail{color:#dc2626}
      .stat .num.warn{color:#ea580c}
      ::-webkit-scrollbar{width:5px;height:5px}
      ::-webkit-scrollbar-track{background:transparent}
      ::-webkit-scrollbar-thumb{background:#d4d4d8;border-radius:3px}
    </style>
    <div class="app">
      <h1>TintAudit</h1>
      <p class="sub">Check how accessible your color palette is.</p>
      <div class="paste-area" id="pasteArea">
        <textarea id="hexInput" placeholder="#2D7FF9&#10;#FF3B30&#10;#34C759&#10;#8B5CF6&#10;#F59E0B&#10;#EC4899"></textarea>
        <div class="hint">Paste your hex colors above (one per line or comma-separated)</div>
        <button class="go-btn" id="goBtn">Analyze Palette</button>
        <div id="errText" class="err-text" style="margin-top:8px"></div>
      </div>
      <div class="input-card" id="inputCard">
        <h3>Colors</h3>
        <div class="input-row">
          <input type="text" id="hexInput2" placeholder="#2D7FF9" autofocus>
          <button class="add-btn" id="addBtn">Add</button>
        </div>
        <div class="palette" id="palette">\(paletteHTML())</div>
      </div>
      <div class="report" id="report">\(reportHTML())</div>
    </div>
    """}

    func paletteHTML() -> String {
        palette.enumerated().map { i, c in
            "<div class=\"color-chip\"><div class=\"swatch\" style=\"background:\(c.hex)\"></div><span class=\"label\">\(c.hex)</span><button class=\"del\" data-idx=\"\(i)\">×</button></div>"
        }.joined() + "<button class=\"clear-btn\" id=\"clearBtn\">Clear all</button>"
    }

    func reportHTML() -> String {
        guard palette.count >= 2 else {
            return "<div class=\"section\"><h3>Report</h3><p style=\"font-size:13px;color:#a1a1aa\">Add at least 2 colors to see contrast analysis.</p></div>"
        }
        var pairsHTML = ""
        var pass = 0, fail = 0, warn = 0
        for i in 0..<palette.count {
            for j in (i+1)..<palette.count {
                let fg = palette[i], bg = palette[j]
                let r = ContrastCalculator.check(fg, bg)
                let cls: String
                if r.ratio >= 4.5 { cls = "pass"; pass += 1 }
                else if r.ratio >= 3.0 { cls = "warn"; warn += 1 }
                else { cls = "fail"; fail += 1 }
                let color = r.ratio >= 4.5 ? "#16a34a" : r.ratio >= 3.0 ? "#ea580c" : "#dc2626"
                let aaBadge: String = {
                    if r.ratio >= 4.5 { return "AA" }
                    if r.ratio >= 3.0 { return "AA Large" }
                    return "AA ✗"
                }()
                let aaaBadge: String = r.ratio >= 7 ? "AAA" : "AAA ✗"
                pairsHTML += """
                <div class="pair">
                  <div class="pair-swatches">
                    <div class="dot" style="background:\(fg.hex)"></div>
                    <span>\(fg.hex)</span>
                    <span style="margin:0 2px">/</span>
                    <div class="dot" style="background:\(bg.hex)"></div>
                    <span>\(bg.hex)</span>
                  </div>
                  <div class="pair-ratio" style="color:\(color)">\(String(format:"%.2f",r.ratio)):1</div>
                  <div class="pair-badges">
                    <span class="badge \(cls)">\(r.grade.rawValue)</span>
                    <span class="badge \(cls)">\(aaBadge)</span>
                    <span class="badge \(r.ratio>=7 ? "pass" : "fail")">\(aaaBadge)</span>
                  </div>
                </div>
                """
            }
        }
        let total = pass + fail + warn
        let passPct = total > 0 ? Int(Double(pass) / Double(total) * 100) : 0
        return """
        <div class="section">
          <h3>Summary</h3>
          <div class="summary">
            <div class="stat"><div class="num pass">\(pass)</div><div class="lbl">Pass AA</div></div>
            <div class="stat"><div class="num warn">\(warn)</div><div class="lbl">AA Large only</div></div>
            <div class="stat"><div class="num fail">\(fail)</div><div class="lbl">Fail</div></div>
            <div class="stat"><div class="num">\(passPct)%</div><div class="lbl">Pass rate</div></div>
          </div>
        </div>
        <div class="section">
          <h3>Pairwise Contrast</h3>
          \(pairsHTML.isEmpty ? "<p style=\"font-size:13px;color:#a1a1aa\">Add at least 2 colors.</p>" : pairsHTML)
        </div>
        <div class="section">
          <h3>Color Blindness Simulation</h3>
          \(simHTML())
        </div>
        """
    }

    func simHTML() -> String {
        let types: [ColorBlindnessType] = [.protanopia, .deuteranopia, .tritanopia]
        return types.map { t in
            "<div class=\"sim-group\"><div class=\"sim-label\">\(t.rawValue)</div><div class=\"sim-swatches\">" +
            palette.map { c in
                let s = ColorBlindnessSimulator.simulate(c, for: t)
                return "<div class=\"dot\" style=\"background:\(s.hex)\" title=\"\(c.hex) → \(s.hex)\"></div>"
            }.joined() + "</div></div>"
        }.joined()
    }

    func build() {
        if let b = doc.body.object { _ = b.innerHTML = JSValue.string(html()) }
    }

    func refresh() {
        _ = doc.getElementById!("palette").innerHTML = JSValue.string(paletteHTML())
        _ = doc.getElementById!("report").innerHTML = JSValue.string(reportHTML())
    }

    func wireEvents() {
        let root = doc.body.object!

        _ = root.addEventListener!("click", JSClosure { [weak self] args in
            guard let self = self, let ev = args.first?.object, let target = ev.target.object else { return .undefined }
            let id = target.id.string ?? ""
            if id == "goBtn" { self.analyze(); return .undefined }
            if id == "addBtn" { self.addColor(); return .undefined }
            if id == "clearBtn" { self.palette = []; self.refresh(); return .undefined }
            if let idx = target.getAttribute!("data-idx").string, let i = Int(idx), i < self.palette.count {
                self.palette.remove(at: i); self.refresh()
            }
            return .undefined
        })

        _ = root.addEventListener!("keydown", JSClosure { [weak self] args in
            guard let self = self, let ev = args.first?.object else { return .undefined }
            if ev.key.string == "Enter" { self.addColor() }
            return .undefined
        })
    }

    func analyze() {
        let raw = doc.getElementById!("hexInput").value.string ?? ""
        guard !raw.isEmpty else {
            _ = doc.getElementById!("errText").textContent = JSValue.string("Paste some hex colors first")
            return
        }
        let parts = raw.split { $0 == "," || $0 == "\n" || $0 == "\r" }.map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
        var added = false
        for p in parts {
            if let c = AppColor(hex: p) {
                if !palette.contains(c) { palette.append(c); added = true }
            }
        }
        if !added {
            _ = doc.getElementById!("errText").textContent = JSValue.string("No valid hex colors found")
            return
        }
        _ = doc.getElementById!("errText").textContent = JSValue.string("")
        _ = doc.getElementById!("pasteArea").style.display = JSValue.string("none")
        _ = doc.getElementById!("inputCard").style.display = JSValue.string("block")
        refresh()
    }

    func addColor() {
        let raw = doc.getElementById!("hexInput2").value.string ?? ""
        guard !raw.isEmpty else { return }
        let parts = raw.split { $0 == "," || $0 == " " || $0 == "\n" }.map(String.init)
        var added = false
        for p in parts {
            if let c = AppColor(hex: p) {
                if !palette.contains(c) { palette.append(c); added = true }
            }
        }
        _ = doc.getElementById!("hexInput2").value = JSValue.string("")
        if added { refresh() }
    }
}
