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
```sh
zig build-lib -dynamic -O ReleaseFast -I /usr/include/python<x.xx> -femit-bin=humans.so -lc wraps.zig
```
Replace with your python version (`python --version`) and path


### Performance results
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

see [bench.py](tests/bench.py) and [python implementation](tests/origin.py) for more info.
Both are optimized and implementations of the same logic
