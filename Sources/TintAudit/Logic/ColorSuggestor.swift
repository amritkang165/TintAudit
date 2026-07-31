import Foundation

// Finds the nearest accessible alternative for a color that fails a
// contrast target by adjusting lightness while keeping hue & saturation.
struct ColorSuggestor {

    static func nearestAccessible(fg: AppColor, bg: AppColor, target: Double = 4.5) -> (color: AppColor, ratio: Double)? {
        let (h, s, l) = rgbToHsl(fg.r, fg.g, fg.b)

        func ratio(atLightness light: Double) -> Double {
            let rgb = hslToRgb(h, s, light)
            let c = AppColor(r: rgb.r, g: rgb.g, b: rgb.b)
            return ContrastCalculator.check(c, bg).ratio
        }

        var darken: (lightness: Double, delta: Double)? = nil
        if ratio(atLightness: 0) >= target {
            var lo = 0.0, hi = l
            for _ in 0..<24 {
                let mid = (lo + hi) / 2
                if ratio(atLightness: mid) >= target { lo = mid } else { hi = mid }
            }
            darken = (lo, l - lo)
        }

        var lighten: (lightness: Double, delta: Double)? = nil
        if ratio(atLightness: 1.0) >= target {
            var lo = l, hi = 1.0
            for _ in 0..<24 {
                let mid = (lo + hi) / 2
                if ratio(atLightness: mid) >= target { hi = mid } else { lo = mid }
            }
            lighten = (hi, hi - l)
        }

        let pick: (lightness: Double, delta: Double)
        switch (darken, lighten) {
        case (nil, nil):
            return nil
        case (.some(let a), nil):
            pick = a
        case (nil, .some(let b)):
            pick = b
        case (.some(let a), .some(let b)):
            pick = a.delta <= b.delta ? a : b
        }

        let rgb = hslToRgb(h, s, pick.lightness)
        let color = AppColor(r: rgb.r, g: rgb.g, b: rgb.b)
        return (color, ContrastCalculator.check(color, bg).ratio)
    }

    static func rgbToHsl(_ r: Double, _ g: Double, _ b: Double) -> (h: Double, s: Double, l: Double) {
        let rn = r / 255.0, gn = g / 255.0, bn = b / 255.0
        let maxV = max(rn, max(gn, bn))
        let minV = min(rn, min(gn, bn))
        let l = (maxV + minV) / 2
        var h = 0.0, s = 0.0
        if maxV != minV {
            let d = maxV - minV
            s = l > 0.5 ? d / (2 - maxV - minV) : d / (maxV + minV)
            switch maxV {
            case rn: h = (gn - bn) / d + (gn < bn ? 6 : 0)
            case gn: h = (bn - rn) / d + 2
            default: h = (rn - gn) / d + 4
            }
            h /= 6
        }
        return (h, s, l)
    }

    static func hslToRgb(_ h: Double, _ s: Double, _ l: Double) -> (r: Double, g: Double, b: Double) {
        if s == 0 {
            let v = l * 255
            return (v, v, v)
        }
        let q = l < 0.5 ? l * (1 + s) : l + s - l * s
        let p = 2 * l - q
        func hue(_ t0: Double) -> Double {
            var t = t0
            if t < 0 { t += 1 }
            if t > 1 { t -= 1 }
            if t < 1.0 / 6 { return p + (q - p) * 6 * t }
            if t < 1.0 / 2 { return q }
            if t < 2.0 / 3 { return p + (q - p) * (2.0 / 3 - t) * 6 }
            return p
        }
        return (hue(h + 1.0 / 3) * 255, hue(h) * 255, hue(h - 1.0 / 3) * 255)
    }
}
