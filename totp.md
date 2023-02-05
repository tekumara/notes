# totp

Install

```
brew install oath-toolkit
```

Generate 6 digit SHA1 totp from key pasted via stdin:

```
oathtool --totp -b -
```

Verbose mode:

```
oathtool --totp -v -b -
```
