#!/bin/sh
ruby /Users/ohalps01/bin/stakeout.rb "webby build" "content/**/[a-zA-Z]*" &
ruby /Users/ohalps01/bin/stakeout.rb "webby rebuild" "content/_*" &

