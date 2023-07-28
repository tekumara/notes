# expo

## Troubleshooting

> network response timed out

Make sure your laptop and phone are on the same Wifi/LAN.

> ERROR TypeError: Cannot read property 'connect' of null, js engine: hermes

When using [react-native-tcp-socket](https://www.npmjs.com/package/react-native-tcp-socket). This means the native code hasn't been built and bundled. The require creates a [development build](https://docs.expo.dev/develop/development-builds/create-a-build/), eg: `npx expo run:android:`
