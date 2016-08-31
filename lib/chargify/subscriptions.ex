defmodule Chargify.Subscriptions do
  @moduledoc """
  Implements the Chargify Subscriptions API.

  See: <https://docs.chargify.com/api-subscriptions>
  """

  @doc """
  Get a page of subscriptions (20 per page).

  ## Params

  * `:page` - The page number to fetch.  Chargify defaults to page `1`.
  * `:direction` - The direction to sort the returned list, either
    `asc` (ascending) or `desc` (descending) based on when the subscription was created.
  * `:per_page` - The number of records per page to return.  Chargify
    defaults this to `20`, and enforces a max of `50`.
  """

  @spec list(Keyword.t) :: {:ok, list}
  def list(params \\ []) do
    Chargify.get_json(
      "/subscriptions",
      params,
      base_key: "subscription",
      allowed_params: [:page, :direction, :per_page]
    )
  end

  @doc """
  Get a single subscription by ID.

  Returns either a `Map` of the subscription data, or `nil` if the subscription was not found.
  """
  @spec get(integer | binary) :: {:ok, list} | {:not_found, nil}
  def get(id) do
    Chargify.get_json("/subscriptions/#{id}", [], base_key: "subscription")
  end

  @doc """
  Create a subscription with the given Map of data.
  """
  def create(params) do
    Chargify.post_json(
      "/subscriptions",
      params,
      base_key: "subscription"
    )
  end

end
