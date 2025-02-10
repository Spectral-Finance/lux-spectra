defmodule HedgeFundInterview.Prisms.SendResponseSignal do
  use Lux.Prism


  def handler(answer, _ctx) do
    response_signal = %{
      id: Lux.UUID.generate(),
      payload: %{
        message: answer,
        job_opening_id: "3141592653"
      },
      sender: "rick_deckard",
      receiver: "spectra_ceo",
      timestamp: "2024-03-19T10:30:00Z",
      metadata: %{},
      signal_schema_id: "c5f8b7e1-1b2a-5e2a-9f2a-1b2a5e2a9f2a"
    }

    case send_signal(response_signal) do
      {:ok, request_response} ->
        {:ok, request_response}

      {:error, error} ->
        {:error, error}
    end
  end

  defp send_signal(signal) do
    case Req.post("http://localhost:4040/signals/register", json: signal) do
      {:ok, response} -> {:ok, response}
      {:error, error} -> {:error, error}
    end
  end
end
