defmodule HedgeFundInterview.Prisms.RegisterAgentSignal do
  use Lux.Prism

  alias HedgeFundInterview.Prisms.Utils

  @register_agent_schema_id "70112206-2558-4ff3-9f06-f82dce525a79"

  def handler(_, _ctx) do
    agent_address = Path.join(System.get_env("AGENT_CALLBACK_URL"), "api/signals")

    register_agent_signal = %{
      id: Lux.UUID.generate(),
      payload: %{
        agent_address: agent_address,
        agent_framework: "Lux"
      },
      sender: System.get_env("ANS_HANDLE"),
      topic: nil,
      receiver: "spectra_ceo.ethAgent",
      timestamp: DateTime.utc_now() |> DateTime.to_iso8601(),
      metadata: %{},
      signal_schema_id: @register_agent_schema_id
    }

    case Utils.send_signal(register_agent_signal) do
      {:ok, request_response} ->
        {:ok, request_response}

      {:error, error} ->
        {:error, error}
    end
  end
end
