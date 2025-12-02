import aoc_2025/day_1.{DialState, Left, Right, calculate_passed_zero_count}
import gleam/list
import gleeunit

pub fn main() -> Nil {
  gleeunit.main()
}

// gleeunit test functions end in `_test`
pub fn hello_world_test() {
  let name = "Joe"
  let greeting = "Hello, " <> name <> "!"

  assert greeting == "Hello, Joe!"
}

pub fn calculate_passed_zero_count_test() {
  let test_data = [
    #(DialState(0, 0), Right(99), 0),
    #(DialState(0, 0), Right(101), 1),
    #(DialState(60, 0), Right(41), 1),
    #(DialState(60, 0), Left(41), 0),
    #(DialState(99, 0), Right(1), 0),
    #(DialState(0, 0), Left(2), 0),
    #(DialState(0, 0), Left(201), 2),
    #(DialState(60, 0), Right(141), 2),
    #(DialState(50, 0), Left(60), 1),
    #(DialState(1, 0), Left(2), 1),
    #(DialState(1, 0), Left(1), 0),
    #(DialState(50, 0), Left(50), 0),
    #(DialState(50, 0), Left(151), 2),
    #(DialState(50, 0), Right(50), 0),
    #(DialState(50, 0), Right(151), 2),
  ]
  use #(dial_state, rotation, expected) <- list.each(test_data)
  assert calculate_passed_zero_count(dial_state, rotation) == expected
}
