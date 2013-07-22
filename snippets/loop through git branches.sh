#!/bin/bash

for branch in $(git branch --color=never | sed s/*//); do
    #something
done
