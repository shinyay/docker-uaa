#!/usr/bin/env fish

function open_uaa
  argparse -n open_uaa 'h/help' 't/target=' -- $argv
  or return 1

  if set -lq _flag_help
    echo "open-uaa.fish -t/--target <UAA_ENDPOINT>"
    return
  end

  set -lq _flag_target
  or set -l _flag_target http://localhost:8090/uaa

  open $_flag_target
end

open_uaa $argv
