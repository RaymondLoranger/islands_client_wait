# ┌─────────────────────────────────────────────────────────────────┐
# │ Inspired by the course "Elixir for Programmers" by Dave Thomas. │
# └─────────────────────────────────────────────────────────────────┘
defmodule Islands.Client.Wait do
  use PersistConfig

  @course_ref Application.get_env(@app, :course_ref)

  @moduledoc """
  Waits for a game state in the _Game of Islands_.
  \n##### #{@course_ref}
  """

  alias IO.ANSI.Plus, as: ANSI
  alias Islands.Client.State
  alias Islands.Engine
  alias Islands.State, as: StateMachine

  @spec wait_for(State.t(), StateMachine.game_state(), String.t()) :: State.t()
  def wait_for(state, game_state, phrase) do
    ANSI.puts([
      :free_speech_red_background,
      :light_white,
      "#{state.player_name}, #{phrase}..."
    ])

    wait_for(game_state)
    put_in(state.tally, Engine.tally(state.game_name, state.player_id))
  end

  ## Private functions

  @spec wait_for(StateMachine.game_state()) :: :ok
  defp wait_for(:players_set) do
    receive do
      :players_set -> :ok
    end
  end

  defp wait_for(:player1_turn) do
    receive do
      :player1_turn -> :ok
      :game_over -> :ok
    end
  end

  defp wait_for(:player2_turn) do
    receive do
      :player2_turn -> :ok
      :game_over -> :ok
    end
  end
end
