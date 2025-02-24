defmodule HedgeFundInterviewWeb.InterviewBannerComponent do
  use HedgeFundInterviewWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div class={"status-banner #{banner_class(@interview_status)}"}>
      <div class="banner-content">
        <span class="banner-icon">
          <%= banner_icon(@interview_status) %>
        </span>
        <span class="banner-message">
          <%= banner_message(@interview_status) %>
        </span>
      </div>
    </div>
    """
  end

  defp banner_class(:not_started), do: "hidden"
  defp banner_class(:in_progress), do: "info"
  defp banner_class(:paused), do: "info"
  defp banner_class(:shortlisted), do: "success"
  defp banner_class(:rejected), do: "rejected"
  defp banner_class(:starting_error), do: "error"
  defp banner_class(:error), do: "error"
  defp banner_class(_), do: "hidden"

  defp banner_icon(:not_started), do: ""
  defp banner_icon(:in_progress), do: ""
  defp banner_icon(:shortlisted), do: "🌟 ✨ 🎉"
  defp banner_icon(:rejected), do: ""
  defp banner_icon(:starting_error), do: "⚠️"
  defp banner_icon(:error), do: "⚠️"
  defp banner_icon(:paused), do: "⏸️"
  defp banner_icon(_), do: ""

  defp banner_message(:not_started), do: ""
  defp banner_message(:in_progress), do: "Interview in progress... You can return to Syntax to watch it live!"
  defp banner_message(:shortlisted), do: "Amazing news! You've been shortlisted! We will contact you if we decide to move forward with your application."
  defp banner_message(:rejected), do: "Unfortunately, you've been rejected, but don't get discouraged, you can improve your agent and apply again."
  defp banner_message(:starting_error), do: "There was an error starting the interview. Please make sure your config is set up correctly and try again."
  defp banner_message(:error), do: "An error occurred during the interview. Please try again."
  defp banner_message(:paused), do: "You're out of messages. Please go to the syntax UI and buy more, once you do that your agent will automatically resume your interview."
  defp banner_message(_), do: ""
end
