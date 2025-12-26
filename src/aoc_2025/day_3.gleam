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

fn find_max_joltage(bank: BatteryBank, bank_size: Int) -> Int {
  let assert Ok(#(position, first_digit)) =
    find_first_max(bank |> list.take(bank_size - 1))
  let assert Ok(#(_, second_digit)) =
    find_first_max(bank |> list.drop(position + 1))
  first_digit * 10 + second_digit
}

pub fn pt_1(input: List(BatteryBank)) -> Int {
  let assert Ok(first_bank) = list.first(input)
  let bank_size = first_bank |> list.length
  input |> list.map(find_max_joltage(_, bank_size)) |> int.sum
}

pub fn pt_2(input: List(BatteryBank)) {
  todo as "part 2 not implemented"
}
