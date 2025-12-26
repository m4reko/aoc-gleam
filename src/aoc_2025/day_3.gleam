import gleam/bool
import gleam/int
import gleam/list
import gleam/option.{None, Some}
import gleam/string

type Battery =
  Int

type BatteryBank =
  List(Battery)

fn parse_battery_bank(row: String) -> BatteryBank {
  let assert Ok(battery_bank) =
    row |> string.to_graphemes |> list.try_map(int.parse)
  battery_bank
}

pub fn parse(input: String) -> List(BatteryBank) {
  input |> string.split("\n") |> list.map(parse_battery_bank)
}

type Position =
  Int

type Value =
  Int

fn find_first_max(ints: List(Int)) -> Result(#(Position, Value), String) {
  list.index_fold(over: ints, from: None, with: fn(acc, item, index) {
    case acc {
      None -> Some(#(index, item))
      Some(#(_, value)) ->
        case value < item {
          False -> acc
          True -> Some(#(index, item))
        }
    }
  })
  |> option.to_result("List was empty")
}

fn find_max_joltage(
  bank: BatteryBank,
  batteries_turned_on_count: Int,
  sum: Int,
) -> Int {
  use <- bool.guard(when: batteries_turned_on_count == 0, return: sum)
  let bank_size = bank |> list.length
  let assert Ok(#(position, digit)) =
    find_first_max(bank |> list.take(bank_size - batteries_turned_on_count + 1))
  find_max_joltage(
    list.drop(from: bank, up_to: position + 1),
    batteries_turned_on_count - 1,
    sum * 10 + digit,
  )
}

pub fn pt_1(input: List(BatteryBank)) -> Int {
  input |> list.map(find_max_joltage(_, 2, 0)) |> int.sum
}

pub fn pt_2(input: List(BatteryBank)) {
  input |> list.map(find_max_joltage(_, 12, 0)) |> int.sum
}
