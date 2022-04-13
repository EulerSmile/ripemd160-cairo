#!/bin/bash
rm -rf test.json &&
cairo-compile test.cairo --output test.json &&
cairo-run --program test.json --print_output --layout=small
