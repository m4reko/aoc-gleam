import gleam/int
import gleam/list
import gleam/string

pub type IDRange {
  IDRange(beginning: Int, end: Int)
}

fn parse_int_unsafe(s: String) -> Int {
  let assert Ok(i) = int.parse(s)
  i
}

pub fn parse(input: String) -> List(IDRange) {
  input
  |> string.split(",")
  |> list.map(fn(s) {
    let assert Ok(pair) = string.split_once(s, "-")
    IDRange(parse_int_unsafe(pair.0), parse_int_unsafe(pair.1))
  })
}

pub fn is_invalid_id(id: Int) -> Bool {
  let id_string = id |> int.to_string
  let id_len = id_string |> string.length
  id_len |> int.is_even
  && string.slice(id_string, 0, id_len / 2)
  == string.slice(id_string, id_len / 2, id_len / 2)
}

pub fn find_invalid_ids(range: IDRange) -> List(Int) {
  list.range(range.beginning, range.end) |> list.filter(is_invalid_id)
}

pub fn pt_1(input: List(IDRange)) {
  input |> list.flat_map(find_invalid_ids) |> int.sum
}

pub fn pt_2(input: List(IDRange)) {
  todo as "part 2 not implemented"
}
