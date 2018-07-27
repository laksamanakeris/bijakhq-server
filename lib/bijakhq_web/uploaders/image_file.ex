defmodule Bijakhq.ImageFile do
  use Arc.Definition

  # Include ecto support (requires package arc_ecto installed):
  use Arc.Ecto.Definition

  @versions [:original]

  # Whitelist file extensions:
  def validate({file, _}) do
    ~w(.jpg .jpeg .gif .png) |> Enum.member?(Path.extname(file.file_name))
  end

  # # # Define a thumbnail transformation:
  def transform(:original, _) do
    {:convert, "-strip -thumbnail 400x400^ -gravity center -extent 400x400"}
  end

  # Override the storage directory:
  def storage_dir(version, {file, scope}) do

    "uploads/user/avatars"
  end

  def __storage, do: Arc.Storage.GCS

  def gcs_object_headers(:original, {file, _scope}) do
    [content_type: MIME.from_path(file.file_name)]
  end

end
