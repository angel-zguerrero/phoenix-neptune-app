defmodule NeptuneAppWeb.TyrantApi.TyrantApiIntegrationScheduler do
  use Quantum, otp_app: :neptune_app

  alias NeptuneApp.Research
  alias NeptuneApp.Research.Ingestion

  @ingest_scientific_operation_ingestion_code "ingest-scientific-operation-ingestion-code"
  def ingest_scientific_operation do
    require Logger
    ingestion = Research.get_ingestion_by_code!(@ingest_scientific_operation_ingestion_code)
    ingestion = if ingestion == :nil do
      intestion_params = %{code: "ingest-scientific-operation-ingestion-code", lastDate: nil}
      {:ok, ingestion} = Research.create_ingestion(intestion_params)
      ingestion
    else
      ingestion
    end
    last_scientific_operation = fetch_scientific_operations(ingestion.lastDate, :nil)
    if last_scientific_operation != :nil do
      intestion_params = %{code: "ingest-scientific-operation-ingestion-code", lastDate: last_scientific_operation["updatedAt"]}
      {:ok, ingestion} = Research.update_ingestion(ingestion, intestion_params)
    end
  end

  def fetch_scientific_operations(lastDate, cursor) do
    filter = if(lastDate != :nil) do
      %{updatedAt: %{
        "$gte" => lastDate
      }}
    else
      %{}
    end
    tyrant_api_base_url = Application.fetch_env!(:neptune_app, :tyrant_api_base_url)
    payload = %{filter: filter, sort: 1, limit: 100, fieldOrder: "updatedAt", cursor: cursor}
    body = Jason.encode!(payload)
    request = %HTTPoison.Request{
      method: :get,
      url: "#{tyrant_api_base_url}/scientist-operator/search",
      body: body,
      headers: [{"Accept", "*/*"}, {"Content-Type", "application/json"}]
    }
    {:ok, response} = HTTPoison.request(request)
    if response.status_code == 200 do
      scientific_operations_result = Jason.decode!(response.body)
      Enum.each(scientific_operations_result["results"], fn scientific_operation ->
        NeptuneAppWeb.TyrantApi.TyrantApiIntegration.processOperationUpdate(scientific_operation["_id"])
      end)
      if scientific_operations_result["cursor"] != :nil do
        fetch_result = fetch_scientific_operations(lastDate, scientific_operations_result["cursor"])
        fetch_result || List.last(scientific_operations_result["results"])
      else
        List.last(scientific_operations_result["results"])
      end
    end
  end
end
