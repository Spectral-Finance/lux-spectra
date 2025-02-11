defmodule HedgeFundInterviewWeb.PageController do
  use HedgeFundInterviewWeb, :controller

  def home(conn, _params) do
    prompt = case File.read("prompt.txt") do
      {:ok, content} -> content
      {:error, _} -> "Error reading prompt file. Please ensure prompt.txt exists in the root directory."
    end

    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false, prompt: prompt)
  end
end
