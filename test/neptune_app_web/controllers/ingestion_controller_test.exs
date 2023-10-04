defmodule NeptuneAppWeb.IngestionControllerTest do
  use NeptuneAppWeb.ConnCase

  import NeptuneApp.ResearchFixtures

  alias NeptuneApp.Research.Ingestion

  @create_attrs %{
    code: "some code",
    lastDate: ~T[14:00:00]
  }
  @update_attrs %{
    code: "some updated code",
    lastDate: ~T[15:01:01]
  }
  @invalid_attrs %{code: nil, lastDate: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all ingestions", %{conn: conn} do
      conn = get(conn, ~p"/api/ingestions")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create ingestion" do
    test "renders ingestion when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/ingestions", ingestion: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/ingestions/#{id}")

      assert %{
               "id" => ^id,
               "code" => "some code",
               "lastDate" => "14:00:00"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/ingestions", ingestion: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update ingestion" do
    setup [:create_ingestion]

    test "renders ingestion when data is valid", %{conn: conn, ingestion: %Ingestion{id: id} = ingestion} do
      conn = put(conn, ~p"/api/ingestions/#{ingestion}", ingestion: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/ingestions/#{id}")

      assert %{
               "id" => ^id,
               "code" => "some updated code",
               "lastDate" => "15:01:01"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, ingestion: ingestion} do
      conn = put(conn, ~p"/api/ingestions/#{ingestion}", ingestion: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete ingestion" do
    setup [:create_ingestion]

    test "deletes chosen ingestion", %{conn: conn, ingestion: ingestion} do
      conn = delete(conn, ~p"/api/ingestions/#{ingestion}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/ingestions/#{ingestion}")
      end
    end
  end

  defp create_ingestion(_) do
    ingestion = ingestion_fixture()
    %{ingestion: ingestion}
  end
end
