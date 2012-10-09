#!/bin/bash
tic4x-as -m33 -o main.obj main.asm
tic4x-as -m33 -o asubs.obj asubs.asm
tic4x-as -m33 -o msubs.obj msubs.asm
tic4x-ld -T main.map -o main.out main.obj asubs.obj msubs.obj
