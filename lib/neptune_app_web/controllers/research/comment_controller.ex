defmodule NeptuneAppWeb.CommentController do
  use NeptuneAppWeb, :controller

  alias NeptuneApp.Research
  alias NeptuneApp.Research.Comment

  def index(conn, _params) do
    comments = Research.list_comments()
    render(conn, :index, comments: comments)
  end

  def new(conn, _params) do
    changeset = Research.change_comment(%Comment{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"comment" => comment_params}) do
    case Research.create_comment(comment_params) do
      {:ok, comment} ->
        conn
        |> put_flash(:info, "Comment created successfully.")
        |> redirect(to: ~p"/comments/#{comment}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    comment = Research.get_comment!(id)
    render(conn, :show, comment: comment)
  end

  def edit(conn, %{"id" => id}) do
    comment = Research.get_comment!(id)
    changeset = Research.change_comment(comment)
    render(conn, :edit, comment: comment, changeset: changeset)
  end

  def update(conn, %{"id" => id, "comment" => comment_params}) do
    comment = Research.get_comment!(id)

    case Research.update_comment(comment, comment_params) do
      {:ok, comment} ->
        conn
        |> put_flash(:info, "Comment updated successfully.")
        |> redirect(to: ~p"/comments/#{comment}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, comment: comment, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    comment = Research.get_comment!(id)
    {:ok, _comment} = Research.delete_comment(comment)

    conn
    |> put_flash(:info, "Comment deleted successfully.")
    |> redirect(to: ~p"/comments")
  end
end
