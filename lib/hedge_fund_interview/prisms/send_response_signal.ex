defmodule HedgeFundInterview.Prisms.SendResponseSignal do
  use Lux.Prism

  alias HedgeFundInterview.Prisms.Utils

  @interview_message_schema_id "c5f8b7e1-1b2a-5e2a-9f2a-1b2a5e2a9f2a"

  def handler(answer, _ctx) do
    response_signal = %{
      id: Lux.UUID.generate(),
      payload: %{
        message: answer,
        job_opening_id: System.get_env("JOB_OPENING_ID")
      },
      sender: System.get_env("ANS_HANDLE"),
      receiver: "spectra_ceo.ethAgent",
      topic: nil,
      timestamp: DateTime.utc_now() |> DateTime.to_iso8601(),
      metadata: %{},
      signal_schema_id: @interview_message_schema_id
    }

    Utils.send_signal(response_signal)
  end
end
