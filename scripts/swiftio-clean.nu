#!/usr/bin/env nu

echo "Cleaning..."
#!/usr/bin/env nu

source "/Users/craig/Library/Application Support/nushell/config.nu"
let output = mad-clean

echo $output | less

# let result = ^/Users/craig/Developer/embedded-swift/mm-sdk/usr/mm/mm clean
# echo $result
# echo $env.LAST_EXIT_CODE
# 
# if $env.LAST_EXIT_CODE == 0 {
#   echo "Clean successful"
# } else {
#   echo "Clean failed (code: $env.LAST_EXIT_CODE)"
# }
# 
# # short pause so you can see the result
# sleep 2sec
