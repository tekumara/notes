# QR Code

Install:

```
brew install qrencode zbar
```

Encode and print in terminal:

```
echo foobar | qrencode --size 10 -o - > foobar.png
```

Decode:

```
zbarimg -q --raw foobar.png
```
