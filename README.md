# ChronoFlare

A [`std::chrono::duration`](https://en.cppreference.com/w/cpp/chrono/duration) inspired time interval library.

## Usage

```mojo
fn sleep_seconds(wait: Seconds):
    ...

var s = Seconds(10)
sleep_seconds(s)
# sleep_seconds(Milliseconds(10000)) # Fails to compile
sleep_seconds(Seconds(Milliseconds(10000))) # Explicit cast to Seconds

# Arithmetic
var added = Seconds(10) + Seconds(15)

# Custom time interval
alias HalfDay = Time[Ratio[86400//2, suffix="HD"]()]
```
