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
      ...>   starts_at: ~D[2017-01-09],
      ...>   ends_at: ~D[2017-07-14]
      ...> }, %Period{
      ...>   starts_at: ~D[2017-02-09],
      ...>   ends_at: ~D[2017-07-01]
      ...> })
      %Period{starts_at: ~D[2017-02-09], ends_at: ~D[2017-07-01]}
  """
  def intersect(%Period{} = period1, %Period{} = period2) do
    periods = [period1, period2]
    starts_at =
      periods
      |> Enum.map(&Map.get(&1, :starts_at))
      |> Enum.reject(&is_nil/1)
      |> Enum.map(&Timex.to_unix/1)
      |> max()
    ends_at =
      periods
      |> Enum.map(&Map.get(&1, :ends_at))
      |> Enum.reject(&is_nil/1)
      |> Enum.map(&Timex.to_unix/1)
      |> min()
    new(starts_at, ends_at)
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

  defp new(starts_at, ends_at)
  when (starts_at > ends_at) and not is_nil(starts_at) and not is_nil(ends_at) do
    nil
  end
  defp new(starts_at_seconds, ends_at_seconds) do
    %Period{
      starts_at: (starts_at_seconds
                |> to_date()),
      ends_at: (ends_at_seconds
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
