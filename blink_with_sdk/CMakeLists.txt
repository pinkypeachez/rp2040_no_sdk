cmake_minimum_required(VERSION 3.27)

# initialize the SDK based on PICO_SDK_PATH
# note: this must happen before project()
include(pico_sdk_import.cmake)

project(my_project)

# initialize the Raspberry Pi Pico SDK
pico_sdk_init()





#########
add_executable(blink_simple
        src/blink_simple.c
)

# pull in common dependencies
target_link_libraries(blink_simple pico_stdlib)

# create map/bin/hex/uf2 file etc.
pico_add_extra_outputs(blink_simple)

# --- enable the stdio functions over USB instead of UART.
pico_enable_stdio_usb(blink_simple 1) # enable USB
pico_enable_stdio_uart(blink_simple 0) # disable UART