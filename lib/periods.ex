defmodule Periods do
  @moduledoc """
  Functions to manipulate Periods.

  Periods have a start and end date. Any of them can be
  `nil` to indicate there is no boundary.
  """

  alias Periods.Period

  @doc """
  Intersect two periods

  ## Examples

      iex> Periods.intersect(%Period{
      ...>   start_at: ~D[2017-01-09],
      ...>   end_at: ~D[2017-07-14]
      ...> }, %Period{
      ...>   start_at: ~D[2017-02-09],
      ...>   end_at: ~D[2017-07-01]
      ...> })
      %Period{start_at: ~D[2017-02-09], end_at: ~D[2017-07-01]}
  """
  def intersect(%Period{} = period1, %Period{} = period2) do
    periods = [period1, period2]
    start_at =
      periods
      |> Enum.map(&Map.get(&1, :start_at))
      |> Enum.reject(&is_nil/1)
      |> Enum.map(&Timex.to_unix/1)
      |> max()
    end_at =
      periods
      |> Enum.map(&Map.get(&1, :end_at))
      |> Enum.reject(&is_nil/1)
      |> Enum.map(&Timex.to_unix/1)
      |> min()
    new(start_at, end_at)
  end

  defp max([]) do
    nil
  end
  defp max(list) do
    Enum.max(list)
  end
  defp min([]) do
    nil
  end
  defp min(list) do
    Enum.min(list)
  end

  defp new(start_at, end_at)
  when (start_at > end_at) and not is_nil(start_at) and not is_nil(end_at) do
    nil
  end
  defp new(start_at_seconds, end_at_seconds) do
    %Period{
      start_at: (start_at_seconds
                |> to_date()),
      end_at: (end_at_seconds
              |> to_date())
    }
  end

  defp to_date(nil) do
    nil
  end
  defp to_date(seconds) do
    seconds
    |> Timex.from_unix()
    |> Timex.to_date()
  end
end
