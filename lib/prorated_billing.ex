defmodule Prorate do
  import Decimal, only: [from_float: 1, round: 2]

  def month_days(date) do
    start_date = Date.beginning_of_month(date)
    end_date = Date.end_of_month(date)
    %{start: start_date, end: end_date}
  end

  def intersection(user, month) do
    %{activation: activation, deactivated: deactivated} = user
    # IO.puts("activation #{activation}")
    month_start = Date.beginning_of_month(month)
    # IO.puts("month_start #{month_start}")
    # IO.puts("comp #{Date.compare(activation, month_start)}")
    month_end = Date.end_of_month(month)

    effective_start = cond do
      Date.compare(activation, month_end) == :gt -> nil
      Date.compare(activation, month_start) == :gt -> activation
      :true -> month_start
    end

    effective_end = cond do 
      deactivated == nil -> month_end
      Date.compare(deactivated, month_start) == :lt  -> nil
      Date.compare(deactivated, month_end) == :lt -> deactivated
      :true -> month_end
    end
    
    IO.puts "start: #{effective_start} end: #{effective_end}"
    %{start: effective_start, end: Date.add(effective_end, 1)}
  end

  def days(start_date, end_date) when start_date < end_date, do: days(end_date, start_date) 
  def days(start_date, end_date) do
    cond do 
      start_date == nil -> 0
      end_date == nil -> 0
      :true -> Date.diff(start_date, end_date)
    end
  end

  def prorate(user, month) do
    %{start: start_date, end: end_date} = intersection(user, month)
    num_of_days = days(start_date, end_date)
    %{rate: rate} = user
    IO.puts("rate #{rate}, num_of_days: #{num_of_days}")
    (rate * num_of_days) / 100
      |> from_float()
      |> round(2)
  end

  def prorate_users(users, month) do
    Enum.reduce(users, Decimal.new("0"), fn user, acc -> Decimal.add(prorate(user, month), acc) end)
  end
end
