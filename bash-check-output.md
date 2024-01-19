# bask check output

To check failure output

```bash
if { ! git merge upstream/main | tee /dev/stderr | grep -q "Automatic merge failed; fix conflicts" ;} then
    # exit only if its not an automatic merge failure,
    # because we fix up the merge failure with wiggles
    [[ "${PIPESTATUS[2]}" -ne 0 ]] && exit 42
fi
```
