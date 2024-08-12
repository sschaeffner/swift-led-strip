struct LedStrip {
    private let handle: led_strip_handle_t
    
    init(gpioPin: Int, maxLeds: Int) {
        var handle = led_strip_handle_t(bitPattern: 0)
        var stripConfig = led_strip_config_t(
            strip_gpio_num: Int32(gpioPin),
            max_leds: UInt32(maxLeds),
            led_pixel_format: LED_PIXEL_FORMAT_GRB,
            led_model: LED_MODEL_WS2812,
            flags: .init(invert_out: 0)
        )
        var spiConfig = led_strip_spi_config_t(
            clk_src: SPI_CLK_SRC_DEFAULT,
            spi_bus: SPI2_HOST,
            flags: .init(with_dma: 1)
        )
        guard led_strip_new_spi_device(&stripConfig, &spiConfig, &handle) == ESP_OK else {
            fatalError("cannot configure spi device")
        }
        self.handle = handle!
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
    
    func clear() {
        led_strip_clear(handle)
    }
}
