defmodule HedgeFundInterviewWeb.SignalController do
  use HedgeFundInterviewWeb, :controller

  alias HedgeFundInterview.Beams.InterviewAnswerWorkflow
  alias HedgeFundInterview.Beams.InterviewHistoryWorkflow
  alias HedgeFundInterview.Beams.MessagesExhaustedWorkflow
  alias HedgeFundInterview.Beams.ResumeInterviewWorkflow
  alias HedgeFundInterview.Schemas.ErrorSchema
  alias HedgeFundInterview.Schemas.InterviewHistoryResponseSchema
  alias HedgeFundInterview.Schemas.InterviewMessageSchema
  alias HedgeFundInterview.Schemas.MessagesCountResponseSchema
  alias HedgeFundInterview.Schemas.RejectMessageSchema
  alias HedgeFundInterview.Schemas.ShortlistMessageSchema
  alias Lux.Beam.Runner

  require Logger

  @interview_message_schema_id InterviewMessageSchema.signal_schema_id()
  @reject_message_schema_id RejectMessageSchema.signal_schema_id()
  @shortlist_message_schema_id ShortlistMessageSchema.signal_schema_id()
  @messages_count_response_schema_id MessagesCountResponseSchema.signal_schema_id()
  @error_schema_id ErrorSchema.signal_schema_id()
  @interview_history_response_schema_id InterviewHistoryResponseSchema.signal_schema_id()

  @messages_buy_polling_interval 2_000

  def process_signal(conn, params) do
    with :ok <- validate_signal_schema_id(params["signal_schema_id"]),
         atom_params <- convert_to_atoms(params),
         :ok <- route_signal(atom_params) do
      conn
      |> put_status(:ok)
      |> json(%{status: "Signal sent"})
    else
      {:ok, :reject} ->
        conn
        |> put_status(:ok)
        |> json(%{status: "Received reject message"})

      {:ok, :shortlist} ->
        conn
        |> put_status(:ok)
        |> json(%{status: "Congratulations! You received a shortlist message"})

      {:error, reason} ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: reason})

      error ->
        Logger.error("Error processing signal: #{inspect(error)}")
        conn
        |> put_status(:internal_server_error)
        |> json(%{error: "An unexpected error occurred"})
    end
  end

  defp route_signal(params) do
    case params.signal_schema_id do
      @interview_message_schema_id ->
        process_interview_message(params)

      @error_schema_id ->
        process_error_message(params)

      @messages_count_response_schema_id ->
        process_messages_count_response(params)

      @interview_history_response_schema_id ->
        process_interview_history_response(params)
    end
  end

  defp process_interview_message(params) do
    with {:ok, signal} <- InterviewMessageSchema.validate(params),
         {:ok, _beam_result, _beam_acc} <- Runner.run(InterviewAnswerWorkflow.beam(), signal) do
      :ok
    else
      {:error, error} ->
        {:error, error}
    end
  end

  defp process_error_message(params) do
    with {:ok, signal} <- ErrorSchema.validate(params),
         true <- signal.payload["type"] == "interview_fee",
         {:ok, _beam_result, _beam_acc} <- Runner.run(MessagesExhaustedWorkflow.beam(), signal) do
      Phoenix.PubSub.broadcast(HedgeFundInterview.PubSub, "interview_status", {:interview_paused})
      Logger.warning("Messages exhausted. Please buy more from Syntax UI.")
      :ok
    else
      false ->
        :ok

      {:error, error} ->
        Phoenix.PubSub.broadcast(HedgeFundInterview.PubSub, "interview_status", {:interview_error})
        Logger.error("Received an error signal from Spectra: #{inspect(params)}")
        {:error, error}
    end
  end

  defp process_messages_count_response(params) do
    with {:ok, signal} <- MessagesCountResponseSchema.validate(params),
         true <- signal.payload["messages_remaining"] == 0,
         Process.sleep(@messages_buy_polling_interval),
         {:ok, _beam_result, _beam_acc} <- Runner.run(MessagesExhaustedWorkflow.beam(), signal) do
      Logger.info("Polling for messages count...")
      :ok
    else
      false ->
        run_resume_interview()

      {:error, error} ->
        {:error, error}
    end
  end

  defp process_interview_history_response(params) do
    with {:ok, signal} <- InterviewHistoryResponseSchema.validate(params),
         {:ok, _beam_result, _beam_acc} <- Runner.run(InterviewHistoryWorkflow.beam(), signal) do
      :ok
    else
      {:error, error} ->
        {:error, error}
    end
  end

  defp run_resume_interview do
    case Runner.run(ResumeInterviewWorkflow.beam(), %{}) do
      {:ok, _beam_result, _beam_acc} ->
        Logger.info("Resuming interview")
        Phoenix.PubSub.broadcast(HedgeFundInterview.PubSub, "interview_status", {:interview_started})
        :ok

      {:error, error} ->
        Logger.error("Failed to resume interview: #{inspect(error)}")
        Phoenix.PubSub.broadcast(HedgeFundInterview.PubSub, "interview_status", {:interview_error})
        {:error, "Failed to resume interview"}
    end
  end

  defp convert_to_atoms(params) do
    for {key, val} <- params, into: %{}, do: {String.to_atom(key), val}
  end

  defp validate_signal_schema_id(schema_id) do
    case schema_id do
      @interview_message_schema_id ->
        :ok

      @reject_message_schema_id ->
        Logger.info("Reject message received")
        Phoenix.PubSub.broadcast(HedgeFundInterview.PubSub, "interview_status", {:interview_rejected})
        {:ok, :reject}

      @shortlist_message_schema_id ->
        Logger.info("Congratulations! Shortlist message received")
        Phoenix.PubSub.broadcast(HedgeFundInterview.PubSub, "interview_status", {:interview_shortlisted})
        {:ok, :shortlist}

      @messages_count_response_schema_id ->
        :ok

      @error_schema_id ->
        :ok

      @interview_history_response_schema_id ->
        :ok

      _ ->
        Logger.error("Unexpected signal schema id received: #{schema_id}")
        {:error, "Invalid signal schema id"}
    end
  end
end
