defmodule Magnetissimo.SizeConverter do

  def size_to_bytes(nil, _unit), do: :error
  def size_to_bytes(size, unit) do
    parse(Integer.parse(size), unit)
  end

  defp parse(:error, _), do: :error

  defp parse({size_int, _trailing}, unit) do
    size_to_bytesp(size_int, unit)
  end

  defp size_to_bytesp(size_int, "KB") do
    size_int * 1024
  end

  defp size_to_bytesp(size_int, "MB") do
    size_to_bytesp(size_int, "KB") * 1024
  end

  defp size_to_bytesp(size_int, "GB") do
    size_to_bytesp(size_int, "MB") * 1024
  end

  defp size_to_bytesp(size_int, "TB") do
    size_to_bytesp(size_int, "GB") * 1024
  end
end
