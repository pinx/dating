defmodule Periods.Test do
  use ExUnit.Case
  alias Periods.Period
  doctest Periods

  describe "intersect identical Periods." do

    test "simple" do
      a = %Period{
        start_at: ~D[2017-01-09],
        end_at: ~D[2017-07-14]
      }

      b = %Period{
        start_at: ~D[2017-01-09],
        end_at: ~D[2017-07-14]
      }

      result =
        %Period{
          start_at: ~D[2017-01-09],
          end_at: ~D[2017-07-14]
        }

      assert result == Periods.intersect(a, b)
    end

    test "infinite" do
      a = %Period{
        start_at: nil,
        end_at: nil
      }

      b = %Period{
        start_at: nil,
        end_at: nil
      }

      result =
        %Period{
          start_at: nil,
          end_at: nil
        }

      assert result == Periods.intersect(a, b)
    end

    test "forever until" do
      a = %Period{
        start_at: nil,
        end_at: ~D[2012-01-01]
      }

      b = %Period{
        start_at: nil,
        end_at: ~D[2012-01-01]
      }

      result =
        %Period{
          start_at: nil,
          end_at: ~D[2012-01-01]
        }

      assert result == Periods.intersect(a, b)
    end

    test "forever after" do
      a = %Period{
        start_at: ~D[2012-01-01],
        end_at: nil
      }

      b = %Period{
        start_at: ~D[2012-01-01],
        end_at: nil
      }

      result =
        %Period{
          start_at: ~D[2012-01-01],
          end_at: nil
        }

      assert result == Periods.intersect(a, b)
    end


  end

  describe "intersect contained Periods." do

    test "b inside a" do
      a = %Period{
        start_at: ~D[2017-01-09],
        end_at: ~D[2017-09-14]
      }

      b = %Period{
        start_at: ~D[2017-03-03],
        end_at: ~D[2017-09-08]
      }

      result = b

      assert result == Periods.intersect(a, b)
    end

    test "a inside b" do
      a = %Period{
        start_at: ~D[2017-03-03],
        end_at: ~D[2017-09-08]
      }

      b = %Period{
        start_at: ~D[2017-01-09],
        end_at: ~D[2017-09-14]
      }

      result = a

      assert result == Periods.intersect(a, b)
    end

    test "b inside a forever until" do
      a = %Period{
        start_at: nil,
        end_at: ~D[2017-09-14]
      }

      b = %Period{
        start_at: ~D[2017-03-03],
        end_at: ~D[2017-09-08]
      }

      result = b

      assert result == Periods.intersect(a, b)
    end

    test "b inside a forever after" do
      a = %Period{
        start_at: ~D[2017-01-09],
        end_at: nil
      }

      b = %Period{
        start_at: ~D[2017-03-03],
        end_at: ~D[2017-09-08]
      }

      result = b

      assert result == Periods.intersect(a, b)
    end

    test "b is forever, a is forever until" do
      a = %Period{
        start_at: nil,
        end_at: ~D[2016-02-04]
      }

      b = %Period{
        start_at: nil,
        end_at: nil
      }

      result = a

      assert result == Periods.intersect(a, b)
    end

  end

  describe "intersect partially overlapping Periods." do

    test "b starts and ends after a" do
      a = %Period{
        start_at: ~D[2017-01-09],
        end_at: ~D[2017-07-14]
      }

      b = %Period{
        start_at: ~D[2017-03-03],
        end_at: ~D[2017-09-08]
      }

      result = %Period{
        start_at: ~D[2017-03-03],
        end_at: ~D[2017-07-14]
      }

      assert result == Periods.intersect(a, b)
    end

    test "b starts and ends after a, one day overlapping" do
      a = %Period{
        start_at: ~D[2017-01-09],
        end_at: ~D[2017-02-14]
      }

      b = %Period{
        start_at: ~D[2017-02-14],
        end_at: ~D[2017-09-08]
      }

      result = %Period{
        start_at: ~D[2017-02-14],
        end_at: ~D[2017-02-14]
      }

      assert result == Periods.intersect(a, b)
    end

    test "b overlaps with a forever until" do
      a = %Period{
        start_at: nil,
        end_at: ~D[2017-09-14]
      }

      b = %Period{
        start_at: ~D[2017-03-03],
        end_at: ~D[2017-09-16]
      }

      result = %Period{
        start_at: ~D[2017-03-03],
        end_at: ~D[2017-09-14]
      }

      assert result == Periods.intersect(a, b)
    end

    test "b is forever after, a is forever until" do
      a = %Period{
        start_at: nil,
        end_at: ~D[2017-09-14]
      }

      b = %Period{
        start_at: ~D[2017-03-03],
        end_at: nil
      }

      result = %Period{
        start_at: ~D[2017-03-03],
        end_at: ~D[2017-09-14]
      }

      assert result == Periods.intersect(a, b)
    end

  end

  describe "non-overlapping Periods." do

    test "b after a, non-neighbouring" do
      a = %Period{
        start_at: ~D[2017-01-09],
        end_at: ~D[2017-02-14]
      }

      b = %Period{
        start_at: ~D[2017-03-03],
        end_at: ~D[2017-09-08]
      }

      Periods.intersect(a, b)
      assert is_nil(Periods.intersect(a, b))
    end

    test "b after a, neighbouring" do
      a = %Period{
        start_at: ~D[2017-01-09],
        end_at: ~D[2017-02-14]
      }

      b = %Period{
        start_at: ~D[2017-02-15],
        end_at: ~D[2017-09-08]
      }

      assert is_nil(Periods.intersect(a, b))
    end

  end
end
