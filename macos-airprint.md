# AirPrint (macOS)

AirPrint allows a printer to be used without manually installing any software.

See this list of [printers supporting AirPrint](https://support.apple.com/en-us/HT201311).

## Troubleshooting

> Unable to communicate with the printer at this time.
>
> Unable to connect to 'HP Color LaserJet MFP M476dw (04679B).\_ipps.\_tcp.local.' due to an error. Would you still like to create the
> printer?

This can happen if there isn't a network route to the printer. Bonjour will know of the printer and its IP address but can't connect. Verify this by printing the Network Summary from the printer and then try to ping its IP address.
