# node-gyp

## Troubleshooting

### No Xcode or CLT version detected!

node-gyp needs the [xcode command line tools](https://github.com/nodejs/node-gyp/blob/ee6fa7d3bc80d350fb8ed2651d6f56099e5edfdd/macOS_Catalina.md#installing-node-gyp-using-the-xcode-command-line-tools-via-manual-download).

### TypeError: cannot use a string pattern on a bytes-like object

Upgrade npm to 6.14.8 to fix, see [#2121](https://github.com/nodejs/node-gyp/issues/2121#issuecomment-667592849):

```
npm i -g npm
```
