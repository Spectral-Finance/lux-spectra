defmodule HedgeFundInterviewWeb.HomeLive do
  use HedgeFundInterviewWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Phoenix.PubSub.subscribe(HedgeFundInterview.PubSub, "interview_status")
    end

    prompt = case File.read("prompt.txt") do
      {:ok, content} -> content
      {:error, _} -> "Error reading prompt file. Please ensure prompt.txt exists in the root directory."
    end

    {:ok, assign(socket, prompt: prompt, interview_status: :not_started)}
  end

  @impl true
  def handle_info({:interview_started}, socket) do
    {:noreply, assign(socket, :interview_status, :in_progress)}
  end

  def handle_info({:interview_paused}, socket) do
    {:noreply, assign(socket, :interview_status, :paused)}
  end

  def handle_info({:interview_shortlisted}, socket) do
    {:noreply, assign(socket, :interview_status, :shortlisted)}
  end

  def handle_info({:interview_rejected}, socket) do
    {:noreply, assign(socket, :interview_status, :rejected)}
  end

  def handle_info({:interview_error}, socket) do
    {:noreply, assign(socket, :interview_status, :error)}
  end

  def handle_info({:interview_start_error}, socket) do
    {:noreply, assign(socket, :interview_status, :starting_error)}
  end
end
