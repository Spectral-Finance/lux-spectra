defmodule HedgeFundInterview.Prisms.RequestInterviewHistory do
  use Lux.Prism

  alias HedgeFundInterview.Schemas.InterviewHistoryRequestSchema
  alias HedgeFundInterview.Prisms.Utils

  def handler(_input, _ctx) do
    signal = %{
      id: Lux.UUID.generate(),
      payload: %{
        job_opening_id: System.get_env("JOB_OPENING_ID")
      },
      sender: System.get_env("ANS_HANDLE"),
      receiver: "spectra_ceo.ethAgent",
      timestamp: DateTime.utc_now() |> DateTime.to_iso8601(),
      metadata: %{},
      signal_schema_id: InterviewHistoryRequestSchema.signal_schema_id()
    }

    Utils.send_signal(signal)
  end
end
