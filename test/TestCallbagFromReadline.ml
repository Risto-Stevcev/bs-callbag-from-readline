open BsMocha

let describe, it = Mocha.describe, Promise.it

external to_promise: 'a Callbag.t -> 'a Js.Promise.t = "callbag-to-promise" [@@bs.module];;


describe "CallbagFromReadline" (fun () -> begin
  it "should create a callbag from a readline interface" (fun () -> begin
    let input = Node_Stream.Duplex.pass_through ()
    in
    let _ =
      Node_Stream.Writable.write input "foo\nbar";
      Node_Stream.Writable.write input "norf\nbaz\n";
      Node_Stream.Writable.write input "worble\n";
      Node_Stream.Writable.end_ input ()
    in
    CallbagFromReadline.from_readline ~input ()
    |> CallbagBasics.scan (fun acc e -> Js.Array.concat [|e|] acc) [||]
    |> to_promise
    |> Js.Promise.then_ (fun result -> begin
       Assert.deep_equal result [|"foo"; "barnorf"; "baz"; "worble"|]
       |> Js.Promise.resolve
    end)
  end)
end)
