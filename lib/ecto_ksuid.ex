defmodule Ecto.Ksuid do
  @moduledoc """
  Documentation for `Ecto.Ksuid`.
  """

  use Ecto.ParameterizedType

  def init(opts) do
    opts
    |> Enum.into(%{})
  end

  def type(_params), do: :"char(27)"

  def cast(value, _params) do
    {:ok, value}
  end

  def dump(value, _loader, params) when is_binary(value) do
    value
    |> remove_prefix(params)
    |> validate_length()
  end

  def dump(value, _loader, _params) when is_nil(value) do
    {:ok, value}
  end

  def dump(_value, _loader, _params) do
    :error
  end

  def load(value, _loader, params) when is_binary(value) do
    {:ok, "#{prefix(params)}#{value}"}
  end

  def load(value, _loader, _params) when is_nil(value) do
    {:ok, value}
  end

  def equal?(a, b, _params) do
    a == b
  end

  def autogenerate(params) do
    "#{prefix(params)}#{Ksuid.generate()}"
  end

  defp remove_prefix(id, params) do
    id
    |> String.replace_leading(prefix(params), "")
  end

  defp prefix(params) do
    params
    |> Map.get(:prefix)
    |> case do
      nil -> ""
      val -> "#{val}_"
    end
  end

  defp validate_length(ksuid) do
    case String.length(ksuid) == 27 do
      true -> {:ok, ksuid}
      false -> :error
    end
  end
end
