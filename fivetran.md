# fivetran

`_FIVETRAN_START` is a Fivetran date that mirrors the source system date when in [history mode](https://fivetran.com/docs/core-concepts/sync-modes/history-mode#:~:text=The%20time%20when%20the%20record%20was%20first%20created%20or%20modified%20in%20the%20source%2C%20based%20on%20a%20timestamp%20value%20in%20the%20source%20table%20that%20monotonically%20increases%20over%20time%20with%20data%20change%20or%20update.).

`_FIVETRAN_SYNCED` is stamped with the time of every Fivetran sync and is monotonically increasing.
