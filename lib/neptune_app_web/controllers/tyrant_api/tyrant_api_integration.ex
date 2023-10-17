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
          remoteResult: response.body,
        }
        duration = if (Map.has_key?(scientific_operation_result, "resultData")) do
          if(Map.has_key?(scientific_operation_result["resultData"],"execution_time")) do
            scientific_operation_result["resultData"]["execution_time"]
          else
            0
          end
        else
          :nil
        end

        attrs = if(duration != :nil)do
           Map.put(attrs, :duration, duration)
        else
          attrs
        end

        progress = if (Map.has_key?(scientific_operation_result, "progress")) do
          scientific_operation_result["progress"]
        else
          :nil
        end

        attrs = if(progress != :nil)do
          Map.put(attrs, :progress, progress)
        else
          attrs
        end

        servers = if (Map.has_key?(scientific_operation_result, "resultData")) do
          if(Map.has_key?(scientific_operation_result["resultData"],"executors")) do
            Jason.encode!(scientific_operation_result["resultData"]["executors"])
          else
            []
          end
        else
          :nil
        end

        attrs = if(servers != :nil)do
           Map.put(attrs, :servers, servers)
        else
          attrs
        end

        attrs = if attrs.remoteStatus == "success" && (scientific_operation_result["operation"]["type"] == "factorial" || scientific_operation_result["operation"]["type"] == "integral_trapezoidal") do
          Map.put(attrs, :result, "#{scientific_operation_result["resultData"]["result"]["value"]}")
        else
          attrs
        end

        attrs = if attrs.remoteStatus == "failed" && Map.has_key?(scientific_operation_result, "failedReason") do
          Map.put(attrs, :result, "#{scientific_operation_result["failedReason"]}")
        else
          attrs
        end

        case Research.update_scientific_operation(scientific_operation, attrs) do
          {:ok, _scientific_operation} ->
            IO.inspect("Success saving #{scientific_operation_remote_id}")
            Phoenix.PubSub.broadcast(NeptuneApp.PubSub,"experiments:#{scientific_operation.experiment_id}:scientific_operation_all", {scientific_operation.experiment_id, :scientific_operation_all})
            Phoenix.PubSub.broadcast(NeptuneApp.PubSub,"experiments:#{scientific_operation.experiment_id}:scientific_operations", %{scientific_operation_id: scientific_operation.id})
          error ->
            IO.inspect(error)
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
