defmodule NeptuneApp.Research.Ingestion do
  use Ecto.Schema
  import Ecto.Changeset

  schema "ingestions" do
    field :code, :string
    field :lastDate, :string

    timestamps()
  end

  @doc false
  def changeset(ingestion, attrs) do
    ingestion
    |> cast(attrs, [:code, :lastDate])
    |> validate_required([:code])
  end
end
