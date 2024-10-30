#!/usr/bin/expect

set timeout 5

set server "localhost"
set port "4444"

# Start the telnet session
spawn telnet $server $port


# Send commands after login
expect "telnet>" # Adjust this prompt as needed
send "halt\r"
send "load_image ./kernel.bin 0x80000\r"
send "step 0x80000\r"

interact
