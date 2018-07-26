defmodule Bijakhq.ImageFile do
  use Arc.Definition

  # Include ecto support (requires package arc_ecto installed):
  use Arc.Ecto.Definition

  @versions [:original]

  # To add a thumbnail version:
  # @versions [:original, :thumb]

  # Override the bucket on a per definition basis:
  # def bucket do
  #   :bijakhq_avatars
  # end

  # Whitelist file extensions:
  def validate({file, _}) do
    ~w(.jpg .jpeg .gif .png) |> Enum.member?(Path.extname(file.file_name))
  end

  # # # Define a thumbnail transformation:
  def transform(:thumb, _) do
    {:convert, "-strip -thumbnail 400x400^ -gravity center -extent 400x400 -format png", :png}
  end

  # Override the persisted filenames:
  # def filename(version, {file, scope}) do
  #   IO.puts "================================================================================================"

  #   IO.inspect version
  #   IO.inspect file
  #   IO.inspect scope

  #   IO.puts "================================================================================================"
  #   case scope do
  #     nil ->
  #       version
  #     _ ->
  #       IO.inspect scope
  #       file_name = Path.basename(file.file_name, Path.extname(file.file_name))
  #       "#{scope.id}_#{version}_#{file_name}"
  #         # file_name = Path.basename(file.file_name, Path.extname(file.file_name))
  #         # "#{file_name}_#{version}_#{:os.system_time}"
  #         # https://elixirforum.com/t/how-can-i-use-unique-filename-generator-function-with-arc-ecto/4476/3
  #         # "avatar_#{scope.username}_#{version}"
  #   end
  # end

  def filename(version, {file, scope}) do
    file_name = Path.basename(file.file_name, Path.extname(file.file_name))
    "#{file_name}_#{version}_#{:os.system_time}"
  end

  # Override the storage directory:
  def storage_dir(version, {file, scope}) do

    "uploads/user/avatars"
  end

  # Provide a default URL if there hasn't been a file uploaded
  # def default_url(version, scope) do
  #   "/images/avatars/default_#{version}.png"
  # end

  # Specify custom headers for s3 objects
  # Available options are [:cache_control, :content_disposition,
  #    :content_encoding, :content_length, :content_type,
  #    :expect, :expires, :storage_class, :website_redirect_location]
  #
  # def s3_object_headers(version, {file, scope}) do
  #   [content_type: MIME.from_path(file.file_name)]
  # end

  def __storage, do: Arc.Storage.GCS

  def gcs_object_headers(:original, {file, _scope}) do
    [content_type: MIME.from_path(file.file_name)]
  end

end
