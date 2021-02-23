defmodule Screechbot.Listener do
  use Nostrum.Consumer

  alias Nostrum.Voice
  alias Nostrum.Api
  alias Screechbot.State

  def start_link do
    Consumer.start_link(__MODULE__)
  end

  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
    if String.starts_with?(msg.content, "!stalk") do
      user_id = parse_user_id(msg.content)
      State.set(user_id)

      IO.puts "Setting victim as #{user_id}"
      Api.create_message(msg.channel_id, "Now Stalking <@!#{user_id}>")
    else
      :ignore
    end
  end

  def handle_event({:VOICE_STATE_UPDATE, msg, _ws_state}) do

    stalking_member_id = State.get()
    current_member_id = to_string(msg.member.user.id)

    if current_member_id == stalking_member_id do
      if msg.channel_id != nil do
        IO.puts("Joinning Channel")
        Voice.join_channel(msg.guild_id, msg.channel_id)

        timeout(fn ->
          IO.inspect Voice.play(msg.guild_id, "/Users/evan/workspace/screechbot/screech.mp3", :url)
        end, 1000)

      else
        IO.puts("Leaving Channel")
        Voice.leave_channel(msg.guild_id)
      end
    else
      :ignore
    end
  end

  # Default event handler, if you don't include this, your consumer WILL crash if
  # you don't have a method definition for each event type.
  def handle_event(_event) do
    :noop
  end

  def parse_user_id(str) do
    List.last(Regex.run(~r/<@!([^>]*)>/, str))
  end

  def timeout(func, delay) do
    pid = spawn fn ->
      receive do
        1 ->
          func.()
      end
    end
    Process.send_after(pid, 1, delay)
  end
end
