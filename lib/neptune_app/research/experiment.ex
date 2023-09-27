defmodule NeptuneApp.Research.Experiment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "experiments" do
    field :name, :string
    field :status, Ecto.Enum, values: [:in_progress, :completed, :paused, :canceled]
    field :description, :string
    field :results, :string
    field :conclusions, :string

    timestamps()
  end

  @doc false
  def changeset(experiment, attrs) do
    experiment
    |> cast(attrs, [:name, :description, :results, :conclusions, :status])
    |> validate_required([:name, :description, :results, :conclusions, :status])
  end
end
