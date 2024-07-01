#pragma once

//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift open source project
//
// Copyright (c) 2024 Apple Inc. and the Swift project authors.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
//
//===----------------------------------------------------------------------===//

// C standard library
// ==================

#include <stdio.h>
#include <math.h>

// ESP IDF
// =======

#include <freertos/FreeRTOS.h>
#include <freertos/task.h>
#include <led_strip.h>
#include <led_strip_interface.h>
#include <led_strip_types.h>
#include <sdkconfig.h>

static inline void sleep(double sec) {
    vTaskDelay(sec * 1000 / portTICK_PERIOD_MS);
}

static inline void init_led_strip(led_strip_handle_t &led_strip, uint32_t max_leds) {
    led_strip_config_t strip_config = {
        .strip_gpio_num = 8,
        .max_leds = max_leds,
        .led_pixel_format = LED_PIXEL_FORMAT_GRB,
        .led_model = LED_MODEL_WS2812,
        .flags.invert_out = false,
    };

    led_strip_rmt_config_t rmt_config = {
        .clk_src = RMT_CLK_SRC_DEFAULT,
        .resolution_hz = 10 * 1000 * 1000, // 10MHz
        .flags.with_dma = false,
    };
    ESP_ERROR_CHECK(led_strip_new_rmt_device(&strip_config, &rmt_config, &led_strip));
}
