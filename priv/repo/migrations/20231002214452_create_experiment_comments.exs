defmodule NeptuneApp.Repo.Migrations.CreateExperimentComments do
  use Ecto.Migration

  def change do
    alter table(:comments) do
      add :experiment_id, references(:experiments, on_delete: :delete_all)
    end
  end
end
