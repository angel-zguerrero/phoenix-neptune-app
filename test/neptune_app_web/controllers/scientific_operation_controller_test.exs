defmodule NeptuneAppWeb.ScientificOperationControllerTest do
  use NeptuneAppWeb.ConnCase

  import NeptuneApp.ResearchFixtures

  @create_attrs %{type: "some type", result: %{}, parameters: %{}, remoteId: "some remoteId", remoteStatus: "some remoteStatus", remoteResult: %{}}
  @update_attrs %{type: "some updated type", result: %{}, parameters: %{}, remoteId: "some updated remoteId", remoteStatus: "some updated remoteStatus", remoteResult: %{}}
  @invalid_attrs %{type: nil, result: nil, parameters: nil, remoteId: nil, remoteStatus: nil, remoteResult: nil}

  describe "index" do
    test "lists all scientific_operations", %{conn: conn} do
      conn = get(conn, ~p"/scientific_operations")
      assert html_response(conn, 200) =~ "Listing Scientific operations"
    end
  end

  describe "new scientific_operation" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/scientific_operations/new")
      assert html_response(conn, 200) =~ "New Scientific operation"
    end
  end

  describe "create scientific_operation" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/scientific_operations", scientific_operation: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/scientific_operations/#{id}"

      conn = get(conn, ~p"/scientific_operations/#{id}")
      assert html_response(conn, 200) =~ "Scientific operation #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/scientific_operations", scientific_operation: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Scientific operation"
    end
  end

  describe "edit scientific_operation" do
    setup [:create_scientific_operation]

    test "renders form for editing chosen scientific_operation", %{conn: conn, scientific_operation: scientific_operation} do
      conn = get(conn, ~p"/scientific_operations/#{scientific_operation}/edit")
      assert html_response(conn, 200) =~ "Edit Scientific operation"
    end
  end

  describe "update scientific_operation" do
    setup [:create_scientific_operation]

    test "redirects when data is valid", %{conn: conn, scientific_operation: scientific_operation} do
      conn = put(conn, ~p"/scientific_operations/#{scientific_operation}", scientific_operation: @update_attrs)
      assert redirected_to(conn) == ~p"/scientific_operations/#{scientific_operation}"

      conn = get(conn, ~p"/scientific_operations/#{scientific_operation}")
      assert html_response(conn, 200) =~ "some updated type"
    end

    test "renders errors when data is invalid", %{conn: conn, scientific_operation: scientific_operation} do
      conn = put(conn, ~p"/scientific_operations/#{scientific_operation}", scientific_operation: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Scientific operation"
    end
  end

  describe "delete scientific_operation" do
    setup [:create_scientific_operation]

    test "deletes chosen scientific_operation", %{conn: conn, scientific_operation: scientific_operation} do
      conn = delete(conn, ~p"/scientific_operations/#{scientific_operation}")
      assert redirected_to(conn) == ~p"/scientific_operations"

      assert_error_sent 404, fn ->
        get(conn, ~p"/scientific_operations/#{scientific_operation}")
      end
    end
  end

  defp create_scientific_operation(_) do
    scientific_operation = scientific_operation_fixture()
    %{scientific_operation: scientific_operation}
  end
end
