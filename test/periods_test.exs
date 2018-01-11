defmodule Periods.Test do
  use ExUnit.Case
  alias Periods.Period
  doctest Periods

  describe "intersect identical Periods." do

    test "simple" do
      a = %Period{
        starts_at: ~D[2017-01-09],
        ends_at: ~D[2017-07-14]
      }

      b = %Period{
        starts_at: ~D[2017-01-09],
        ends_at: ~D[2017-07-14]
      }

      result =
        %Period{
          starts_at: ~D[2017-01-09],
          ends_at: ~D[2017-07-14]
        }

      assert result == Periods.intersect(a, b)
    end

    test "infinite" do
      a = %Period{
        starts_at: nil,
        ends_at: nil
      }

      b = %Period{
        starts_at: nil,
        ends_at: nil
      }

      result =
        %Period{
          starts_at: nil,
          ends_at: nil
        }

      assert result == Periods.intersect(a, b)
    end

    test "forever until" do
      a = %Period{
        starts_at: nil,
        ends_at: ~D[2012-01-01]
      }

      b = %Period{
        starts_at: nil,
        ends_at: ~D[2012-01-01]
      }

      result =
        %Period{
          starts_at: nil,
          ends_at: ~D[2012-01-01]
        }

      assert result == Periods.intersect(a, b)
    end

    test "forever after" do
      a = %Period{
        starts_at: ~D[2012-01-01],
        ends_at: nil
      }

      b = %Period{
        starts_at: ~D[2012-01-01],
        ends_at: nil
      }

      result =
        %Period{
          starts_at: ~D[2012-01-01],
          ends_at: nil
        }

      assert result == Periods.intersect(a, b)
    end


  end

  describe "intersect contained Periods." do

    test "b inside a" do
      a = %Period{
        starts_at: ~D[2017-01-09],
        ends_at: ~D[2017-09-14]
      }

      b = %Period{
        starts_at: ~D[2017-03-03],
        ends_at: ~D[2017-09-08]
      }

      result = b

      assert result == Periods.intersect(a, b)
    end

    test "a inside b" do
      a = %Period{
        starts_at: ~D[2017-03-03],
        ends_at: ~D[2017-09-08]
      }

      b = %Period{
        starts_at: ~D[2017-01-09],
        ends_at: ~D[2017-09-14]
      }

      result = a

      assert result == Periods.intersect(a, b)
    end

    test "b inside a forever until" do
      a = %Period{
        starts_at: nil,
        ends_at: ~D[2017-09-14]
      }

      b = %Period{
        starts_at: ~D[2017-03-03],
        ends_at: ~D[2017-09-08]
      }

      result = b

      assert result == Periods.intersect(a, b)
    end

    test "b inside a forever after" do
      a = %Period{
        starts_at: ~D[2017-01-09],
        ends_at: nil
      }

      b = %Period{
        starts_at: ~D[2017-03-03],
        ends_at: ~D[2017-09-08]
      }

      result = b

      assert result == Periods.intersect(a, b)
    end

    test "b is forever, a is forever until" do
      a = %Period{
        starts_at: nil,
        ends_at: ~D[2016-02-04]
      }

      b = %Period{
        starts_at: nil,
        ends_at: nil
      }

      result = a

      assert result == Periods.intersect(a, b)
    end

  end

  describe "intersect partially overlapping Periods." do

    test "b starts and ends after a" do
      a = %Period{
        starts_at: ~D[2017-01-09],
        ends_at: ~D[2017-07-14]
      }

      b = %Period{
        starts_at: ~D[2017-03-03],
        ends_at: ~D[2017-09-08]
      }

      result = %Period{
        starts_at: ~D[2017-03-03],
        ends_at: ~D[2017-07-14]
      }

      assert result == Periods.intersect(a, b)
    end

    test "b starts and ends after a, one day overlapping" do
      a = %Period{
        starts_at: ~D[2017-01-09],
        ends_at: ~D[2017-02-14]
      }

      b = %Period{
        starts_at: ~D[2017-02-14],
        ends_at: ~D[2017-09-08]
      }

      result = %Period{
        starts_at: ~D[2017-02-14],
        ends_at: ~D[2017-02-14]
      }

      assert result == Periods.intersect(a, b)
    end

    test "b overlaps with a forever until" do
      a = %Period{
        starts_at: nil,
        ends_at: ~D[2017-09-14]
      }

      b = %Period{
        starts_at: ~D[2017-03-03],
        ends_at: ~D[2017-09-16]
      }

      result = %Period{
        starts_at: ~D[2017-03-03],
        ends_at: ~D[2017-09-14]
      }

      assert result == Periods.intersect(a, b)
    end

    test "b is forever after, a is forever until" do
      a = %Period{
        starts_at: nil,
        ends_at: ~D[2017-09-14]
      }

      b = %Period{
        starts_at: ~D[2017-03-03],
        ends_at: nil
      }

      result = %Period{
        starts_at: ~D[2017-03-03],
        ends_at: ~D[2017-09-14]
      }

      assert result == Periods.intersect(a, b)
    end

  end

  describe "non-overlapping Periods." do

    test "b after a, non-neighbouring" do
      a = %Period{
        starts_at: ~D[2017-01-09],
        ends_at: ~D[2017-02-14]
      }

      b = %Period{
        starts_at: ~D[2017-03-03],
        ends_at: ~D[2017-09-08]
      }

      Periods.intersect(a, b)
      assert is_nil(Periods.intersect(a, b))
    end

    test "b after a, neighbouring" do
      a = %Period{
        starts_at: ~D[2017-01-09],
        ends_at: ~D[2017-02-14]
      }

      b = %Period{
        starts_at: ~D[2017-02-15],
        ends_at: ~D[2017-09-08]
      }

      assert is_nil(Periods.intersect(a, b))
    end

  end

  describe "inspecting" do
    test "renders valid start and end" do
      a = %Period{
        starts_at: ~D[2017-01-09],
        ends_at: ~D[2017-02-14]
      }

      assert inspect(a) == "2017-01-09 — 2017-02-14"
    end
  end
end
