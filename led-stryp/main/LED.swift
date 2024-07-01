final class LED {
    
    var handle: led_strip_handle_t
    
    let maxLeds: UInt32
    
    init(maxLeds: UInt32) {
        self.maxLeds = maxLeds
        var handle: led_strip_handle_t?
        init_led_strip(&handle, maxLeds)
        self.handle = handle!
    }
    
    func setPixel(index: Int, color: Color) {
        switch color {
        case .rgb(let r, let g, let b):
            led_strip_set_pixel(handle, UInt32(index), r, g, b)
        case .hsv(let h, let s, let v):
            setPixel(index: index, color: hsvToRgb(h: Float(h), s: Float(s) / 255, v: Float(v) / 255))
        }
    }
    
    func refresh() {
        led_strip_refresh(handle)
    }
    
    enum Color {
        case rgb(UInt32, UInt32, UInt32)
        case hsv(UInt32, UInt32, UInt32)
        
        func print() {
            switch self {
            case .rgb(let r, let g, let b):
                Swift.print("Color(r: \(r), g: \(g), b: \(b))")
            case .hsv(let h, let s, let v):
                Swift.print("Color(h: \(h) s: \(s) v: \(v)")
            }
        }
    }
    
    func hsvToRgb(h: Float, s: Float, v: Float) -> Color {
        if s == 0 { return .rgb(UInt32(v * 255), UInt32(v * 255), UInt32(v * 255)) } // Achromatic grey
        
        let angle = (h >= 360 ? 0 : h)
        let sector = angle / 60 // Sector
        let i = floorf(sector)
        let f = sector - i // Factorial part of h
        
        let p = v * (1 - s)
        let q = v * (1 - (s * f))
        let t = v * (1 - (s * (1 - f)))
        
        switch(i) {
        case 0:
            return .rgb(UInt32(v * 255), UInt32(t * 255), UInt32(p * 255))
        case 1:
            return .rgb(UInt32(q * 255), UInt32(v * 255), UInt32(p * 255))
        case 2:
            return .rgb(UInt32(p * 255), UInt32(v * 255), UInt32(t * 255))
        case 3:
            return .rgb(UInt32(p * 255), UInt32(q * 255), UInt32(v * 255))
        case 4:
            return .rgb(UInt32(t * 255), UInt32(p * 255), UInt32(v * 255))
        default:
            return .rgb(UInt32(v * 255), UInt32(p * 255), UInt32(q * 255))
        }
    }
}
