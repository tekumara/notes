# Elliptic-curve cryptography

Elliptic-curve cryptography (ECC) algorithms have the advantage that they can provide the same level of security with smaller keys than RSA. This makes them less computationally intensive so key creation, encryption and decryption is quicker, and key storage is smaller.

Because gains beyond an RSA key size of 2048 are minimal, the [GnuPG FAQ recommends ECC](https://www.gnupg.org/faq/gnupg-faq.html#please_use_ecc):

> If you need more security than RSA-2048 offers, the way to go would be to switch to elliptical curve cryptography — not to continue using RSA.

## NIST P curves

Popular because it is approved for use by the US government and required when interacting with them.

NIST P curves like NIST P-256 are [not considered safe by DJB](https://safecurves.cr.yp.to/).

Bruce Schneier does not trust the [NIST P curve constants](https://en.wikipedia.org/wiki/Nothing-up-my-sleeve_number) and tptacek [doesn't trust Schneier on curves](https://news.ycombinator.com/item?id=20386730).

[Ruggo](https://crypto.stackexchange.com/a/52992/105997) and [tptacek](https://news.ycombinator.com/item?id=20385829) believe there are no backdoors, although NIST P curves are [harder to implement](https://crypto.stackexchange.com/questions/52983/why-is-there-the-option-to-use-nist-p-256-in-gpg/52992#comment149464_52992) and so susceptible to bugs that led to insecurities.

## Curve25519

The general consensus is to use Curve25519 for any elliptic curve cryptography. See [this comparison](https://news.ycombinator.com/item?id=20382293) showing Curve25519 is more robust than NIST P curves.

## ECDSA

Ed25519 is [superior and preferred to ECDSA](https://wiki.archlinux.org/title/SSH_keys#ECDSA).

## References

- [Archwiki: SSH keys - Choosing the authentication key type](https://wiki.archlinux.org/title/SSH_keys#Choosing_the_authentication_key_type) good overview of the different types of keys
- [NSA - The Case for Elliptic Curve Cryptography (archive.org)](https://web.archive.org/web/20090117023500/http://www.nsa.gov/business/programs/elliptic_curve.shtml)
