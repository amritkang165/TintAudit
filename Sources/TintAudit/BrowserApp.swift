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
        sync()
        if let qs = JSObject.global.location.object?.search.string, qs.contains("demo") {
            loadExample()
        }
    }

    func html() -> String {"""
    <style>
      *{margin:0;padding:0;box-sizing:border-box}
      html{scroll-behavior:smooth}
      ::selection{background:rgba(99,102,241,.18)}
      body{font-family:-apple-system,BlinkMacSystemFont,"Inter","Segoe UI",Roboto,sans-serif;background:linear-gradient(180deg,#f2f4f9,#eaedf4);display:flex;justify-content:center;min-height:100vh;padding:32px 20px 80px;color:#0f172a}
      .app{width:980px;max-width:100%}

      .hero{background:radial-gradient(1100px 400px at 18% -10%,rgba(99,102,241,.4),transparent 60%),linear-gradient(140deg,#0d1220 0%,#151d38 55%,#221848 100%);border-radius:28px;padding:46px 44px 92px;position:relative;overflow:hidden;box-shadow:0 24px 60px -20px rgba(15,23,42,.5)}
      .hero::before{content:"";position:absolute;width:360px;height:360px;right:-90px;top:-140px;border-radius:50%;background:radial-gradient(circle,rgba(168,85,247,.3),transparent 65%)}
      .brand{display:flex;align-items:center;gap:12px}
      .logo{width:38px;height:38px;border-radius:11px;background:linear-gradient(135deg,#6366f1,#a855f7);display:flex;align-items:center;justify-content:center;font-size:19px;font-weight:800;color:#fff;box-shadow:0 8px 20px -6px rgba(99,102,241,.6)}
      .brand h1{font-size:22px;font-weight:800;letter-spacing:-.5px;color:#fff}
      .brand .pill{font-size:10px;font-weight:700;letter-spacing:1px;color:#a5b4fc;background:rgba(99,102,241,.18);border:1px solid rgba(129,140,248,.35);padding:3px 9px;border-radius:999px;margin-left:4px}
      .tagline{font-size:14.5px;color:#93a1bd;margin-top:9px;max-width:540px;line-height:1.6}

      .paste-area{position:relative;z-index:2;margin-top:-48px;background:#fff;border-radius:20px;padding:30px;box-shadow:0 20px 50px -18px rgba(15,23,42,.35);margin-bottom:22px;text-align:center;animation:rise .4s ease both}
      .dots{display:flex;justify-content:center;gap:7px;margin-bottom:13px}
      .dots i{width:9px;height:9px;border-radius:50%;display:block}
      .paste-area h2{font-size:17px;font-weight:700;letter-spacing:-.2px}
      .paste-area .hint{font-size:13px;color:#94a3b8;margin:5px 0 16px}
      .paste-area textarea{width:100%;height:132px;padding:15px 16px;border:2px dashed #dbe1ec;border-radius:12px;font-size:13.5px;font-family:"SF Mono",SFMono-Regular,ui-monospace,Menlo,monospace;outline:none;transition:all .2s;resize:vertical;color:#334155;background:#f7f8fc;line-height:1.7;letter-spacing:.2px}
      .paste-area textarea:focus{border-color:#818cf8;border-style:solid;background:#fff;box-shadow:0 0 0 4px rgba(99,102,241,.1)}
      .paste-area textarea::placeholder{color:#b3bccd}
      .live-preview{display:flex;flex-wrap:wrap;gap:6px;justify-content:center;margin-top:14px}
      .live-preview .lp{display:inline-flex;align-items:center;gap:6px;font-size:11px;font-family:monospace;font-weight:600;color:#475569;background:#f7f8fc;border:1px solid #e6e9f0;padding:4px 10px 4px 5px;border-radius:8px}
      .live-preview .lp b{width:14px;height:14px;border-radius:4px}
      .actions{display:flex;align-items:center;justify-content:center;gap:10px;margin-top:16px}
      .go-btn{padding:11px 32px;border-radius:11px;border:none;font-size:14px;font-weight:700;cursor:pointer;color:#fff;background:linear-gradient(135deg,#6366f1,#7c3aed);box-shadow:0 10px 24px -8px rgba(99,102,241,.65);transition:all .18s}
      .go-btn:hover{transform:translateY(-1px);box-shadow:0 14px 28px -8px rgba(99,102,241,.75)}
      .go-btn:active{transform:translateY(0)}
      .eg-btn{padding:11px 18px;border-radius:11px;border:1px solid #e2e6ee;font-size:13px;font-weight:600;cursor:pointer;background:#fff;color:#64748b;transition:all .18s}
      .eg-btn:hover{background:#f4f5f9;color:#0f172a;border-color:#cbd2de}
      #errText{color:#ef4444;font-size:12px;margin-top:10px;font-weight:500}

      .toolbar{display:none;align-items:center;justify-content:space-between;margin:6px 0 16px;flex-wrap:wrap;gap:12px;animation:rise .3s ease both}
      .toolbar-left{display:flex;align-items:center;gap:10px;flex-wrap:wrap}
      .toolbar h2{font-size:15px;font-weight:700;letter-spacing:-.2px}
      .toolbar .count{font-size:11px;font-weight:600;color:#94a3b8;background:#eef0f6;padding:2px 9px;border-radius:999px}
      .add-row{display:flex;gap:6px}
      .add-row input{width:118px;padding:8px 11px;border:1.5px solid #dfe3ec;border-radius:9px;font-size:12.5px;font-family:monospace;outline:none;transition:all .15s;background:#fff}
      .add-row input:focus{border-color:#818cf8;box-shadow:0 0 0 3px rgba(99,102,241,.12)}
      .add-btn{padding:8px 14px;border-radius:9px;border:none;font-size:14px;font-weight:700;cursor:pointer;color:#fff;background:#6366f1;transition:all .15s}
      .add-btn:hover{background:#4f46e5}
      .clear-btn{padding:8px 14px;border-radius:9px;border:1px solid #dfe3ec;font-size:12px;font-weight:600;cursor:pointer;background:#fff;color:#64748b;transition:all .15s}
      .clear-btn:hover{background:#fff5f5;color:#dc2626;border-color:#fecaca}

      .palette{display:flex;gap:8px;flex-wrap:wrap;margin-bottom:22px;animation:rise .3s ease both}
      .chip{display:inline-flex;align-items:center;gap:8px;background:#fff;border:1px solid #e6e9f0;border-radius:999px;padding:6px 10px 6px 6px;box-shadow:0 2px 6px -2px rgba(15,23,42,.06);transition:all .15s}
      .chip:hover{border-color:#cdd2dd;box-shadow:0 4px 10px -3px rgba(15,23,42,.12);transform:translateY(-1px)}
      .chip .dot{width:22px;height:22px;border-radius:999px;flex-shrink:0;border:1px solid rgba(0,0,0,.07)}
      .chip .label{font-size:11.5px;font-family:monospace;color:#475569;font-weight:600}
      .chip .del{width:19px;height:19px;border-radius:999px;border:none;background:#f1f3f8;color:#94a3b8;cursor:pointer;font-size:12px;line-height:1;padding:0;display:flex;align-items:center;justify-content:center;transition:all .15s}
      .chip .del:hover{background:#fee2e2;color:#dc2626}

      .report{display:flex;flex-direction:column;gap:16px}
      .card{background:#fff;border-radius:18px;padding:22px 26px;border:1px solid #e8ebf1;box-shadow:0 8px 24px -16px rgba(15,23,42,.18);animation:rise .35s ease both}
      .card h3{font-size:11px;font-weight:700;text-transform:uppercase;letter-spacing:.8px;color:#a0a8b8;margin-bottom:14px}

      .score-card{display:flex;align-items:center;gap:22px;flex-wrap:wrap}
      .score-left{display:flex;align-items:center;gap:16px;flex:1;min-width:220px}
      .grade{width:64px;height:64px;border-radius:20px;display:flex;align-items:center;justify-content:center;font-size:28px;font-weight:800;color:#fff;flex-shrink:0;letter-spacing:-1px;box-shadow:0 10px 24px -10px rgba(15,23,42,.4)}
      .grade.g-A{background:linear-gradient(135deg,#10b981,#059669)}
      .grade.g-B{background:linear-gradient(135deg,#22c55e,#16a34a)}
      .grade.g-C{background:linear-gradient(135deg,#fbbf24,#f59e0b)}
      .grade.g-D{background:linear-gradient(135deg,#fb923c,#f97316)}
      .grade.g-F{background:linear-gradient(135deg,#f87171,#ef4444)}
      .score-title{font-size:15px;font-weight:700;letter-spacing:-.2px}
      .score-sub{font-size:12.5px;color:#94a3b8;margin-top:3px}
      .stats{display:grid;grid-template-columns:repeat(auto-fit,minmax(118px,1fr));gap:10px;flex:2;min-width:320px}
      .stat{padding:13px 12px;background:#f8f9fc;border-radius:12px;text-align:center;border:1px solid #eef1f6}
      .stat .num{font-size:24px;font-weight:800;letter-spacing:-.5px}
      .stat .num.green{color:#10b981}
      .stat .num.orange{color:#f59e0b}
      .stat .num.red{color:#ef4444}
      .stat .num.slate{color:#0f172a}
      .stat .lbl{font-size:10.5px;color:#94a3b8;margin-top:2px;font-weight:600}
      .stat .sml{font-size:9px;color:#cbd2de;margin-top:1px}

      .pairs{display:flex;flex-direction:column}
      .pair{display:grid;grid-template-columns:56px 1fr auto auto;align-items:center;gap:14px;padding:11px 0;border-bottom:1px solid #f1f3f8}
      .pair:last-child{border-bottom:none;padding-bottom:2px}
      .pair-preview{width:56px;height:38px;border-radius:10px;display:flex;align-items:center;justify-content:center;font-size:15px;font-weight:800;border:1px solid rgba(0,0,0,.05)}
      .pair-colors{display:flex;align-items:center;gap:6px;font-size:12px;font-family:monospace;color:#64748b;font-weight:600}
      .pair-colors .dot{width:16px;height:16px;border-radius:5px;border:1px solid rgba(0,0,0,.06)}
      .pair-colors .arrow{color:#cbd2de;font-weight:400}
      .pair-ratio{font-size:19px;font-weight:800;letter-spacing:-.4px;font-variant-numeric:tabular-nums}
      .pair-badges{display:flex;gap:5px;flex-wrap:wrap;justify-content:flex-end}
      .badge{font-size:10px;font-weight:700;padding:4px 10px;border-radius:7px;letter-spacing:.2px}
      .badge.green{background:#e7f9f1;color:#059669}
      .badge.yellow{background:#fff6e0;color:#d97706}
      .badge.red{background:#feecec;color:#dc2626}
      .badge.slate{background:#f0f2f7;color:#64748b}
      .pair-fix{display:flex;align-items:center;gap:8px;flex-wrap:wrap;grid-column:1/-1;background:#f6f7fc;border:1px dashed #e3e7f0;border-radius:10px;padding:8px 12px;margin-top:2px;font-size:11.5px}
      .fix-tag{font-size:9px;font-weight:800;text-transform:uppercase;letter-spacing:.6px;color:#6366f1;background:#eef2ff;padding:3px 7px;border-radius:6px}
      .fix-text{color:#94a3b8;font-weight:500}
      .swx{width:18px;height:18px;border-radius:6px;border:1px solid rgba(0,0,0,.06);flex-shrink:0}
      .mono-x{font-family:monospace;color:#64748b;font-weight:600;font-size:11.5px}
      .mono-x.strong-x{color:#0f172a;font-weight:700}
      .arrow-x{color:#cbd2de}
      .fix-ratio{font-size:11.5px;font-weight:700;color:#059669;background:#e7f9f1;padding:3px 8px;border-radius:6px}
      .use-btn{padding:5px 12px;border-radius:7px;border:none;font-size:11px;font-weight:700;cursor:pointer;color:#fff;background:linear-gradient(135deg,#6366f1,#7c3aed);transition:all .15s}
      .use-btn:hover{transform:translateY(-1px);box-shadow:0 6px 14px -6px rgba(99,102,241,.6)}

      .sims{display:grid;grid-template-columns:repeat(auto-fit,minmax(210px,1fr));gap:14px}
      .sim{background:#f8f9fc;border:1px solid #eef1f6;border-radius:14px;padding:14px}
      .sim h4{font-size:11px;font-weight:700;color:#94a3b8;margin-bottom:10px;text-transform:uppercase;letter-spacing:.5px;display:flex;align-items:center;gap:6px}
      .sim h4 i{width:8px;height:8px;border-radius:50%}
      .sim-row{display:flex;align-items:center;gap:6px;margin-bottom:7px}
      .sim-row:last-child{margin-bottom:0}
      .sim-row .sw{width:44px;height:30px;border-radius:8px;display:flex;align-items:center;justify-content:center;font-size:12px;font-weight:800;color:#1f2937;border:1px solid rgba(0,0,0,.05);flex-shrink:0}
      .sim-row .lbl{font-size:10.5px;font-family:monospace;color:#94a3b8;flex:1;min-width:0}
      .sim-row .arr{color:#d3d9e4;font-size:11px}

      .empty-state{padding:36px 20px;text-align:center}
      .empty-state .big-icon{font-size:42px;margin-bottom:10px;opacity:.5}
      .empty-state p{font-size:13.5px;color:#94a3b8}

      @keyframes rise{from{opacity:0;transform:translateY(8px)}to{opacity:1;transform:translateY(0)}}
      ::-webkit-scrollbar{width:5px;height:5px}
      ::-webkit-scrollbar-track{background:transparent}
      ::-webkit-scrollbar-thumb{background:#cdd3df;border-radius:3px}
      @media(max-width:640px){body{padding:16px}.hero{padding:32px 22px 78px;border-radius:20px}.paste-area{padding:22px 16px;margin-top:-40px}.pair{grid-template-columns:48px 1fr;gap:8px 12px}.pair-ratio{justify-self:start}.pair-badges{grid-column:2;justify-content:flex-start}.score-card{gap:14px}.stats{min-width:0}}
    </style>
    <div class="app">
      <div class="hero">
        <div class="brand"><div class="logo">T</div><h1>TintAudit</h1><span class="pill">WCAG</span></div>
        <p class="tagline">Paste your palette, get instant contrast ratios and color blindness simulations.</p>
      </div>
      <div class="paste-area" id="pasteArea">
        <div class="dots"><i style="background:#6366f1"></i><i style="background:#f59e0b"></i><i style="background:#ef4444"></i></div>
        <h2>Enter your colors</h2>
        <p class="hint">One hex per line, comma-separated, or paste a full list</p>
        <textarea id="hexInput" placeholder="#2D7FF9&#10;#FF3B30&#10;#34C759&#10;#8B5CF6&#10;#F59E0B&#10;#EC4899"></textarea>
        <div class="live-preview" id="livePreview"></div>
        <div class="actions">
          <button class="eg-btn" id="egBtn">Try an example</button>
          <button class="go-btn" id="goBtn">Analyze palette</button>
        </div>
        <div id="errText"></div>
      </div>
      <div class="toolbar" id="toolbar">
        <div class="toolbar-left">
          <h2>Palette</h2>
          <span class="count" id="palCount">0 colors</span>
          <div class="add-row">
            <input type="text" id="hexAdd" placeholder="#2D7FF9">
            <button class="add-btn" id="addBtn">+</button>
          </div>
        </div>
        <button class="clear-btn" id="clearBtn">Clear all</button>
      </div>
      <div class="palette" id="palette">\(paletteHTML())</div>
      <div class="report" id="report">\(reportHTML())</div>
    </div>
    """}

    func paletteHTML() -> String {
        palette.enumerated().map { i, c in
            "<div class=\"chip\"><div class=\"dot\" style=\"background:\(c.hex)\"></div><span class=\"label\">\(c.hex)</span><button class=\"del\" data-idx=\"\(i)\">✕</button></div>"
        }.joined()
    }

    func reportHTML() -> String {
        guard palette.count >= 2 else {
            return "<div class=\"card\"><h3>Report</h3><div class=\"empty-state\"><div class=\"big-icon\">📊</div><p>Add at least 2 colors to see contrast analysis.</p></div></div>"
        }
        var pairs: [(fg: AppColor, bg: AppColor, fi: Int, ratio: Double, grade: ContrastGrade, fix: (color: AppColor, ratio: Double)?)] = []
        var pass = 0, fail = 0, warn = 0
        for i in 0..<palette.count {
            for j in (i+1)..<palette.count {
                let fg = palette[i], bg = palette[j]
                let r = ContrastCalculator.check(fg, bg)
                if r.ratio >= 4.5 { pass += 1 }
                else if r.ratio >= 3.0 { warn += 1 }
                else { fail += 1 }
                let fix = r.ratio < 4.5 ? ColorSuggestor.nearestAccessible(fg: fg, bg: bg) : nil
                pairs.append((fg, bg, i, r.ratio, r.grade, fix))
            }
        }
        pairs.sort { $0.ratio < $1.ratio }
        let total = pass + fail + warn
        let passPct = total > 0 ? Int(Double(pass) / Double(total) * 100) : 0
        let gradeInfo: (String, String)
        if passPct >= 90 { gradeInfo = ("A", "g-A") }
        else if passPct >= 80 { gradeInfo = ("B", "g-B") }
        else if passPct >= 65 { gradeInfo = ("C", "g-C") }
        else if passPct >= 50 { gradeInfo = ("D", "g-D") }
        else { gradeInfo = ("F", "g-F") }
        let pairsHTML = pairs.map { p in
            let cls: String
            let color: String
            if p.ratio >= 4.5 { cls = "green"; color = "#10b981" }
            else if p.ratio >= 3.0 { cls = "yellow"; color = "#f59e0b" }
            else { cls = "red"; color = "#ef4444" }
            let aaBadge = p.ratio >= 4.5 ? "AA ✓" : p.ratio >= 3.0 ? "AA Lg" : "AA ✗"
            let aaaCls = p.ratio >= 7 ? "green" : "red"
            let aaaBadge = p.ratio >= 7 ? "AAA ✓" : "AAA ✗"
            let fixHTML: String
            if let fix = p.fix {
                fixHTML = """
                <div class="pair-fix">
                  <span class="fix-tag">Fix</span>
                  <span class="fix-text">Nearest accessible fg:</span>
                  <span class="swx" style="background:\(p.fg.hex)"></span>
                  <span class="mono-x">\(p.fg.hex)</span>
                  <span class="arrow-x">→</span>
                  <span class="swx" style="background:\(fix.color.hex)"></span>
                  <span class="mono-x strong-x">\(fix.color.hex)</span>
                  <span class="fix-ratio">\(String(format:"%.2f", fix.ratio))</span>
                  <button class="use-btn" data-fi="\(p.fi)" data-hex="\(fix.color.hex)">Use</button>
                </div>
                """
            } else {
                fixHTML = ""
            }
            return """
            <div class="pair">
              <div class="pair-preview" style="background:\(p.bg.hex);color:\(p.fg.hex)">Aa</div>
              <div class="pair-info"><div class="pair-colors">
                <div class="dot" style="background:\(p.fg.hex)"></div><span>\(p.fg.hex)</span>
                <span class="arrow">→</span>
                <div class="dot" style="background:\(p.bg.hex)"></div><span>\(p.bg.hex)</span>
              </div></div>
              <div class="pair-ratio" style="color:\(color)">\(String(format:"%.2f", p.ratio))</div>
              <div class="pair-badges">
                <span class="badge \(cls)">\(p.grade.rawValue)</span>
                <span class="badge \(cls)">\(aaBadge)</span>
                <span class="badge \(aaaCls)">\(aaaBadge)</span>
              </div>
              \(fixHTML)
            </div>
            """
        }.joined()
        return """
        <div class="card score-card">
          <div class="score-left">
            <div class="grade \(gradeInfo.1)">\(gradeInfo.0)</div>
            <div>
              <div class="score-title">Palette Health</div>
              <div class="score-sub">\(passPct)% of \(total) pairs pass WCAG AA</div>
            </div>
          </div>
          <div class="stats">
            <div class="stat"><div class="num green">\(pass)</div><div class="lbl">Pass AA</div></div>
            <div class="stat"><div class="num orange">\(warn)</div><div class="lbl">AA Large only</div></div>
            <div class="stat"><div class="num red">\(fail)</div><div class="lbl">Fail</div></div>
            <div class="stat"><div class="num slate">\(total)</div><div class="lbl">Total pairs</div></div>
          </div>
        </div>
        <div class="card">
          <h3>Pairwise Contrast</h3>
          <div class="pairs">\(pairsHTML)</div>
        </div>
        <div class="card">
          <h3>Color Blindness Simulation</h3>
          \(simHTML())
        </div>
        """
    }

    func simHTML() -> String {
        let types: [ColorBlindnessType] = [.protanopia, .deuteranopia, .tritanopia]
        let keys: [ColorBlindnessType: String] = [.protanopia: "#ef4444", .deuteranopia: "#22c55e", .tritanopia: "#3b82f6"]
        return "<div class=\"sims\">" + types.map { t in
            "<div class=\"sim\"><h4><i style=\"background:\(keys[t] ?? "#888")\"></i>\(t.rawValue)</h4>" +
            palette.map { c in
                let s = ColorBlindnessSimulator.simulate(c, for: t)
                return "<div class=\"sim-row\"><div class=\"sw\" style=\"background:\(c.hex)\" title=\"\(c.hex)\">Aa</div><span class=\"arr\">→</span><div class=\"sw\" style=\"background:\(s.hex)\" title=\"\(s.hex)\">Aa</div><span class=\"lbl\">\(s.hex)</span></div>"
            }.joined() + "</div>"
        }.joined() + "</div>"
    }

    func build() {
        if let b = doc.body.object { _ = b.innerHTML = JSValue.string(html()) }
    }

    func wireEvents() {
        let root = doc.body.object!
        _ = root.addEventListener!("click", JSClosure { [weak self] args in
            guard let self = self, let ev = args.first?.object, let target = ev.target.object else { return .undefined }
            let id = target.id.string ?? ""
            if id == "goBtn" { self.analyze(); return .undefined }
            if id == "egBtn" { self.loadExample(); return .undefined }
            if id == "addBtn" { self.addColor(); return .undefined }
            if id == "clearBtn" { self.clearAll(); return .undefined }
            if let idx = target.getAttribute!("data-idx").string, let i = Int(idx), i < self.palette.count {
                self.palette.remove(at: i); self.sync()
            }
            if let fi = target.getAttribute!("data-fi").string, let i = Int(fi), i < self.palette.count,
               let hx = target.getAttribute!("data-hex").string, let c = AppColor(hex: hx) {
                self.palette[i] = c; self.sync()
            }
            return .undefined
        })
        if let input = doc.getElementById!("hexInput").object {
            _ = input.addEventListener!("input", JSClosure { [weak self] _ in
                self?.livePreview()
                return .undefined
            })
        }
    }

    func livePreview() {
        let raw = doc.getElementById!("hexInput").value.string ?? ""
        let el = doc.getElementById!("livePreview")
        guard !raw.isEmpty else { _ = el.style.display = JSValue.string("none"); return }
        let parts = raw.split { $0 == "," || $0 == "\n" || $0 == "\r" }.map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
        let valid = parts.compactMap { AppColor(hex: $0) }
        guard !valid.isEmpty else { _ = el.style.display = JSValue.string("none"); return }
        var chips = ""
        for c in valid.prefix(12) {
            chips += "<span class=\"lp\"><b style=\"background:\(c.hex)\"></b>\(c.hex)</span>"
        }
        if valid.count > 12 {
            chips += "<span class=\"lp\" style=\"font-weight:700;color:#6366f1\">+\(valid.count - 12)</span>"
        }
        _ = el.innerHTML = JSValue.string(chips)
        _ = el.style.display = JSValue.string("flex")
    }

    func analyze() {
        let raw = doc.getElementById!("hexInput").value.string ?? ""
        guard !raw.isEmpty else { return }
        let parts = raw.split { $0 == "," || $0 == "\n" || $0 == "\r" }.map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
        for p in parts {
            if let c = AppColor(hex: p) {
                if !palette.contains(c) { palette.append(c) }
            }
        }
        if palette.isEmpty {
            _ = doc.getElementById!("errText").textContent = JSValue.string("No valid hex colors found")
            return
        }
        _ = doc.getElementById!("errText").textContent = JSValue.string("")
        _ = doc.getElementById!("pasteArea").style.display = JSValue.string("none")
        _ = doc.getElementById!("toolbar").style.display = JSValue.string("flex")
        sync()
    }

    func loadExample() {
        palette = [
            AppColor(hex: "#2D7FF9")!, AppColor(hex: "#FF3B30")!, AppColor(hex: "#34C759")!,
            AppColor(hex: "#8B5CF6")!, AppColor(hex: "#F59E0B")!, AppColor(hex: "#EC4899")!,
            AppColor(hex: "#1C1C1E")!, AppColor(hex: "#F5F5F7")!
        ]
        _ = doc.getElementById!("pasteArea").style.display = JSValue.string("none")
        _ = doc.getElementById!("toolbar").style.display = JSValue.string("flex")
        sync()
    }

    func addColor() {
        let raw = doc.getElementById!("hexAdd").value.string ?? ""
        guard !raw.isEmpty else { return }
        if let c = AppColor(hex: raw), !palette.contains(c) {
            palette.append(c)
        }
        _ = doc.getElementById!("hexAdd").value = JSValue.string("")
        sync()
    }

    func clearAll() {
        palette = []
        _ = doc.getElementById!("toolbar").style.display = JSValue.string("none")
        _ = doc.getElementById!("pasteArea").style.display = JSValue.string("block")
        sync()
    }

    func sync() {
        _ = doc.getElementById!("palette").innerHTML = JSValue.string(paletteHTML())
        _ = doc.getElementById!("report").innerHTML = JSValue.string(reportHTML())
        if let count = doc.getElementById!("palCount").object {
            _ = count.textContent = JSValue.string("\(palette.count) color\(palette.count == 1 ? "" : "s")")
        }
    }
}
