defmodule NeptuneApp.Research do
  @moduledoc """
  The Research context.
  """

  import Ecto.Query, warn: false
  alias NeptuneApp.Repo

  alias NeptuneApp.Research.Collaborator

  @doc """
  Returns the list of collaborators.

  ## Examples

      iex> list_collaborators()
      [%Collaborator{}, ...]

  """
  def list_collaborators do
    Repo.all(Collaborator)
  end

  @doc """
  Gets a single collaborator.

  Raises `Ecto.NoResultsError` if the Collaborator does not exist.

  ## Examples

      iex> get_collaborator!(123)
      %Collaborator{}

      iex> get_collaborator!(456)
      ** (Ecto.NoResultsError)

  """
  def get_collaborator!(id), do: Repo.get!(Collaborator, id)

  @doc """
  Creates a collaborator.

  ## Examples

      iex> create_collaborator(%{field: value})
      {:ok, %Collaborator{}}

      iex> create_collaborator(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_collaborator(attrs \\ %{}) do
    %Collaborator{}
    |> Collaborator.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a collaborator.

  ## Examples

      iex> update_collaborator(collaborator, %{field: new_value})
      {:ok, %Collaborator{}}

      iex> update_collaborator(collaborator, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_collaborator(%Collaborator{} = collaborator, attrs) do
    collaborator
    |> Collaborator.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a collaborator.

  ## Examples

      iex> delete_collaborator(collaborator)
      {:ok, %Collaborator{}}

      iex> delete_collaborator(collaborator)
      {:error, %Ecto.Changeset{}}

  """
  def delete_collaborator(%Collaborator{} = collaborator) do
    Repo.delete(collaborator)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking collaborator changes.

  ## Examples

      iex> change_collaborator(collaborator)
      %Ecto.Changeset{data: %Collaborator{}}

  """
  def change_collaborator(%Collaborator{} = collaborator, attrs \\ %{}) do
    Collaborator.changeset(collaborator, attrs)
  end

  alias NeptuneApp.Research.Experiment

  @doc """
  Returns the list of experiments.

  ## Examples

      iex> list_experiments()
      [%Experiment{}, ...]

  """
  def list_experiments do
    Repo.all(Experiment)
    |> Repo.preload(:created_by)
  end

  @doc """
  Gets a single experiment.

  Raises `Ecto.NoResultsError` if the Experiment does not exist.

  ## Examples

      iex> get_experiment!(123)
      %Experiment{}

      iex> get_experiment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_experiment!(id), do: Repo.get!(Experiment, id) |> Repo.preload(:created_by)

  @doc """
  Creates a experiment.

  ## Examples

      iex> create_experiment(%{field: value})
      {:ok, %Experiment{}}

      iex> create_experiment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_experiment(attrs \\ %{}) do
    %Experiment{}
    |> Experiment.changeset_create(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a experiment.

  ## Examples

      iex> update_experiment(experiment, %{field: new_value})
      {:ok, %Experiment{}}

      iex> update_experiment(experiment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_experiment(%Experiment{} = experiment, attrs) do
    experiment
    |> Experiment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a experiment.

  ## Examples

      iex> delete_experiment(experiment)
      {:ok, %Experiment{}}

      iex> delete_experiment(experiment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_experiment(%Experiment{} = experiment) do
    Repo.delete(experiment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking experiment changes.

  ## Examples

      iex> change_experiment(experiment)
      %Ecto.Changeset{data: %Experiment{}}

  """
  def change_experiment(%Experiment{} = experiment, attrs \\ %{}) do
    Experiment.changeset(experiment, attrs)
  end

  alias NeptuneApp.Research.Comment

  @doc """
  Returns the list of comments.

  ## Examples

      iex> list_comments()
      [%Comment{}, ...]

  """
  def list_comments do
    Repo.all(Comment)
  end

  @doc """
  Gets a single comment.

  Raises `Ecto.NoResultsError` if the Comment does not exist.

  ## Examples

      iex> get_comment!(123)
      %Comment{}

      iex> get_comment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_comment!(id), do: Repo.get!(Comment, id)

  @doc """
  Creates a comment.

  ## Examples

      iex> create_comment(%{field: value})
      {:ok, %Comment{}}

      iex> create_comment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_comment(attrs \\ %{}) do
    %Comment{}
    |> Comment.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a comment.

  ## Examples

      iex> update_comment(comment, %{field: new_value})
      {:ok, %Comment{}}

      iex> update_comment(comment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_comment(%Comment{} = comment, attrs) do
    comment
    |> Comment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a comment.

  ## Examples

      iex> delete_comment(comment)
      {:ok, %Comment{}}

      iex> delete_comment(comment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_comment(%Comment{} = comment) do
    Repo.delete(comment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking comment changes.

  ## Examples

      iex> change_comment(comment)
      %Ecto.Changeset{data: %Comment{}}

  """
  def change_comment(%Comment{} = comment, attrs \\ %{}) do
    Comment.changeset(comment, attrs)
  end

  alias NeptuneApp.Research.ScientificOperation

  @doc """
  Returns the list of scientific_operations.

  ## Examples

      iex> list_scientific_operations()
      [%ScientificOperation{}, ...]

  """
  def list_scientific_operations do
    Repo.all(ScientificOperation)
    |> Repo.preload(:created_by)
  end

  def list_scientific_operations(experiment_id) when experiment_id != :nil do
    query = from so in ScientificOperation, where: so.experiment_id == ^experiment_id
    Repo.all(query)
    |> Repo.preload(:created_by)
  end

  @doc """
  Gets a single scientific_operation.

  Raises `Ecto.NoResultsError` if the Scientific operation does not exist.

  ## Examples

      iex> get_scientific_operation!(123)
      %ScientificOperation{}

      iex> get_scientific_operation!(456)
      ** (Ecto.NoResultsError)

  """
  def get_scientific_operation!(id), do: Repo.get!(ScientificOperation, id) |> Repo.preload(:created_by) |> Repo.preload(:experiment)

  @doc """
  Creates a scientific_operation.

  ## Examples

      iex> create_scientific_operation(%{field: value})
      {:ok, %ScientificOperation{}}

      iex> create_scientific_operation(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_scientific_operation(attrs \\ %{}) do
    %ScientificOperation{}
    |> ScientificOperation.changeset_create(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a scientific_operation.

  ## Examples

      iex> update_scientific_operation(scientific_operation, %{field: new_value})
      {:ok, %ScientificOperation{}}

      iex> update_scientific_operation(scientific_operation, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_scientific_operation(%ScientificOperation{} = scientific_operation, attrs) do
    scientific_operation
    |> ScientificOperation.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a scientific_operation.

  ## Examples

      iex> delete_scientific_operation(scientific_operation)
      {:ok, %ScientificOperation{}}

      iex> delete_scientific_operation(scientific_operation)
      {:error, %Ecto.Changeset{}}

  """
  def delete_scientific_operation(%ScientificOperation{} = scientific_operation) do
    Repo.delete(scientific_operation)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking scientific_operation changes.

  ## Examples

      iex> change_scientific_operation(scientific_operation)
      %Ecto.Changeset{data: %ScientificOperation{}}

  """
  def change_scientific_operation(%ScientificOperation{} = scientific_operation, attrs \\ %{}) do
    ScientificOperation.changeset(scientific_operation, attrs)
  end
end
