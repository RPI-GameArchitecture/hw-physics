@echo off

mkdir ga5-win64
cd ga5-win64
cmake -G "Visual Studio 15 2017 Win64" ../../src/engine
cd ..
