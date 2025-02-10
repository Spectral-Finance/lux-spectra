defmodule HedgeFundInterviewWeb.SignalControllerTest do
  use HedgeFundInterviewWeb.ConnCase

  describe "process_signal/2" do
    test "returns 200 OK when valid signal is received", %{conn: conn} do
      signal_params = %{
        id: "msg_123",
        payload: %{
          message: "Test message",
          job_opening_id: "job_456"
        },
        sender: "test@example.com",
        recipient: "recipient@example.com",
        timestamp: "2024-03-19T10:30:00Z",
        metadata: %{
          source: "test"
        },
        schema_id: "interview_message_v1"
      }

      conn = post(conn, ~p"/api/signals", signal_params)
      assert json_response(conn, 200)["status"] == "success"
    end

    test "returns 400 Bad Request when invalid signal is received", %{conn: conn} do
      conn = post(conn, ~p"/api/signals", %{})
      assert json_response(conn, 400)["error"] == "Invalid signal parameters"
    end
  end
end
