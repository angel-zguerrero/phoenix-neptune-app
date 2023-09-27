defmodule NeptuneAppWeb.UserRegistrationHTML do
  use NeptuneAppWeb, :html
  alias NeptuneApp.Constants
  require Constants

  embed_templates "user_registration_html/*"

  def role_opts(_changeset) do
    for role <- [Constants.role_admin, Constants.role_scientist],
        do: [key: role, value: role, selected: role == Constants.role_scientist]
  end
end
