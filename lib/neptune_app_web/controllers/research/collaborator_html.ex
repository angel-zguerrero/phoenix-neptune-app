defmodule NeptuneAppWeb.CollaboratorHTML do
  use NeptuneAppWeb, :html

  embed_templates "collaborator_html/*"

  @doc """
  Renders a collaborator form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def collaborator_form(assigns)
end
