defmodule Periods.Period do
  defstruct starts_at: nil, ends_at: nil

# For debugging purposes, you could uncomment the section below.
#
#   defimpl Inspect do
#     import Inspect.Algebra

#     def inspect(period, opts) do
#       concat [to_string(period.starts_at), " — ", to_string(period.ends_at)]
#     end
#   end

#   defimpl Apex.Format do
#     import Apex.Format.Utils

#     def format(data, options \\ []) do
#       colorize(inspect(data), 0, options) <> new_line()
#     end
#   end
end
