import gleam/int
import gleam/list
import gleam/string

pub type Rotation {
  Left(Int)
  Right(Int)
}

pub type DialState {
  DialState(position: Int, zero_count: Int)
}

fn rotate(dial_state: DialState, rotation: Rotation) -> DialState {
  case rotation {
    Left(count) ->
      DialState({ dial_state.position - count } % 100, dial_state.zero_count)
    Right(count) ->
      DialState({ dial_state.position + count } % 100, dial_state.zero_count)
  }
}

fn increment_zero_count(dial_state: DialState) -> DialState {
  DialState(dial_state.position, dial_state.zero_count + 1)
}

fn parse_line(input: String) -> Rotation {
  let assert Ok(count) = string.drop_start(from: input, up_to: 1) |> int.parse
  let assert Ok(direction) = string.first(input)
  case direction {
    "L" -> Left(count)
    "R" -> Right(count)
    _ -> panic as "Input is not following input spec"
  }
}

pub fn parse(input: String) -> List(Rotation) {
  input |> string.split(on: "\n") |> list.map(parse_line)
}

fn calculate_rotation(rotation: Rotation, dial_state: DialState) -> DialState {
  let rotated_dial_state = dial_state |> rotate(rotation)
  case rotated_dial_state {
    DialState(0, _) -> rotated_dial_state |> increment_zero_count
    _ -> rotated_dial_state
  }
}

fn calculate_rotations(
  dial_state: DialState,
  rotations: List(Rotation),
) -> DialState {
  case rotations {
    [] -> dial_state
    [first, ..rest] ->
      first |> calculate_rotation(dial_state) |> calculate_rotations(rest)
  }
}

pub fn pt_1(input: List(Rotation)) {
  calculate_rotations(DialState(position: 50, zero_count: 0), input).zero_count
}

pub fn pt_2(input: List(Rotation)) -> Int {
  todo as "part 2 not implemented"
}
