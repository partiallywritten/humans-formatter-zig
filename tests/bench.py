import timeit
import statistics
import humans
import origin

# -----------------------------
# Configuration
# -----------------------------
ITERATIONS = 3_000_000
REPEAT = 5
WARMUP = 200_000

MS_INPUT = 3661001
BYTE_INPUT = 1073741824


# -----------------------------
# Core benchmark
# -----------------------------
def bench(fn, args, label):
    # Pre-bind locally (important)
    f = fn
    a = args

    # Warmup
    for _ in range(WARMUP):
        f(*a)

    results = []

    for _ in range(REPEAT):
        start = timeit.default_timer()

        for _ in range(ITERATIONS):
            f(*a)

        end = timeit.default_timer()
        results.append(end - start)

    mean = statistics.mean(results)
    best = min(results)
    stdev = statistics.stdev(results) if len(results) > 1 else 0

    print(f"\n[{label}]")
    print(f"  Runs:        {REPEAT}")
    print(f"  Iterations:  {ITERATIONS:,}")

    print(f"  Mean total:  {mean:.6f} sec")
    print(f"  Best total:  {best:.6f} sec")
    print(f"  Std dev:     {stdev:.6f} sec")

    print(f"  Mean/op:     {(mean/ITERATIONS)*1e9:.2f} ns")
    print(f"  Best/op:     {(best/ITERATIONS)*1e9:.2f} ns")


# -----------------------------
# Runner
# -----------------------------
def main():
    print("======== Benchmark ========")

    # humans
    bench(humans.time, (MS_INPUT,), "humans.time()")
    bench(humans.bytes, (BYTE_INPUT,), "humans.bytes()")

    # origin (adjust args if needed!)
    try:
        bench(origin.time_formatter, (MS_INPUT, True), "origin.time()")
    except TypeError:
        print("\n[origin.time()] signature mismatch — skipped")

    try:
        bench(origin.byte_formatter, (BYTE_INPUT,), "origin.bytes()")
    except TypeError:
        print("\n[origin.bytes()] signature mismatch — skipped")

    # sanity check
    print("\n[Sample Outputs]")
    print("  humans.time:", humans.time(MS_INPUT, compound=True))
    print("  humans.bytes:", humans.bytes(BYTE_INPUT))


if __name__ == "__main__":
    main()
