defmodule NeptuneAppWeb.UserRegistrationController do
  use NeptuneAppWeb, :controller

  alias NeptuneApp.Accounts
  alias NeptuneApp.Accounts.User
  alias NeptuneAppWeb.UserAuth
  alias NeptuneApp.Constants
  require Constants

  def new(conn, _params) do
    changeset = Accounts.change_user_registration(%User{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    current_user = conn.assigns[:current_user]
    role =
    if current_user != :nil do
      Map.fetch!(user_params, "role")
    else
      Constants.role_admin
    end
    user_params = Map.put(user_params, "role", role)
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &url(~p"/users/confirm/#{&1}")
          )

        if current_user do
          conn
          |> put_flash(:info, "User created successfully.")
          |> redirect(to: ~p"/")
        else
          conn
          |> put_flash(:info, "User created successfully.")
          |> UserAuth.log_in_user(user)
        end

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end
end
