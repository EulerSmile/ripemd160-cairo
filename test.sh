#!/bin/bash
rm -rf test.json &&
cairo-compile --cairo_path="src" src/test.cairo --output test.json &&
cairo-run --program test.json --print_output --layout=all