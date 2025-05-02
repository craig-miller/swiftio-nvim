#!/usr/bin/env nu

def swiftio-monitor [] {
  let device = (ls /dev/tty* | where name =~ "wchusbserial" | first | get name)

  if ($device | is-empty) {
    print "🚫 SwiftIO device not found (wchusbserial)"
    return
  }

  sudo cu -l $device -s 115200
}

swiftio-monitor
