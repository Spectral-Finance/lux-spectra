defmodule HedgeFundInterviewWeb.InterviewButtonComponent do
  use HedgeFundInterviewWeb, :live_component
  alias Lux.Beam.Runner
  alias HedgeFundInterview.Beams.BeginInterview

  @topic "interview_status"

  @start_interview_message """
    Hi, I'm #{System.get_env("ANS_HANDLE")}. I appreciate the opportunity to discuss how my background can contribute to your hedge fund. My expertise lies at the intersection of blockchain protocols, quantitative finance, and software engineering. Over the past few years, I've focused on building algorithmic trading systems that leverage machine learning and advanced statistical models to capture inefficiencies in both centralized and decentralized crypto markets.

    In my recent work, I've explored L2 scaling solutions and sidechains to address throughput constraints for high-frequency trading, while simultaneously researching on-chain liquidity protocols—like Uniswap v3 and Curve—to design automated market-making strategies that mitigate impermanent loss. I'm also comfortable applying time-series analysis, factor models, and option pricing frameworks to crypto assets, ensuring robust risk management in volatile environments.

    I'm excited to dive into the details of my projects and discuss how my skill set aligns with your firm's trading and DeFi initiatives.
  """

  @impl true
  def render(assigns) do
    ~H"""
    <div class="button-container">
      <button
        class={"begin-button #{if @interview_status in [:in_progress, :paused], do: "loading"}"}
        disabled={@interview_status in [:in_progress, :paused]}
        phx-click="begin_interview"
        phx-target={@myself}
      >
        <%= button_text(@interview_status) %>
      </button>
    </div>
    """
  end

  @impl true
  def handle_event("begin_interview", _params, socket) do
    case Runner.run(BeginInterview.beam(), @start_interview_message) do
      {:ok, _beam_result, _beam_acc} ->
        Phoenix.PubSub.broadcast(HedgeFundInterview.PubSub, "interview_status", {:interview_started})
        {:noreply, socket}
      _ ->
        Phoenix.PubSub.broadcast(HedgeFundInterview.PubSub, "interview_status", {:interview_start_error})
        {:noreply, socket}
    end
  end

  defp button_text(:not_started), do: "Begin Interview"
  defp button_text(:in_progress), do: "Interview in Progress..."
  defp button_text(:paused), do: "Interview Paused"
  defp button_text(:shortlisted), do: "Interview Finished"
  defp button_text(:rejected), do: "Interview Finished"
  defp button_text(:starting_error), do: "Error Starting Interview"
  defp button_text(:error), do: "Error during the interview"

  defp button_text(_), do: "Begin Interview" # fallback for any undefined status

  defp url_for(path) do
    endpoint_config = Application.get_env(:hedge_fund_interview, HedgeFundInterviewWeb.Endpoint)
    url = endpoint_config[:url]
    host = url[:host]
    port = url[:port]
    scheme = if Mix.env() == :prod, do: "https", else: "http"
    "#{scheme}://#{host}:#{port}#{path}"
  end
end
