defmodule Chargify.Customers do
  @moduledoc """
  Implements the Chargify Customers API.

  See: <https://docs.chargify.com/api-customers>
  """

  @doc """
  Get a page of customers (20 per page).

  ## Params

  * `:page` - The page number to fetch.  Chargify defaults to page `1` by
    default.
  * `:direction` - The direction to sort the returned customer list, either
    `asc` (ascending) or `desc` (descending) based on when the customer was
    created.
  * `:per_page` - The number of records per page to return.  Chargify
    defaults this to `20`, and enforces a max of `50`.
  """
  @spec list(Keyword.t) :: {:ok, list}
  def list(params \\ []) do
    Chargify.get_json(
      "/customers",
      params,
      base_key: "customer",
      allowed_params: [:page, :direction, :per_page]
    )
  end

  @doc """
  Get a single customer by ID.

  Returns either a `Map` of the customer data, or `nil` if the customer was not
  found.
  """
  @spec get(integer | binary) :: {:ok, list} | {:not_found, nil}
  def get(id) do
    Chargify.get_json("/customers/#{id}", [], base_key: "customer")
  end

  @doc """
  Create a customer with the given Map of data.
  """
  def create(params) do
    Chargify.post_json(
      "/customers",
      params,
      base_key: "customer"
    )
  end
end
