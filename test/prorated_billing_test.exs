defmodule TestProrate do
  use ExUnit.Case

  test "returns 0 if no overlap" do
    user = %{activation: ~D[2025-01-01], deactivated: nil, rate: 450}
    month = ~D[2020-02-02]
    result = Prorate.prorate(user, month)
    assert Decimal.equal?(result, Decimal.new("0"))
  end

  test "returns total due if starts before month and no deactivation  date" do
    user = %{activation: ~D[2025-01-01], deactivated: nil, rate: 450}
    month = ~D[2025-02-02]
    result = Prorate.prorate(user, month)
    expected = Decimal.mult(28, 450)
      |> Decimal.div(100)
    assert Decimal.equal?(result, expected)
  end

  test "returns total due if starts before month and deactivations after the month" do
    user = %{activation: ~D[2025-01-01], deactivated: ~D[2025-03-01], rate: 450}
    month = ~D[2025-02-02]
    result = Prorate.prorate(user, month)
    expected = Decimal.mult(28, 450)
      |> Decimal.div(100)
    assert Decimal.equal?(result, expected)
  end

  test "returns prorated total due if activation falls within month" do
    user = %{activation: ~D[2025-01-02], deactivated: ~D[2025-01-04], rate: 999}
    month = ~D[2025-01-01]
    result = Prorate.prorate(user, month)

    expected = Decimal.mult(3, 999)
      |> Decimal.div(100)

    IO.puts("result #{result}, expected: #{expected}")
    assert Decimal.equal?(result, expected)
  end

  test "returns full month due if activation equals start and end of month" do
    user = %{activation: ~D[2025-02-01], deactivated: ~D[2025-02-28], rate: 999}
    month = ~D[2025-02-01]
    result = Prorate.prorate(user, month)

    expected = Decimal.mult(28, 999)
      |> Decimal.div(100)

    IO.puts("result #{result}, expected: #{expected}")
    assert Decimal.equal?(result, expected)
  end

  @tag :only
  test "reduces list of array to get total" do
    user = %{activation: ~D[2025-02-01], deactivated: ~D[2025-02-28], rate: 999}
    user2 = %{activation: ~D[2025-01-01], deactivated: nil, rate: 450}
    month = ~D[2025-02-01]
    result = Prorate.prorate_users([user, user2], month)

    firstUser = 
      Decimal.mult(28, 999)
      |> Decimal.div(100)
    secondUser = 
      Decimal.mult(28, 450)
      |> Decimal.div(100)

    expected = 
      Decimal.add(firstUser, secondUser)

    IO.puts("result #{result}, expected: #{expected}")
    assert Decimal.equal?(result, expected)
  end
end

