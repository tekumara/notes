# webauthn

"WebAuthN (Web Authentication API) is an API specification to authenticate users via Public Key Cryptography instead of a password.

A private key is stored on the users device only, and a public key is shared between the client and the authorizing server.  When a authentication request is made, the web browser requests access to the private key via biometrics or a hardware key, and then generates a signature and passes it to the server to validate against the public key it received during registration.

Currently, there is no support for native iOS TouchID, but most other devices (MacOS TouchID, Windows Hello, Chrome for Android) all support native authentication options. It is still possible to authenticate with WebAuthN on iOS devices with the use of an external hardware key (eg YubiKey)

A great guide with more detail can be found at https://webauthn.guide"
