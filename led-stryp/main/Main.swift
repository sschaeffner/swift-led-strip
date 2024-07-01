@_cdecl("app_main")
func app_main() {
    print("🏎️   Hello, Embedded Swift! (LED Blynk)")
    
    let led = LED(maxLeds: 12)
    
    let shift: UInt32 = 360 / 12
    
    while true {
        for _ in 0..<3 {
            for offset: UInt32 in 0..<360 {
                for i: UInt32 in 0..<12 {
                    let hue = ((shift * i) + offset) % 360
                    led.setPixel(index: Int(i), color: .hsv(hue, 255, 255))
                }
                led.refresh()
                sleep(0.01)
            }
        }
        
        for _ in 0..<3 {
            for offset: UInt32 in 0..<360 {
                for i: UInt32 in 0..<12 {
                    let deg = ((shift * i) + offset) % 360
                    let v = UInt32(255 * sin(Double(deg) / 360 * Double.pi))
                    
                    led.setPixel(index: Int(i), color: .hsv(0, 0, v))
                }
                led.refresh()
                sleep(0.01)
            }
        }
    }
}
