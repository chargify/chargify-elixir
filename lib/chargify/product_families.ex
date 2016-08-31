defmodule Chargify.ProductFamilies do
  @moduledoc """
  Implements the Chargify Product Families API.

  See: <https://docs.chargify.com/api-product-families>
  """

  @doc """
  Get a page of product families.
  """
  @spec list :: {:ok, list}
  def list do
    Chargify.get_json(
      "/product_families",
      [],
      base_key: "product_family"
    )
  end

  @doc """
  Get a single Product Family by ID.

  Returns either a `Map` of the product family data, or `nil` if the product family was not
  found.
  """
  @spec get(integer | binary) :: {:ok, list} | {:not_found, nil}
  def get(id) do
    Chargify.get_json("/product_families/#{id}", [], base_key: "product_family")
  end

  @doc """
  Create a Product with the given Map of data.
  """
  def create(params) do
    Chargify.post_json(
      "/product_families",
      params,
      base_key: "product_family"
    )
  end
end
