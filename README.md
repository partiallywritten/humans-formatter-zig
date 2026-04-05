# humans-formatter-py
Re-implementation of my pypi library, [humans-formatter](https://pypi.org/project/humans-formatter/) in zig.


### Usage
```py
import humans

# time formatting
# time(ms: int, compound: bool = False, round: bool = False)
# 	- Format milliseconds into human readable form. Use only one argument except 'ms' at a time
print(humans.time(<time-in-ms>, compound=True)


# byte formatting
# bytes(size: int)
# 	- Convert bytes into human readable KiB/MiB/etc.
print(humans.bytes(<bytes>)


# see docs
print(humans.__doc__)
print(humans.time.__doc__)
print(humans.bytes.__doc__)
```


### Build it

> [!IMPORTANT]
> This extension requires python 3.13 or newer as it uses [fast calls](https://docs.python.org/3/c-api/structures.html#c.METH_FASTCALL)

```sh
zig build-lib -dynamic -O ReleaseFast -I /usr/include/python<x.xx> -femit-bin=<path> -lc wraps.zig
```
Replace placeholders with
  - `python<x.xx>` - Your python version (`python --version`). ex: `python3.14`
  - `<path>` - Path to where the `*.so` file needs to be created. ex: `tests/humans.so`


### Performance results
Up to **6.32x** speed boost on `humans.time()` and Up to **4.43x** speed boost on `humans.bytes()` compared their python counterparts
<details>
  <summary>Click to See detailed results</summary>
  
  ```
  ======== Benchmark ========
  
  [humans.time()]
    Runs:        5
    Iterations:  3,000,000
    Mean total:  0.377207 sec
    Best total:  0.374318 sec
    Std dev:     0.003188 sec
    Mean/op:     125.74 ns
    Best/op:     124.77 ns
  
  [humans.bytes()]
    Runs:        5
    Iterations:  3,000,000
    Mean total:  0.603314 sec
    Best total:  0.596138 sec
    Std dev:     0.009020 sec
    Mean/op:     201.10 ns
    Best/op:     198.71 ns
  
  [origin.time()]
    Runs:        5
    Iterations:  3,000,000
    Mean total:  2.383333 sec
    Best total:  2.332734 sec
    Std dev:     0.039932 sec
    Mean/op:     794.44 ns
    Best/op:     777.58 ns
  
  [origin.bytes()]
    Runs:        5
    Iterations:  3,000,000
    Mean total:  2.673346 sec
    Best total:  2.658478 sec
    Std dev:     0.010153 sec
    Mean/op:     891.12 ns
    Best/op:     886.16 ns

  [Sample Outputs]
    humans.time: 1h 1m 1s
    humans.bytes: 1.00 GiB
   
  Tested on home server: i3-4130, 2TB HDD on arch linux, python 3.14.3 & zig 0.15.2
  ```
</details>

see [bench.py](tests/bench.py) and [python implementation](tests/origin.py) for more info.
Both are optimized and implementations of the same logic
