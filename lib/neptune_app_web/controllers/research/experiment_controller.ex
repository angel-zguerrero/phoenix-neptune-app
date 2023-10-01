defmodule NeptuneAppWeb.ExperimentController do
  use NeptuneAppWeb, :controller

  alias NeptuneApp.Research
  alias NeptuneApp.Research.Experiment

  def index(conn, _params) do
    experiments = Research.list_experiments()
    render(conn, :index, experiments: experiments)
  end

  def new(conn, _params) do
    changeset = Research.change_experiment(%Experiment{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"experiment" => experiment_params}) do
    current_user =  conn.assigns[:current_user]
    experiment_params = Map.put(experiment_params, "created_by", current_user)
    case Research.create_experiment(experiment_params) do
      {:ok, experiment} ->
        conn
        |> put_flash(:info, "Experiment created successfully.")
        |> redirect(to: ~p"/experiments/#{experiment}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    experiment = Research.get_experiment!(id)
    scientificOperationChangeset = Research.change_scientific_operation(%NeptuneApp.Research.ScientificOperation{})
    render(conn, :show, experiment: experiment, scientificOperationChangeset: scientificOperationChangeset)
  end

  def edit(conn, %{"id" => id}) do
    experiment = Research.get_experiment!(id)
    changeset = Research.change_experiment(experiment)
    render(conn, :edit, experiment: experiment, changeset: changeset)
  end

  def update(conn, %{"id" => id, "experiment" => experiment_params}) do
    experiment = Research.get_experiment!(id)

    case Research.update_experiment(experiment, experiment_params) do
      {:ok, experiment} ->
        conn
        |> put_flash(:info, "Experiment updated successfully.")
        |> redirect(to: ~p"/experiments/#{experiment}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, experiment: experiment, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    experiment = Research.get_experiment!(id)
    {:ok, _experiment} = Research.delete_experiment(experiment)

    conn
    |> put_flash(:info, "Experiment deleted successfully.")
    |> redirect(to: ~p"/experiments")
  end
end
