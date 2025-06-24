#!/usr/bin/env bash

linklist=$(find -L "$HOME" -maxdepth 1 -type l)
for link in $linklist
do
  unlink "$link"
done
unset linklist;
unset link;