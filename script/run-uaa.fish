#!/usr/bin/env fish

function run_uaa
  argparse -n run_uaa 'h/help' 't/target=' -- $argv
  or return 1

  if set -lq _flag_help
    echo "run-uaa.fish -t/--target <UAA_CONTAINER_IMAGE>"
    return
  end

  set -lq _flag_target
  or set -l _flag_target shinyay/uaa:latest

  docker run --rm -it -p 8090:8090 $_flag_target
end

run_uaa $argv
