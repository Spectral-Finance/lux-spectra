defmodule HedgeFundInterviewWeb.InterviewButtonComponent do
  use HedgeFundInterviewWeb, :live_component
  alias Lux.Beam.Runner
  alias HedgeFundInterview.Beams.BeginInterview

  @topic "interview_status"

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
    with {:ok, beam_result, _beam_acc} <- Runner.run(BeginInterview.beam(), %{}),
         %Req.Response{status: 200} <- beam_result do
        Phoenix.PubSub.broadcast(HedgeFundInterview.PubSub, @topic, {:interview_started})
      {:noreply, socket}
    else
      _ ->
        Phoenix.PubSub.broadcast(HedgeFundInterview.PubSub, @topic, {:interview_start_error})
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
end
