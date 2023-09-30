defmodule NeptuneAppWeb.ExperimentHTML do
  use NeptuneAppWeb, :html

  embed_templates "experiment_html/*"

  @doc """
  Renders a experiment form.
  """
  attr :changeset, Ecto.Changeset, required: false
  attr :action, :string, required: false

  def experiment_form(assigns)
end
