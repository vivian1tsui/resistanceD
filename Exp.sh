#!/bin/sh
for var in Karate ;do
    julia -O3 Main.jl $var
done
