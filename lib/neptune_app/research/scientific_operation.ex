defmodule NeptuneApp.Research.ScientificOperation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "scientific_operations" do
    field :type, :string
    field :result, :map
    field :parameters, :map
    field :remoteId, :string
    field :remoteStatus, :string
    field :remoteResult, :map

    timestamps()
  end

  @doc false
  def changeset(scientific_operation, attrs) do
    scientific_operation
    |> cast(attrs, [:type, :remoteId, :remoteStatus, :remoteResult, :parameters, :result])
    |> validate_required([:type, :remoteId, :remoteStatus, :remoteResult, :parameters, :result])
  end
end
