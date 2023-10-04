defmodule NeptuneAppWeb.IngestionJSON do
  alias NeptuneApp.Research.Ingestion

  @doc """
  Renders a list of ingestions.
  """
  def index(%{ingestions: ingestions}) do
    %{data: for(ingestion <- ingestions, do: data(ingestion))}
  end

  @doc """
  Renders a single ingestion.
  """
  def show(%{ingestion: ingestion}) do
    %{data: data(ingestion)}
  end

  defp data(%Ingestion{} = ingestion) do
    %{
      id: ingestion.id,
      code: ingestion.code,
      lastDate: ingestion.lastDate
    }
  end
end
