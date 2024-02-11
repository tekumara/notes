# Microsoft C++ Build Tools

## Install

NB: You need to be logged in as Admin, otherwise this will fail silently when running within Windows or with `Installer failed with exit code: 5002` from the command line.

1. Download the install from [here](https://visualstudio.microsoft.com/visual-cpp-build-tools/)
1. Select `Desktop development with C++`
1. For arm64 build tools select `Individual components` then search for and select `msvc 2022 c++ arm64 build tools latest`.

See also [Visual Studio on Arm-powered devices](https://learn.microsoft.com/en-us/visualstudio/install/visual-studio-on-arm-devices?view=vs-2022)

## Install via winget (untested)

Using winget on x86 ([ref](https://stackoverflow.com/a/55053709)):

```
winget install Microsoft.VisualStudio.2022.BuildTools --force --override "--wait --passive --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 --add Microsoft.VisualStudio.Component.Windows11SDK.22000"
```

## Troubleshooting

### error: linker `link.exe` not found

Start the "Developer Command Prompt for VS 2022" which will set the right paths, or in an existing command prompt run:

```
"C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvarsall.bat arch"
```

where `arch` = your architecture, eg: `arm64`. If cross-compiling it will be `host_target` eg: `x86_arm`.

See [Use the Microsoft C++ toolset from the command line](https://learn.microsoft.com/en-us/cpp/build/building-on-the-command-line).

### warning LNK4272: library machine type 'x86' conflicts with target machine type 'ARM64'

> C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Tools\MSVC\14.38.33130\lib\x86\msvcrt.lib : warning LNK4272: library machine type 'x86' conflicts with target machine type 'ARM64'

You are using the x86 version on msvcrt.lib when trying to build an ARM64 target. Libraries are loaded from `%LIB%`. This env var is configured by vsvarsall.bat and friends.

If you are seeing this error when trying to build on an arm64 host targeting arm64 either:

1. Start the `ARM64 Native Tools Command Prompt for VS 2022` - and not a cross tools command prompt. Or,
1. In the standard command prompt run:

   ```
   "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvarsarm64.bat"
   ```

If you don't have these on your system you'll need to install the "MSVC 2022 C++ ARM64 build tools" (see [above](#install)).

- [Arm64 Visual Studio - For native developers](https://devblogs.microsoft.com/visualstudio/arm64-visual-studio/#for-native-developers)

### LINK : fatal error LNK1181: cannot open input file 'msvcrt.lib'

msvcrt.lib is not on the paths in the `%LIB%` env var.
