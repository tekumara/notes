# ld

> `LD_LIBRARY_PATH` tells the dynamic link loader (ld.so – this little program that starts all your applications) where to search for the dynamic shared libraries an application was linked against.

See [LD_LIBRARY_PATH – or: How to get yourself into trouble!](https://www.hpc.dtu.dk/?page_id=1180)

[Rules](http://xahlee.info/UnixResource_dir/_/ldpath.html):

> Never ever set LD_LIBRARY_PATH globally.
> If you are forced to set LD_LIBRARY_PATH, do so only as part of a wrapper.
