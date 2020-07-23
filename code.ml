let explode s =
  let rec exp i l =
  match i with
   _ when i < 0 -> l
  | _ -> exp (i-1) (s.[i]::l)
        in exp (String.length s - 1) []

(* Concat/Format List *)
let rec format_string_list str_list acc = 
  match str_list with
  | [] -> acc
  | h::t -> if h = ' ' || h = '-' || h = '>' then format_string_list t acc
            else
            format_string_list t (h::acc)

let rec format_list lst acc =
  match lst with
  | [] -> acc
  | h::t -> let string_to_list = explode h in
            let head_of_list = List.hd string_to_list in
            let rest_of_list = format_string_list (List.tl string_to_list) [] in            
            let rev_rest_of_list = List.rev rest_of_list in
            format_list t ([head_of_list,rev_rest_of_list]@acc)


(* ---------------------------------- Read Functions ----------------------------------------*)

let n_productions = Scanf.sscanf  (read_line()) "%d" (fun x -> x)

let production_list n =
  List.init n_productions (fun x -> read_line())

let lst = (production_list n_productions)
let lista = format_list lst []
let lst_final = List.rev lista
let lst_nterminals = List.rev (List.fold_left (fun acc (x,_) -> if List.mem x acc then acc else (x::acc) ) [] lst_final)

(* ---------------------------------- Calcular NULL ----------------------------------------*)
 
let rec calc_null e =  
  match e with
    | '_' -> true 
    | _ -> 
  let rec aux e acc lst =
   match lst with 
  | [] -> acc
  | (h,rhs)::tl -> 
      if h = e then 
        let tmp = List.for_all (fun x -> match x with 
                                | '_' -> true 
                                | 'A' .. 'Z' as c -> if c <> e then calc_null c else false
                                | _ -> false)          
            rhs in aux e (tmp || acc) tl
    else aux e acc tl  
  in aux e false lst_final 

let print_null e =
  let res = if calc_null e then "True" else "False" in
  Printf.printf "NULL(%c) = %s\n" e res 

let () = List.iter print_null lst_nterminals 

(* ---------------------------------- Calcular First ----------------------------------------*)

let rec list_merge lst1 lst2 = 
  List.fold_left (fun acc x -> if List.mem x acc then acc else x::acc) lst1 lst2

let rec calc_first w = 
  match w with
  | [] -> []
  | c :: t ->
      match c with
        | 'a' .. 'z' -> [c]
        | 'A' .. 'Z' -> 
            let aux x =
              let l = List.filter (fun (lhs, _) -> x = lhs) lst_final in
              List.fold_left (fun acc (x, rhs) -> let tmp = List.filter (fun y -> x <> y) rhs in  list_merge acc (calc_first tmp)) [] l in
            if calc_null c then list_merge (calc_first t) (aux c) else aux c
        | _ -> []

let print_first e =
  Printf.printf "FIRST(%c) =" e;
  List.iter (Printf.printf " %c") (List.sort compare (calc_first [e]));
  Printf.printf "\n"

let () = List.iter print_first lst_nterminals 

(* ---------------------------------- Calcular Follow ----------------------------------------*)
let follow_table = Hashtbl.create (List.length lst_nterminals)

let () = List.iter (fun x -> if x = 'S' then Hashtbl.add follow_table x ['#'] else Hashtbl.add follow_table x []) lst_nterminals

let calc_follow e =  
  let lst = List.filter (fun (_, rhs) -> List.exists (fun x -> x = e) rhs) lst_final in
  let rec aux acc lst =
    match lst with 
      | [] -> let acc = if e = 'S' then '#' :: acc else acc in List.sort_uniq compare acc
      | (h,rhs)::tl ->
          let rec find_beta l' =
            match l' with
              | [] -> assert false
              | hd::tl -> if hd = e then tl else find_beta tl in
          let beta = find_beta rhs in 
          let beta = if List.length beta = 0 then ['_'] else beta in
          let b = calc_first beta in    
          let acc = list_merge acc b in         
          let res = if List.for_all calc_null beta then 
            list_merge acc (Hashtbl.find follow_table h)
          else acc in
          aux (list_merge acc res) tl in
  let res = aux [] lst in
  Hashtbl.replace follow_table e res
          
let rec follows () =
  let follow_table' = Hashtbl.copy follow_table in
  let () = List.iter calc_follow lst_nterminals in
  if Hashtbl.fold (fun x f acc -> 
      let f' = Hashtbl.find follow_table' x in 
      acc && List.length f = List.length f' && List.for_all2 (fun a b -> a = b) f f') follow_table true then ()
  else follows ()

   
let () =
  let () = follows () in
  let l = Hashtbl.fold (fun x f acc -> (x, f) :: acc) follow_table [] in
  let l = List.sort (fun (x, _) (y, _) -> if x = 'S' then -1 else if y = 'S' then 1 else compare x y) l in
  List.iter (fun (x, f) -> Printf.printf "FOLLOW(%c) =" x;
  List.iter (Printf.printf " %c") f;
  Printf.printf "\n") l
            
            
