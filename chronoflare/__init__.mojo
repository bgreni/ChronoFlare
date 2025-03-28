from builtin.string_literal import get_string_literal

alias NanoSeconds = Time[Ratio.Nano, _]
alias MicroSeconds = Time[Ratio.Micro, _]
alias Milliseconds = Time[Ratio.Milli, _]
alias Seconds = Time[Ratio.Base, _]
alias Minutes = Time[Ratio[60, suffix="min"](), _]
alias Hours = Time[Ratio[3600, suffix="h"](), _]
alias Days = Time[Ratio[86400, suffix="d"](), _]
alias Weeks = Time[Ratio[604800, suffix="weeks"](), _]
alias Months = Time[Ratio[2629746, suffix="months"](), _]
alias Years = Time[Ratio[31557600, suffix="y"](), _]


@value
@register_passable("trivial")
struct Time[R: Ratio, DT: DType = DType.index](
    EqualityComparableCollectionElement, Stringable, Absable, Powable, Roundable
):
    alias Repr = Scalar[DT]
    var _value: Self.Repr

    @staticmethod
    fn max() -> Self:
        return Self(Self.Repr.MAX_FINITE)

    @staticmethod
    fn min() -> Self:
        return Self(Self.Repr.MIN_FINITE)

    @staticmethod
    fn zero() -> Self:
        return Self(0)

    @always_inline
    fn __init__(out self, v: Self.Repr):
        self._value = v
        
    fn __init__[OR: Ratio, //](out self, other: Time[OR, DT]):
        self = other.cast[R = Self.R]()

    @always_inline
    fn __eq__(self, other: Self) -> Bool:
        return self._value == other._value

    @always_inline
    fn __ne__(self, other: Self) -> Bool:
        return self._value != other._value

    @always_inline
    fn __gt__(self, other: Self) -> Bool:
        return self._value > other._value

    @always_inline
    fn __lt__(self, other: Self) -> Bool:
        return self._value < other._value

    @always_inline
    fn __ge__(self, other: Self) -> Bool:
        return self._value >= other._value

    @always_inline
    fn __le__(self, other: Self) -> Bool:
        return self._value <= other._value

    @always_inline
    fn __add__(self, other: Self) -> Self:
        return Self(self._value + other._value)

    @always_inline
    fn __iadd__(mut self, other: Self):
        self._value += other._value

    @always_inline
    fn __sub__(self, other: Self) -> Self:
        return Self(self._value - other._value)

    @always_inline
    fn __isub__(mut self, other: Self):
        self._value -= other._value

    @always_inline
    fn __mul__(self, other: Self) -> Self:
        return Self(self._value * other._value)

    @always_inline
    fn __imul__(mut self, other: Self):
        self._value *= other._value

    @always_inline
    fn __truediv__(self, other: Self) -> Self:
        return Self(self._value // other._value)

    @always_inline
    fn __itruediv__(mut self, other: Self):
        self._value //= other._value

    @always_inline
    fn __mod__(self, other: Self) -> Self:
        return Self(self._value % other._value)

    @always_inline
    fn __imod__(mut self, other: Self):
        self._value %= other._value

    @always_inline
    fn __abs__(self) -> Self:
        return Self(abs(self._value))

    @always_inline
    fn __pow__(self, exp: Self) -> Self:
        return Self(self._value ** exp._value)

    @always_inline
    fn __round__(self) -> Self:
        return Self(round(self._value))

    @always_inline
    fn __round__(self, ndigits: Int) -> Self:
        return Self(round(self._value, ndigits))

    @always_inline
    fn count(self) -> Self.Repr:
        return self._value

    @always_inline
    fn __str__(self) -> String:
        return String.write(self)

    @always_inline
    fn cast[R: Ratio](self) -> Time[R, DT]:
        @parameter
        if R == Self.R:
            return Time[R, DT](self.count())
        if R > Self.R:
            return Time[R, DT](((Self.R * self.count()) // R.N) // R.D)
        else:
            return Time[R, DT](((Self.R * self.count()) // R.N) * R.D)

    @always_inline
    fn write_to[W: Writer](self, mut writer: W):
        writer.write(self.count())

        @parameter
        if R.suffix:
            writer.write(R.suffix)
        else:
            writer.write("(" + get_string_literal[String(R)]() + ")s")


@value
@register_passable("trivial")
struct Ratio[N: UInt, D: UInt = 1, suffix: StringLiteral = ""](
    Stringable, Writable
):
    alias Nano = Ratio[1, 1000000000, "ns"]()
    alias Micro = Ratio[1, 1000000, "µs"]()
    alias Milli = Ratio[1, 1000, "ms"]()
    alias Centi = Ratio[1, 100, "cs"]()
    alias Deci = Ratio[1, 10, "ds"]()
    alias Base = Ratio[1, suffix="s"]()
    alias Deca = Ratio[10, 1, "das"]()
    alias Hecto = Ratio[100, 1, "hs"]()
    alias Kilo = Ratio[1000, 1, "ks"]()
    alias Mega = Ratio[1000000000, 1, "Ms"]()
    alias Giga = Ratio[1000000, 1, "Gs"]()

    @always_inline
    fn __eq__(self, other: Ratio) -> Bool:
        return N == other.N and D == other.D

    @always_inline
    fn __ne__(self, other: Ratio) -> Bool:
        return not self == other

    @always_inline
    fn __gt__(self, other: Ratio) -> Bool:
        return N * other.D > D * other.N

    @always_inline
    fn __lt__(self, other: Ratio) -> Bool:
        return N * other.D < D * other.N

    @always_inline
    fn __ge__(self, other: Ratio) -> Bool:
        return N * other.D >= D * other.N

    @always_inline
    fn __le__(self, other: Ratio) -> Bool:
        return N * other.D <= D * other.N

    @always_inline
    fn __mul__[DT: DType](self, other: Scalar[DT]) -> Scalar[DT]:
        @parameter
        if DT.is_integral():
            return (other * N) // D
        else:
            return (other * N) / D

    @always_inline
    fn write_to[W: Writer](self, mut writer: W):
        writer.write(N, "/", D)

    @always_inline
    fn __str__(self) -> String:
        return String.write(self)

    @always_inline
    fn __repr__(self) -> String:
        return String.write("(", N, "/", D, ")", suffix)
