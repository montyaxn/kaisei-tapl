open Tapl_base

open Ch4_sub
open Ch4_parse
open Ch4_lex

type rule =
  | E_IfTrue
  | E_IfFalse
  | E_If
  | E_Succ
  | E_PredSucc
  | E_PredZero
  | E_Pred
  | E_IsZeroZero
  | E_IsZeroSucc
  | E_IsZero
  | Initial


exception NoRuleApplies


let rec isnumericval t =
  match t with
  | TmZero -> true
  | TmSucc(t1) -> isnumericval t1
  | _ -> false


let rec isval t =
  match t with
  | TmTrue -> true
  | TmFalse -> true
  | t when isnumericval t -> true (*数値であればtrue*)
  | _ -> false 


let rec eval1 t =
  match t with
  | TmIf (TmTrue, t2, _) -> (t2, E_IfTrue)
  | TmIf (TmFalse, _, t3) -> (t3, E_IfFalse)
  | TmIf (t1, t2, t3) -> 
    let (t1',_) = eval1 t1 in
    (TmIf(t1', t2, t3), E_If)
  | TmSucc (t1) ->
    let (t1',_) = eval1 t1 in
    (TmSucc(t1'), E_Succ)
  | TmPred(TmZero) -> (TmZero, E_PredZero)
  | TmPred(TmSucc(nv1)) when (isnumericval nv1) -> (nv1, E_PredSucc)
  | TmPred(t1) ->
    let (t1',_) = eval1 t1 in
    (TmPred(t1'), E_Pred)
  | TmIsZero(TmZero) -> (TmTrue, E_IsZeroZero)
  | TmIsZero(TmSucc(nv1)) when (isnumericval nv1) -> (TmFalse, E_IsZeroSucc)
  | TmIsZero(t1) ->
    let (t1',_) = eval1 t1 in
    (TmIsZero(t1'), E_IsZero)
  | _ -> raise NoRuleApplies


let rec eval t =
  let tr'opt =
    try let (t', r') = eval1 t in Some(t', r')
    with NoRuleApplies -> None
  in
  match tr'opt with
  | Some(t', r') -> eval t'
  | None -> t


let rec term_to_string t = match t with
  | TmTrue -> "TmTrue"
  | TmFalse -> "TmFalse"
  | TmIf(t1, t2, t3) -> "TmIf(" ^ term_to_string t1 ^ ", " ^ term_to_string t2 ^ ", " ^ term_to_string t3 ^ ")"
  | TmZero -> "TmZero"
  | TmSucc(t1) -> "TmSucc(" ^ term_to_string t1 ^ ")"
  | TmPred(t1) -> "TmPred(" ^ term_to_string t1 ^ ")"
  | TmIsZero(t1) -> "TmIsZero(" ^ term_to_string t1 ^ ")"

let rule_to_string r = match r with
  | E_IfTrue -> "E_IfTrue"
  | E_IfFalse -> "E_IfFalse"
  | E_If -> "E_If"
  | E_Succ -> "E_Succ"
  | E_PredSucc -> "E_PredSucc"
  | E_PredZero -> "E_PredZero"
  | E_Pred -> "E_Pred"
  | E_IsZeroZero -> "E_IsZeroZero"
  | E_IsZeroSucc -> "E_IsZeroSucc"
  | E_IsZero -> "E_IsZero"
  | Initial -> "Initial"

let rec show tr =
  let (t,r) = tr in
  Printf.printf "%s by %s\n" (term_to_string t) (rule_to_string r)


let rec show_step_by_step tr =
  let (t, r) = tr in
  let tr'opt =
    try let (t', r') = eval1 t in Some(t', r')
    with NoRuleApplies -> None
  in
  match tr'opt with
  | Some(t', r') -> let _ = show tr in show_step_by_step (t', r')
  | None -> show tr


let make_t file_name =
  let channel = open_in file_name in
  channel |> Lexing.from_channel |> parse lex


let main t =
  (t, Initial) |> show_step_by_step;
  print_newline()


let _ =
  let input = Array.to_list Sys.argv in
  match input with
  | [_; input_file] ->
    begin
      try make_t input_file |> main with
        err -> Printf.printf "%s\n" (make_error (NoSuchFile(input_file)))
    end
  | _ -> Printf.printf "%s\n" (make_error WrongNumberOfArguments)
