ExUnit.start()
ExUnit.configure exclude: :remote

Application.put_env(:chargify, :subdomain, "my-subdomain")
Application.put_env(:chargify, :api_key, "my-api-key")
