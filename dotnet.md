# dotnet

## .NET Core

```
brew cask install dotnet-sdk
```

This installs the `dotnet` binary.

## .NET Framework

```
brew install mono
```

This installs the `msbuild` binary. MsBuild builds .NET framework targets in the project file.

## NuGet

To install nuget (requires mono):

```
brew install nuget
```

To use an private repo, update _~/.config/NuGet/NuGet.Config_ which defaults to:

```
<?xml version="1.0" encoding="UTF-8"?>
<configuration>
    <packageSources>
        <add key="nuget.org" value="https://api.nuget.org/v3/index.json" protocolVersion="3" />
    </packageSources>
</configuration>

```

## Omnisharp (vscode) errors

### The reference assemblies for .NETFramework,Version=v4.5.2 were not found

1. Install mono (which contains the SDKs)
1. Tell Omnisharp to use the globally installed mono rather than it's built in version: Settings -> Omnisharp: Use Global Mono = always ([ref](https://github.com/OmniSharp/omnisharp-vscode/issues/3063#issuecomment-678223360))

### This project references NuGet package(s) that are missing on this computer

Run nuget restore, eg: `nuget restore MySolution.sln`

### The type or namespace name ... could not be found

Run nuget restore, eg: `nuget restore MySolution.sln` and then restart vscode so Omnisharp can find the newly installed packages.

### Code navigation doesn't work

If code navigation (eg: Go to References) isn't working make sure you have selected the relevant project from the status bar ([ref](https://code.visualstudio.com/docs/languages/csharp#_roslyn-and-omnisharp)).
