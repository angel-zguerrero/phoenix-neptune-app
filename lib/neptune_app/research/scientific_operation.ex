defmodule NeptuneApp.Research.ScientificOperation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "scientific_operations" do
    field :type, Ecto.Enum, values: [:factorial], default: :factorial
    field :result, :string
    field :parameters, :string
    field :remoteId, :string
    field :remoteStatus, :string
    field :remoteResult, :string

    timestamps()
  end

  @doc false
  def changeset(scientific_operation, attrs) do
    scientific_operation
    |> cast(attrs, [:type, :parameters])
    |> validate_required([:type, :parameters])
  end
end
