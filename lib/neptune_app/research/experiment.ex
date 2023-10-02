defmodule NeptuneApp.Research.Experiment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "experiments" do
    field :name, :string
    field :status, Ecto.Enum, values: [:in_progress, :completed, :paused, :canceled, :idle], default: :idle
    field :description, :string
    field :results, :string
    field :conclusions, :string

    belongs_to :created_by, NeptuneApp.Accounts.User, foreign_key: :created_by_id

    timestamps()
  end

  @doc false
  def changeset(experiment, attrs) do
    experiment
    |> cast(attrs, [:name, :description, :results, :conclusions, :status])
    |> validate_required([:name, :description])
  end
  @doc false
  def changeset_create(experiment, attrs) do
    experiment
    |> cast(attrs, [:name, :description, :results, :conclusions, :status])
    |> validate_required([:name, :description])
    |> Ecto.Changeset.put_assoc(:created_by, attrs["created_by"])
  end
end
