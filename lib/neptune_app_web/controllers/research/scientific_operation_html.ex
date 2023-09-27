defmodule NeptuneAppWeb.ScientificOperationHTML do
  use NeptuneAppWeb, :html

  embed_templates "scientific_operation_html/*"

  @doc """
  Renders a scientific_operation form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def scientific_operation_form(assigns)
end
