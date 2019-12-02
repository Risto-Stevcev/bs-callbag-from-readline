module Internal = struct
  module Options = struct
    type t

    external make:
      input:[> Node_Stream.readable] Node_Stream.t ->
      ?output:[> Node_Stream.writable] Node_Stream.t ->
      unit ->
      t = "" [@@bs.obj]
  end

  external generalize:
    Node_Stream.readable Node_Stream.t -> [> Node_Stream.readable] Node_Stream.t = "%identity"

  external from_readline: Options.t -> string Callbag.t = "callbag-from-readline" [@@bs.module]
end

let from_readline
  ?(input = Internal.generalize Node_Stream.stdin)
  ?(output: [> Node_Stream.writable] Node_Stream.t option)
  () =
  Internal.from_readline @@ Internal.Options.make ~input ?output ()
