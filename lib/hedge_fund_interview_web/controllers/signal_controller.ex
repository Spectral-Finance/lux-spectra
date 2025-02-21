defmodule HedgeFundInterviewWeb.SignalController do
  use HedgeFundInterviewWeb, :controller

  alias HedgeFundInterview.Beams.BeginInterview
  alias HedgeFundInterview.Beams.InterviewAnswerWorkflow
  alias HedgeFundInterview.Beams.MessagesExhaustedWorkflow
  alias HedgeFundInterview.Schemas.ErrorSchema
  alias HedgeFundInterview.Schemas.InterviewMessageSchema
  alias HedgeFundInterview.Schemas.MessagesCountResponseSchema
  alias HedgeFundInterview.Schemas.RejectMessageSchema
  alias HedgeFundInterview.Schemas.ShortlistMessageSchema
  alias Lux.Beam.Runner

  require Logger

  @start_interview """
    Hi, I'm Botoshi NakAImoto. I appreciate the opportunity to discuss how my background can contribute to your hedge fund. My expertise lies at the intersection of blockchain protocols, quantitative finance, and software engineering. Over the past few years, I’ve focused on building algorithmic trading systems that leverage machine learning and advanced statistical models to capture inefficiencies in both centralized and decentralized crypto markets.

    In my recent work, I’ve explored L2 scaling solutions and sidechains to address throughput constraints for high-frequency trading, while simultaneously researching on-chain liquidity protocols—like Uniswap v3 and Curve—to design automated market-making strategies that mitigate impermanent loss. I’m also comfortable applying time-series analysis, factor models, and option pricing frameworks to crypto assets, ensuring robust risk management in volatile environments.

    I'm excited to dive into the details of my projects and discuss how my skill set aligns with your firm's trading and DeFi initiatives.
  """

  @interview_message_schema_id InterviewMessageSchema.signal_schema_id()
  @reject_message_schema_id RejectMessageSchema.signal_schema_id()
  @shortlist_message_schema_id ShortlistMessageSchema.signal_schema_id()
  @messages_count_response_schema_id MessagesCountResponseSchema.signal_schema_id()
  @error_schema_id ErrorSchema.signal_schema_id()

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

  def begin_interview(conn, _params) do
    case Runner.run(BeginInterview.beam(), @start_interview) do
      {:ok, _beam_result, _beam_acc} ->
        conn
        |> put_status(:ok)
        |> json(%{status: "success"})

      {:error, _error} ->
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
      Logger.warning("Messages exhausted. Please buy more from Syntax UI.")
      :ok
    else
      false ->
        :ok

      {:error, error} ->
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
        #TODO: Continue interview workflow when memory is implemented
        :ok

      {:error, error} ->
        {:error, error}
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
        {:ok, :reject}

      @shortlist_message_schema_id ->
        Logger.info("Congratulations! Shortlist message received")
        {:ok, :shortlist}

      @messages_count_response_schema_id ->
        :ok

      @error_schema_id ->
        :ok

      _ ->
        Logger.error("Unexpected signal schema id received: #{schema_id}")
        {:error, "Invalid signal schema id"}
    end
  end
end
