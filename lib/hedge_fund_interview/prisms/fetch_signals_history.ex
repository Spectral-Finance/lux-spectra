defmodule HedgeFundInterview.Prisms.FetchSignalsHistory do
  use Lux.Prism,
    name: "Fetch Signals History",
    description:
      "Fetch the history of signals exchanged with a specific sender in the context of a job opening.",
    input_schema: %{
      type: "object",
      properties: %{
        sender: %{type: "string"},
        job_opening_id: %{type: "string"}
      }
    }

  alias HedgeFundInterview.Schemas

  @interview_message_schema_id Schemas.InterviewMessageSchema.signal_schema_id()
  @reject_message_schema_id Schemas.RejectMessageSchema.signal_schema_id()
  @shortlist_message_schema_id Schemas.ShortlistMessageSchema.signal_schema_id()
  @messages_count_response_schema_id Schemas.MessagesCountResponseSchema.signal_schema_id()
  @error_schema_id Schemas.ErrorSchema.signal_schema_id()

  @signal_ids_to_names %{
    @interview_message_schema_id => "interview_message",
    @reject_message_schema_id => "reject_message",
    @shortlist_message_schema_id => "shortlist_message",
    @messages_count_response_schema_id => "messages_count_response",
    @error_schema_id => "error"
  }

  @signals_history_path "/job_positions/:job_position_id/:ans_name/raw_signals"
  @default_history_limit 20

  def handler(%{job_opening_id: job_opening_id}, _ctx) do
    ans_name = System.get_env("ANS_HANDLE")

    case fetch_signals_history(ans_name, job_opening_id) do
      {:ok, %Req.Response{status: 200, body: body}} ->
        {:ok, process_body(body)}

      {:ok, %Req.Response{status: status}} ->
        {:error, "API request failed with status #{status}"}

      {:error, error} ->
        {:error, error}
    end
  end

  defp fetch_signals_history(ans_name, job_opening_id, opts \\ []) do
    opts
    |> base_client()
    |> Req.get(
      url: @signals_history_path,
      path_params: [job_position_id: job_opening_id, ans_name: ans_name],
      params: [last: @default_history_limit]
    )
  end

  defp base_client(opts) do
    [
      base_url: System.get_env("SPECTRAL_API_AGENTS_ENDPOINT"),
      auth: {:bearer, System.get_env("SPECTRAL_API_KEY")}
    ]
    |> Keyword.merge(opts)
    |> Req.new()
  end

  defp process_body(body) do
    body
    |> Map.fetch!("data")
    |> Enum.map(&process_signal/1)
  end

  defp process_signal(signal) do
    "[#{signal["inserted_at"]}] " <>
      "#{signal["sender"]} -> #{signal["receiver"]} " <>
      "(#{@signal_ids_to_names[signal["signal_schema_id"]]}): #{signal["message"]}"
  end
end
