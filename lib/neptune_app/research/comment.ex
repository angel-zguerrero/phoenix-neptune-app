defmodule NeptuneApp.Research.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :content, :string

    belongs_to :created_by, NeptuneApp.Accounts.User, foreign_key: :created_by_id
    belongs_to :experiment, NeptuneApp.Research.Experiment, foreign_key: :experiment_id

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:content])
    |> validate_required([:content])
  end

    @doc false
    def changeset_create(scientific_operation, attrs) do
      scientific_operation
      |> cast(attrs, [:content])
      |> validate_required([:content])
      |> Ecto.Changeset.put_assoc(:created_by, attrs["created_by"])
      |> Ecto.Changeset.put_assoc(:experiment, attrs["experiment"])
    end
end
