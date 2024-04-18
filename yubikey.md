# yubikey

List oauth (ie: authenticator) accounts:

```
ykman oath accounts list
```

Generate code for account containing "amazon" (must be a single match)

```
ykman oath accounts code -s amazon
```

## OTP

List the [otp](https://docs.yubico.com/yesdk/users-manual/application-otp/yubico-otp.html) slots:

```
ykman otp info
```

Slot 1 requires about a half-second touch, and slot 2 requires about a two-second touch.

By default slot 1 is programmed with the OTP and will emit with a half-second touch. Slot 2 is empty.

To make this OTP emit from a 2-second touch, [swap the slots](https://gist.github.com/ravron/d1b2e519bfabb0e853aec26fda52f59d#add-an-otp-triggering-delay):

```
ykman otp swap
```

## Troubleshooting

### Yubico Authenticator won't start on MacOS

In System Settings - Privacy & Security - Input Monitoring: add Yubico Authenticator.
