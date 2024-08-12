@_cdecl("app_main")
func app_main() {
    print("🏎️   Hello, Embedded Swift! (LED Blynk)")
    
    let led = LedStrip(gpioPin: 8, maxLeds: 512)
    
    fillStrip(led: led, color: .rgb(3, 3, 3))
    
    print("wifi init...")
    reset_nvs()
    let resultWifi = wifi_init_sta()
    print("...wifi init done")
    
    switch (resultWifi) {
    case 0:
        fillStrip(led: led, color: .rgb(0, 100, 0))
    case 1:
        fillStrip(led: led, color: .rgb(100, 0, 0))
    default:
        fillStrip(led: led, color: .rgb(0, 0, 100))
    }
    sleep(0.1)
    led.clear()
    sleep(0.4)
    
    let numLeds: UInt32 = 12 // 512
    
    let shift: UInt32 = 360 / 12
    
    // TODO: receive UDP packets, see:  https://github.com/espressif/esp-idf/tree/master/examples/protocols/sockets/udp_server
    
    while true {
        for _ in 0..<10 {
            for i: UInt32 in 0..<numLeds {
                if i > 3 {
                    led.setPixel(index: Int(i - 4), color: .rgb(0, 0, 0))
                }
                led.setPixel(index: Int(i), color: .rgb(255, 255, 255))
                led.refresh()
                vTaskDelay(1)
            }
            led.clear()
            vTaskDelay(1)
        }
        
        for _ in 0..<3 {
            for offset: UInt32 in 0..<360 {
                for i: UInt32 in 0..<numLeds {
                    let hue = ((shift * i) + offset) % 360
                    led.setPixel(index: Int(i), color: .hsv(hue, 255, 20))
                }
                led.refresh()
                vTaskDelay(1)
            }
        }
        
        for _ in 0..<3 {
            for offset: UInt32 in 0..<360 {
                for i: UInt32 in 0..<numLeds {
                    let deg = ((shift * i) + offset) % 360
                    let v = UInt32(255 * sin(Double(deg) / 360 * Double.pi))
                    
                    led.setPixel(index: Int(i), color: .hsv(0, 0, v * 40 / 255))
                }
                led.refresh()
                vTaskDelay(1)
            }
        }
    }
}

func fillStrip(led: LedStrip, color: LedStrip.Color, numLeds: UInt32 = 512) {
    for i: UInt32 in 0..<numLeds {
        led.setPixel(index: Int(i), color: color)
    }
    led.refresh()
    vTaskDelay(1)
}
