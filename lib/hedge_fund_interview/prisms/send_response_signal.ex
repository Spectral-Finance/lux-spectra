defmodule HedgeFundInterview.Prisms.SendResponseSignal do
  use Lux.Prism

  @interview_message_schema_id "c5f8b7e1-1b2a-5e2a-9f2a-1b2a5e2a9f2a"


  def handler(answer, _ctx) do
    response_signal = %{
      id: Lux.UUID.generate(),
      payload: %{
        message: answer,
        job_opening_id: System.get_env("JOB_OPENING_ID")
      },
      sender: System.get_env("ANS_HANDLE"),
      receiver: "spectra_ceo",
      timestamp: DateTime.utc_now() |> DateTime.to_iso8601(),
      metadata: %{},
      signal_schema_id: @interview_message_schema_id
    }

    case send_signal(response_signal) do
      {:ok, request_response} ->
        {:ok, request_response}

      {:error, error} ->
        {:error, error}
    end
  end

  defp send_signal(signal) do
    endpoint = System.get_env("SPECTRAL_API_AGENTS_ENDPOINT")

    case Req.post("#{endpoint}/signals/register", json: signal) do
      {:ok, response} -> {:ok, response}
      {:error, error} -> {:error, error}
    end
  end
end
