defmodule NeptuneApp.Research.Collaborator do
  use Ecto.Schema
  import Ecto.Changeset

  schema "collaborators" do
    field :role, :string

    timestamps()
  end

  @doc false
  def changeset(collaborator, attrs) do
    collaborator
    |> cast(attrs, [:role])
    |> validate_required([:role])
  end
end
