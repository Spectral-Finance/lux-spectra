# HedgeFundInterview

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Setting Up Environment Variables

This project uses environment variables for configuration. To set up your local environment:

1. Copy the example environment file:
   ```sh
   cp .env.example .env
   ```

2. Open the `.env` file and fill in your API keys and other configuration

## Using your own prompt

Modify the contents of `prompt.txt` to your own initial prompt that will be used to instruct the LLM when responding to an incoming question.