defmodule DatingTest do
  use ExUnit.Case
  doctest Dating
  alias Dating.{Period}

  describe "intersect" do
    test "overlapping periods" do
      period1 = %Period{
        start_at: ~D[2017-01-09],
        end_at: ~D[2017-07-14]}

      period2 = %Period{
        start_at: ~D[2017-03-03],
        end_at: ~D[2017-09-08]}

      result = %Period{
        start_at: ~D[2017-03-03],
        end_at: ~D[2017-07-14]}

      assert result == Period.intersect(period1, period2)
    end

    test "non-overlapping periods" do
      period1 = %Period{
        start_at: ~D[2017-01-09],
        end_at: ~D[2017-02-14]}

      period2 = %Period{
        start_at: ~D[2017-03-03],
        end_at: ~D[2017-09-08]}

      Period.intersect(period1, period2)
      |> IO.inspect()
      assert is_nil(Period.intersect(period1, period2))
    end

    test "encompassing periods" do
      period1 = %Period{
        start_at: ~D[2017-01-09],
        end_at: ~D[2017-09-14]}

      period2 = %Period{
        start_at: ~D[2017-03-03],
        end_at: ~D[2017-09-08]}

      result = period2
      assert result == Period.intersect(period1, period2)
    end

    test "infinite periods" do
      period1 = %Period{
        start_at: nil,
        end_at: ~D[2017-09-14]}

      period2 = %Period{
        start_at: ~D[2017-03-03],
        end_at: ~D[2017-09-16]}

      result = %Period{
        start_at: ~D[2017-03-03],
        end_at: ~D[2017-09-14]}

      assert result == Period.intersect(period1, period2)
    end

    test "two infinite periods" do
      period1 = %Period{
        start_at: nil,
        end_at: nil}

      period2 = %Period{
        start_at: nil,
        end_at: nil}

      result = %Period{
        start_at: nil,
        end_at: nil}

      assert result == Period.intersect(period1, period2)
    end
    test "infinite with semi infinite period" do
      period1 = %Period{
        start_at: nil,
        end_at: ~D[2016-02-04]}

      period2 = %Period{
        start_at: nil,
        end_at: nil}

      result = %Period{
        start_at: nil,
        end_at: ~D[2016-02-04]}

      assert result == Period.intersect(period1, period2)
    end
  end
end
