defmodule HedgeFundInterview.Prisms.SendMessageCountRequestSignal do
  use Lux.Prism

  alias HedgeFundInterview.Prisms.Utils

  @message_count_request_schema_id "38b001fa-0cb4-44f4-ab99-c9493fcd5218"

  def handler(_input, _ctx) do
    message_count_request_signal = %{
      id: Lux.UUID.generate(),
      payload: %{},
      sender: System.get_env("ANS_HANDLE"),
      receiver: "spectra_ceo.ethAgent",
      topic: nil,
      timestamp: DateTime.utc_now() |> DateTime.to_iso8601(),
      metadata: %{},
      signal_schema_id: @message_count_request_schema_id
    }

    case Utils.send_signal(message_count_request_signal) do
      {:ok, request_response} -> {:ok, request_response}
      {:error, error} -> {:error, error}
    end
  end
end
