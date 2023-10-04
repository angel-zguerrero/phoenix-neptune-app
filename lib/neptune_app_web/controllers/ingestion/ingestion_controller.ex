defmodule NeptuneAppWeb.IngestionController do
  use NeptuneAppWeb, :controller

  alias NeptuneApp.Research
  alias NeptuneApp.Research.Ingestion

  action_fallback NeptuneAppWeb.FallbackController

  def index(conn, _params) do
    ingestions = Research.list_ingestions()
    render(conn, :index, ingestions: ingestions)
  end

  def create(conn, %{"ingestion" => ingestion_params}) do
    with {:ok, %Ingestion{} = ingestion} <- Research.create_ingestion(ingestion_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/ingestions/#{ingestion}")
      |> render(:show, ingestion: ingestion)
    end
  end

  def show(conn, %{"id" => id}) do
    ingestion = Research.get_ingestion!(id)
    render(conn, :show, ingestion: ingestion)
  end

  def update(conn, %{"id" => id, "ingestion" => ingestion_params}) do
    ingestion = Research.get_ingestion!(id)

    with {:ok, %Ingestion{} = ingestion} <- Research.update_ingestion(ingestion, ingestion_params) do
      render(conn, :show, ingestion: ingestion)
    end
  end

  def delete(conn, %{"id" => id}) do
    ingestion = Research.get_ingestion!(id)

    with {:ok, %Ingestion{}} <- Research.delete_ingestion(ingestion) do
      send_resp(conn, :no_content, "")
    end
  end
end
