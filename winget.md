# winget

## Submitting manifest

Clone:

```
git clone https://github.com/tekumara/winget-pkgs.git --sparse --branch gh-doctor-0.3.0 --depth 10
git sparse-checkout add Tools manifests/t/tekumara

```

Test:

```
winget validate manifests\t\tekumara\gh-doctor\0.3.0
winget install --manifest manifests\t\tekumara\gh-doctor\0.3.0

# or in sandbox:
# powershell .\Tools\SandboxTest.ps1 manifests\t\tekumara\gh-doctor\0.3.0
```

## Resources

- [Testing a Manifest](https://github.com/microsoft/winget-pkgs/blob/master/doc/README.md#testing-a-manifest)
- [Submit your manifest to the repository](https://learn.microsoft.com/en-us/windows/package-manager/package/repository)
