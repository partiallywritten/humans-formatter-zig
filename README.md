# humans-formatter-py
Re-implementation of my pypi library, [humans-formatter](https://pypi.org/project/humans-formatter/) in zig.


### Usage
```py
import humans

# time formatting
# time(ms: int, compound: bool = True, round: bool = False)
# 	- Format milliseconds into human readable form. Use only one argument except 'ms' at a time
print(humans.time(<time-in-ms>)


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
> This extension requires,
>   - python 3.13 or newer as it uses [fast calls](https://docs.python.org/3/c-api/structures.html#c.METH_FASTCALL)
>   - zig 0.15.2 (or newer, not tested) as it uses `std.Io.Writer` (see [Writergate update](https://ziglang.org/download/0.15.1/release-notes.html#Writergate))

```sh
zig build-lib -dynamic -O ReleaseFast -I /usr/include/python<x.xx> -femit-bin=<path> -lc wrapper.zig
```
Replace placeholders with
  - `python<x.xx>` - Your python version (`python --version`). ex: `python3.14`
  - `<path>` - Path to where the `*.so` file needs to be created. ex: `tests/humans.so`

Once you get your `*.so` file, you can just import it in python using `import <filename>` (replace <filename> with whatever the name of your .so file without the extension); Assuming they are both in the same directory


### Performance results
Up to **6.5x** speed boost on `humans.time()` and Up to **6.4x** speed boost on `humans.bytes()` compared their python counterparts
<details>
  <summary>Click to See detailed results</summary>
  
  ```
 ======== Benchmark ========

 [humans.time()]
   Runs:        5
   Iterations:  3,000,000
   Mean total:  0.360692 sec
   Best total:  0.354795 sec
   Std dev:     0.007005 sec
   Mean/op:     120.23 ns
   Best/op:     118.26 ns

 [humans.bytes()]
   Runs:        5
   Iterations:  3,000,000
   Mean total:  0.399735 sec
   Best total:  0.387777 sec
   Std dev:     0.014533 sec
   Mean/op:     133.24 ns
   Best/op:     129.26 ns

 [origin.time()]
   Runs:        5
   Iterations:  3,000,000
   Mean total:  2.349150 sec
   Best total:  2.336186 sec
   Std dev:     0.007540 sec
   Mean/op:     783.05 ns
   Best/op:     778.73 ns

 [origin.bytes()]
   Runs:        5
   Iterations:  3,000,000
   Mean total:  2.561663 sec
   Best total:  2.557630 sec
   Std dev:     0.003903 sec
   Mean/op:     853.89 ns
   Best/op:     852.54 ns

 [Sample Outputs]
   humans.time: 1h 1m 1s
   humans.bytes: 1.00 GiB
  ```
</details>

see [bench.py](tests/bench.py) and [python implementation](tests/origin.py) for more info.
Both are optimized and implementations of the same logic
