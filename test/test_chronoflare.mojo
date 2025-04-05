from chronoflare import *
from testing import *


def test_ctor():
    assert_equal(Seconds(4).count(), 4)
    assert_equal(Seconds(Minutes(10)), Seconds(600))


def test_add():
    assert_equal(Seconds(10) + Seconds(20), Seconds(30))
    assert_equal(Seconds(5) + Minutes(10).cast[R = Seconds.R](), Seconds(605))
    assert_equal(Seconds(600).cast[R = Minutes.R]() + Minutes(3), Minutes(13))


def test_iadd():
    var s = Seconds(10)
    s += Seconds(30)
    assert_equal(s, Seconds(40))


def test_sub():
    assert_equal(Seconds(24) - Seconds(10), Seconds(14))


def test_isub():
    var s = Seconds(50)
    s -= Seconds(15)
    assert_equal(s, Seconds(35))


def test_mul():
    assert_equal(Seconds(10) * 30, Seconds(300))
    assert_equal(30 * Seconds(10), Seconds(300))


def test_imul():
    var s = Seconds(5)
    s *= 10
    assert_equal(s, Seconds(50))


def test_truediv():
    assert_equal(Seconds(10) / Seconds(5), Seconds(2))


def test_itruediv():
    var s = Seconds(20)
    s /= Seconds(2)
    assert_equal(s, Seconds(10))


def test_mod():
    assert_equal(Seconds(20) % Seconds(7), Seconds(6))


def test_imod():
    var s = Seconds(30)
    s %= Seconds(5)
    assert_equal(s, Seconds(0))


def test_abs():
    assert_equal(abs(Seconds(-1)), Seconds(1))


def test_pow():
    assert_equal(Seconds(2) ** Seconds(4), Seconds(16))


def test_round():
    assert_equal(round(Seconds(2)), Seconds(2))
    assert_equal(round(Seconds(1.456)), Seconds(1.0))
    assert_equal(round(Seconds(1.135), 1), Seconds(1.1))


def test_str():
    assert_equal(String(Seconds(10)), "10s")
    assert_equal(String(Minutes(3)), "3min")
    assert_equal(String(Hours(7)), "7h")
    assert_equal(String(Days(20)), "20d")
    assert_equal(String(Months(2)), "2months")
    assert_equal(String(Weeks(21)), "21weeks")
    assert_equal(String(Years(30)), "30y")

    alias FakeTime = Time[Ratio[42, 25]()]
    assert_equal(String(FakeTime(20)), "20(42/25)s")

    alias EmojiTime = Time[Ratio[1, 420, "🔥"]()]
    assert_equal(String(EmojiTime(300)), "300🔥")


def test_ratio_mul():
    assert_true(Ratio[2, 3]() * Ratio[1, 6]() == Ratio[2, 18]())

    alias R = Ratio.Milli * Ratio.Milli
    # ops must preserve suffix string
    assert_equal(R.suffix, "ms")


def test_ratio_div():
    assert_true(Ratio[1, 4]() / Ratio[5, 4]() == Ratio[4, 20]())


def test_ratio_simplify():
    assert_true(Ratio[2, 18]().simplify() == Ratio[1, 9]())


def test_ratio_with_suffix():
    assert_true(Ratio[1, 2, "f"]().with_suffix["T"]() == Ratio[1, 2, "T"]())
