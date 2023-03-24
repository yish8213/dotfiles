#!/usr/bin/env bash

linklist=$(find -L "$HOME" -type l -maxdepth 1)
for link in $linklist
do
  unlink "$link"
done
unset linklist;
unset link;