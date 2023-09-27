defmodule NeptuneAppWeb.CollaboratorControllerTest do
  use NeptuneAppWeb.ConnCase

  import NeptuneApp.ResearchFixtures

  @create_attrs %{role: "some role"}
  @update_attrs %{role: "some updated role"}
  @invalid_attrs %{role: nil}

  describe "index" do
    test "lists all collaborators", %{conn: conn} do
      conn = get(conn, ~p"/collaborators")
      assert html_response(conn, 200) =~ "Listing Collaborators"
    end
  end

  describe "new collaborator" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/collaborators/new")
      assert html_response(conn, 200) =~ "New Collaborator"
    end
  end

  describe "create collaborator" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/collaborators", collaborator: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/collaborators/#{id}"

      conn = get(conn, ~p"/collaborators/#{id}")
      assert html_response(conn, 200) =~ "Collaborator #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/collaborators", collaborator: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Collaborator"
    end
  end

  describe "edit collaborator" do
    setup [:create_collaborator]

    test "renders form for editing chosen collaborator", %{conn: conn, collaborator: collaborator} do
      conn = get(conn, ~p"/collaborators/#{collaborator}/edit")
      assert html_response(conn, 200) =~ "Edit Collaborator"
    end
  end

  describe "update collaborator" do
    setup [:create_collaborator]

    test "redirects when data is valid", %{conn: conn, collaborator: collaborator} do
      conn = put(conn, ~p"/collaborators/#{collaborator}", collaborator: @update_attrs)
      assert redirected_to(conn) == ~p"/collaborators/#{collaborator}"

      conn = get(conn, ~p"/collaborators/#{collaborator}")
      assert html_response(conn, 200) =~ "some updated role"
    end

    test "renders errors when data is invalid", %{conn: conn, collaborator: collaborator} do
      conn = put(conn, ~p"/collaborators/#{collaborator}", collaborator: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Collaborator"
    end
  end

  describe "delete collaborator" do
    setup [:create_collaborator]

    test "deletes chosen collaborator", %{conn: conn, collaborator: collaborator} do
      conn = delete(conn, ~p"/collaborators/#{collaborator}")
      assert redirected_to(conn) == ~p"/collaborators"

      assert_error_sent 404, fn ->
        get(conn, ~p"/collaborators/#{collaborator}")
      end
    end
  end

  defp create_collaborator(_) do
    collaborator = collaborator_fixture()
    %{collaborator: collaborator}
  end
end
