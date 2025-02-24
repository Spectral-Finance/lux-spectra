defmodule HedgeFundInterview.InterviewMemory do
  @moduledoc """
  Manages an ETS table for storing interview messages in memory.
  """
  @table_name :interview_messages

  def start_link do
    :ets.new(@table_name, [:named_table, :public, :ordered_set])
    :ok
  end

  def store_message(sender, message) do
    timestamp = :os.system_time(:millisecond)
    :ets.insert(@table_name, {timestamp, %{sender: sender, message: message}})
    :ok
  end

  def store_messages(messages) when is_list(messages) do
    timestamp = :os.system_time(:millisecond)
    entries =
      messages
      |> Enum.with_index(fn msg, index ->
        # Add microsecond offsets to ensure unique timestamps
        # Using this offset so system time does not clash with the UTC timestamp
        # when inserting new messages afterwards
        {timestamp + index, msg}
      end)

    :ets.insert(@table_name, entries)
    :ok
  end

  def get_last_message do
    case :ets.last(@table_name) do
      :"$end_of_table" -> nil
      key ->
        [{_timestamp, message}] = :ets.lookup(@table_name, key)
        message
    end
  end

  def get_all_messages do
    :ets.tab2list(@table_name)
    |> Enum.sort_by(&elem(&1, 0))
    |> Enum.map(&elem(&1, 1))
  end
end
