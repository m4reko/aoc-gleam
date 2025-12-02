import gleam/int
import gleam/list
import gleam/string

const dial_size = 100

pub type Rotation {
  Left(Int)
  Right(Int)
}

pub type DialState {
  DialState(position: Int, zero_count: Int)
}

type PasswordMethod {
  One
  Two
}

fn rotate(dial_state: DialState, rotation: Rotation) -> DialState {
  case rotation {
    Left(count) -> {
      let assert Ok(new_position) =
        { dial_state.position - count } |> int.modulo(dial_size)
      DialState(new_position, dial_state.zero_count)
    }
    Right(count) -> {
      let assert Ok(new_position) =
        { dial_state.position + count } |> int.modulo(dial_size)
      DialState(new_position, dial_state.zero_count)
    }
  }
}

fn increment_zero_count(dial_state: DialState, by number: Int) -> DialState {
  DialState(dial_state.position, dial_state.zero_count + number)
}

/// Calculates how many times the dial passes zero during a rotation.
/// 
pub fn calculate_passed_zero_count(
  dial_state: DialState,
  rotation: Rotation,
) -> Int {
  case rotation {
    Left(count) -> {
      let inverted_dial_position = case dial_state.position {
        0 -> 0
        _ -> dial_size - dial_state.position
      }
      let assert Ok(passed_zero_count) =
        int.divide(inverted_dial_position + count - 1, dial_size)
      passed_zero_count
    }
    Right(count) -> {
      let assert Ok(passed_zero_count) =
        int.divide(dial_state.position + count - 1, dial_size)
      passed_zero_count
    }
  }
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

fn calculate_rotation(
  rotation: Rotation,
  dial_state: DialState,
  method: PasswordMethod,
) -> DialState {
  let rotated_dial_state = dial_state |> rotate(rotation)
  let incremented_dial_state = case rotated_dial_state {
    DialState(0, _) -> rotated_dial_state |> increment_zero_count(by: 1)
    _ -> rotated_dial_state
  }
  case method {
    One -> incremented_dial_state
    Two -> {
      incremented_dial_state
      |> increment_zero_count(calculate_passed_zero_count(dial_state, rotation))
    }
  }
}

fn calculate_rotations(
  dial_state: DialState,
  rotations: List(Rotation),
  method: PasswordMethod,
) -> DialState {
  case rotations {
    [] -> dial_state
    [first, ..rest] ->
      first
      |> calculate_rotation(dial_state, method)
      |> calculate_rotations(rest, method)
  }
}

pub fn pt_1(input: List(Rotation)) {
  calculate_rotations(DialState(position: 50, zero_count: 0), input, One).zero_count
}

pub fn pt_2(input: List(Rotation)) -> Int {
  calculate_rotations(DialState(position: 50, zero_count: 0), input, Two).zero_count
}
