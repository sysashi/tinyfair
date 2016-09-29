defmodule TinyFair.ProductImage do
  use Arc.Definition
  use Arc.Ecto.Definition

  # Include ecto support (requires package arc_ecto installed):

  @versions [:identicon]

  # To add a thumbnail version:
  # @versions [:original, :thumb]

  # Whitelist file extensions:
  # def validate({file, _}) do
  #   ~w(.jpg .jpeg .gif .png) |> Enum.member?(Path.extname(file.file_name))
  # end

  # Define a thumbnail transformation:
  # def transform(:thumb, _) do
  #   {:convert, "-strip -thumbnail 250x250^ -gravity center -extent 250x250 -format png", :png}
  # end

  # Override the persisted filenames:
  # def filename(version, _) do
  #  version
  # end

  def filename(version, {file, scope}), do: "#{file.file_name}"

  # Override the storage directory:
  def storage_dir(version, {file, scope}) do
    "priv/static/images/products/#{version}/"
  end

  # Provide a default URL if there hasn't been a file uploaded
  def default_url(version, scope) do
    "http://placehold.it/50x50"
  end

  # Specify custom headers for s3 objects
  # Available options are [:cache_control, :content_disposition,
  #    :content_encoding, :content_length, :content_type,
  #    :expect, :expires, :storage_class, :website_redirect_location]
  #
  # def s3_object_headers(version, {file, scope}) do
  #   [content_type: Plug.MIME.path(file.file_name)]
  # end
  def __storage, do: Arc.Storage.Local

end
