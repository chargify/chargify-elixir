defmodule Chargify do
  @moduledoc """
  A "base" on which the endpoint-specific APIs are built.  If you're adding new
  API endpoints, you'll want to use this.  Otherwise, see the modules nested
  beneath this one.
  """

  @doc """
  Perform a generic GET request to Chargify for JSON data.

  This function is generally used by the "sub-modules" that work with the
  documented Chargify API endpoints.  It _can_ be used directly to make
  arbitrary JSON requests to Chargify, if needed.

  ## Arguments

  * `path` - The "path part" of the URL to fetch, i.e. `/customers`.
  * `params` - The query params to send, as a `Keyword` list.
  * `options` - Context-sensitive options that inform how the request/response
    is handled. See below.

  ## Options

  * `:base_key` - The key in the response under which the actual data is nested.
    For example, fetching a customer from the Chargify API returns JSON like the
    the following:

  ```js
  {
    "customer": {
      "first_name": "Michael"
    }
  }
  ```

  By specifying `base_key: "customer"`, then the key will be removed and the
  map returned will just be the data:

  ```
  %{"first_name" => "Michael"}
  ```

  * `:allowed_params` - A list of allowed/expected query param keys to be
    passed along with the request.  By using this, we can take in params
    collected as an argument from the user, but make sure only the expected
    params are passed along to the API. For example, consider the following:

  ```
  defmodule Chargify.MyResource do
    def list(params \\ [])
      Chargify.get_json("/my_resource", params, allowed_keys: [:page])
    end
  end

  Chargify.MyResource.list(page: 5, foo: "bar")
  # The above will issue a GET with `page` included as a query param, but
  # `foo` will be dropped:
  #     https://subdomain.chargify.com/my_resource?page=5
  ```

  """
  def get_json(path, params \\ [], options \\ []) do
    HTTPoison.get!(url(path), json_headers, build_options(params, options))
    |> handle_response(options[:base_key])
  end

  def post_json(path, params \\ [], options \\ []) do
    data = %{ options[:base_key] => params }
    HTTPoison.post!(url(path), encode(data), json_headers, auth_options)
    |> handle_response(options[:base_key])
  end

  defp handle_response(%HTTPoison.Response{} = response, base_key) do
    case response.status_code do
      200 -> {:ok, decode(response.body, base_key)}
      201 -> {:created, decode(response.body, base_key)}
      404 -> {:not_found, nil}
      422 -> {:invalid, decode(response.body, "errors")}
    end
  end

  defp decode(body, base_key) do
    Poison.decode!(body)
      |> remove_nesting(base_key)
  end

  defp encode(map) do
    Poison.encode!(map)
  end

  defp url(path) do
    base_url <> path
  end

  defp json_headers do
    [
      {"Accept", "application/json"},
      {"Content-Type", "application/json"}
    ]
  end

  defp build_options([], _), do: auth_options
  defp build_options(params, options) when is_list(params) do
    allowed_params = Keyword.get(options, :allowed_params)
    if allowed_params do
      params = Keyword.take(params, allowed_params)
    end

    Keyword.put(auth_options, :params, params)
  end

  defp auth_options do
    [ hackney: [ basic_auth: {api_key, "X"} ] ]
  end

  defp base_url do
    "https://#{subdomain}.chargify.com"
  end

  defp subdomain do
    System.get_env("CHARGIFY_SUBDOMAIN") || Application.get_env(:chargify, :subdomain)
  end

  defp api_key do
    System.get_env("CHARGIFY_API_KEY") || Application.get_env(:chargify, :api_key)
  end

  defp remove_nesting(data, nil), do: data
  defp remove_nesting(data, top_level_key) when is_map(data) do
    Map.fetch!(data, top_level_key)
  end
  defp remove_nesting(data, top_level_key) when is_list(data) do
    Enum.map data, &Map.fetch!(&1, top_level_key)
  end
end
