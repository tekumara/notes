# xcode instruments

## Install

[Instruments](<https://en.wikipedia.org/wiki/Instruments_(software)>) is part of Xcode which requires 8gb to install (june 2024 - just macos 14.5). It can collect and display info from dtrace.

## Usage

Open Xcode -> Open Developer Tool -> Instruments.

`Choose Target` will start that process and monitor it, eg: _~/code/fakesnow/.venv/bin/pytest_

Or you can select an already running process.

To start recording from the cli use [xctrace](https://keith.github.io/xcode-man-pages/xctrace.1.html).

## Troubleshooting

> The data volume is too high for a recording mode of "Immediate" and some data had to be dropped to move forward

## References

- [Instruments Help](https://help.apple.com/instruments/mac/current/#/)
- [Using Xcode Instruments for C++ CPU profiling](https://www.jviotti.com/2024/01/29/using-xcode-instruments-for-cpp-cpu-profiling.html)
