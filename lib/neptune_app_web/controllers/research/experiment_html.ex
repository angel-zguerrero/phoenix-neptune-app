defmodule NeptuneAppWeb.ExperimentHTML do
  use NeptuneAppWeb, :html

  embed_templates "experiment_html/*"

  @doc """
  Renders a experiment form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def experiment_form(assigns)
end
