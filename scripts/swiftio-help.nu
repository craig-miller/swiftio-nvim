#!/usr/bin/env nu

# Call your custom mad-help function with no args, or you could pass 'build', 'init', etc.
def mad-help [...cmd] {
  ^/Users/craig/Developer/embedded-swift/mm-sdk/usr/mm/mm -h ...$cmd | less
}

mad-help 
