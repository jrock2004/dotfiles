#!/bin/sh

swaylock -d --screenshots --clock --indicator-idle-visible \
  --indicator-radius 100 --indicator-thickness 10 \
  --effect-scale 0.4 --effect-vignette 0.2:0.5 --effect-blur 4x2 \
  --font Comic Code Ligatures Regular \
  --datestr "%A, %B %d" --timestr "%-I:%M" \
  --ignore-empty-password \
  --bs-hl-color d65d0e \
  --ring-color 7c6f64 \
  --ring-clear-color 7c6f64 \
  --ring-caps-lock-color 7c6f64 \
  --ring-ver-color 7c6f64 \
  --ring-wrong-color 7c6f64 \
  --key-hl-color ebdbb2 \
  --text-color fabd2f \
  --text-clear-color fabd2f \
  --text-caps-lock-color fabd2f \
  --text-ver-color 83a598 \
  --text-wrong-color fb4934 \
  --line-color 00000000 \
  --line-clear-color 00000000 \
  --line-caps-lock-color 00000000 \
  --line-ver-color 00000000 \
  --line-wrong-color 00000000 \
  --inside-color 00000088 \
  --inside-clear-color 00000088 \
  --inside-ver-color 00000088 \
  --inside-wrong-color 00000088 \
  --separator-color 00000000 \
  --fade-in "$@"

