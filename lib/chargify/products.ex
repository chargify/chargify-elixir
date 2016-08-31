defmodule Chargify.Products do
  @moduledoc """
  Implements the Chargify Products API.

  See: <https://docs.chargify.com/api-products>
  """

  @doc """
  Get a page of products (5 per page).

  ## Params

  * `:page` - The page number to fetch.  Chargify defaults to page `1` by
    default.
  * `:per_page` - The number of records per page to return.  Chargify
    defaults this to `5`, and enforces a max of `50`.
  * `:include_archived` - A flag (`1` or `true`) to indicate whether or not to display
    archived products.
  """
  @spec list(Keyword.t) :: {:ok, list}
  def list(params \\ []) do
    Chargify.get_json(
      "/products",
      params,
      base_key: "product",
      allowed_params: [:page, :per_page, :include_archived]
    )
  end

  @doc """
  Get a single Product by ID.

  Returns either a `Map` of the product data, or `nil` if the product was not
  found.
  """
  @spec get(integer | binary) :: {:ok, list} | {:not_found, nil}
  def get(id) do
    Chargify.get_json("/products/#{id}", [], base_key: "product")
  end

  @doc """
  Create a Product with the given Map of data.
  """
  def create(params) do
    id = params["product_family_id"]
    Chargify.post_json(
      "/product_families/#{id}/products",
      params,
      base_key: "product"
    )
  end

  @doc """
  Archive a Product by ID.
  """
  def archive(id) do
    Chargify.delete_json(
      "/products/#{id}",
      base_key: "product"
    )
  end
end
