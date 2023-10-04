defmodule NeptuneAppWeb.TyrantApi.TyrantApiIntegration do
  use GenServer
  alias NeptuneApp.Research

  def init(_init_arg) do
    {:ok, %{}}
  end

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def processOperationUpdate(scientific_operation_remote_id) do
    GenServer.cast(__MODULE__, scientific_operation_remote_id)
  end

  def handle_cast(scientific_operation_remote_id, state) do
    tyrant_api_base_url = Application.fetch_env!(:neptune_app, :tyrant_api_base_url)
    {:ok, response} = HTTPoison.get("#{tyrant_api_base_url}/scientist-operator/find/#{scientific_operation_remote_id}", [{"Accept", "*/*"}, {"Content-Type", "application/json"}])
    if response.status_code == 200 do
      scientific_operation = Research.get_scientific_operation_by_remote_id!(scientific_operation_remote_id)
      if scientific_operation != nil do
        scientific_operation_result = Jason.decode!(response.body)
        attrs = %{
          remoteStatus: scientific_operation_result["status"],
          remoteResult: response.body
        }
        attrs = if attrs.remoteStatus == "success" && scientific_operation_result["operation"]["type"] == "factorial" do
          Map.put(attrs, :result, scientific_operation_result["resultData"]["result"]["value"])
        else
          attrs
        end
        case Research.update_scientific_operation(scientific_operation, attrs) do
          {:ok, _scientific_operation} ->
            IO.inspect("Success saving #{scientific_operation_remote_id}")
          {:error, %Ecto.Changeset{} = _changeset} ->
            IO.inspect("Error saving #{scientific_operation_remote_id}")
        end
      end
    end
    Process.sleep(1000)
    {:noreply, state}
  end

  def handle_info(_msg, state) do
    {:noreply, state}
  end
end
