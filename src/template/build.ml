open Printf
open Nethtml
module Path = Weberizer.Path

let tpl = Diffiety.empty
(* To avoid symlinks for the images but still share them accross the
various translations of the website, one need to change the paths
of the images of translated sites. *)

let rec drop_last = function
  | [] | [_] -> []
  | a :: tl -> a :: drop_last tl

let dir_from_base p =
  let path = Path.from_base_split p in
  if Path.filename p = "" then path else drop_last path

(* [img_dir]: path to images from the location [p] points to. *)
let modify_img_path ~img_dir p ((src, url) as arg) =
  let url = Neturl.split_path url in
  let path = Neturl.norm_path(dir_from_base p @ url) in
  match path with
  | "img" :: sub_path ->
     let url' = img_dir ^ Neturl.join_path sub_path in
     (src, url')
  | _ -> arg

let rec img_path_translations ~img_dir p html =
  List.map (modify_img_path_element ~img_dir p) html

and modify_img_path_element ~img_dir p = function
  | Nethtml.Element("img", args, content) ->
     let src, args = List.partition (fun (a,_) -> a = "src") args in
     let src = List.map (modify_img_path ~img_dir p) src in
     Nethtml.Element("img", src @ args, content)
  | Nethtml.Element(e, args, content) ->
     Nethtml.Element(e, args, img_path_translations ~img_dir p content)
  | Nethtml.Data _ as e -> e

let stop_on_error = ref false
let spec = [
  ("--stop-on-error", Arg.Set stop_on_error,
   " stop the build if an error is encountered");
]

let () =
  Arg.parse (Arg.align spec) (fun _ -> raise(Arg.Bad "no anonymous arguments"))
            "build <options>";
  let b = Weberizer.Binding.make() in
(*  Weberizer.Binding.fun_html b "rss" Render_rss.of_urls;
  Weberizer.Binding.fun_html b "news" Render_rss.news;
  Weberizer.Binding.fun_html b "opml" Render_rss.OPML.of_urls;
  Weberizer.Binding.fun_html b "toc" Toc.make;*)
  if !stop_on_error then
    Weberizer.Binding.on_error b (fun v a e -> raise e);

 (* let re_filter = Str.regexp "\\(menu\\|OCAML\\).*" in
  let filter p = not(Str.string_match re_filter (Path.filename p) 0) in

  let langs = ["en"; "fr"; "de"; "es"; "it"; "ja"] in
  let out_dir lang =
    if lang = "en" then "www" else Filename.concat "www" lang in
  let rel_dir l1 l2 =
    (* Path to go from the base directory for language [l1] to the one
for [l2]. *)
    if l1 = "en" then l2
    else if l2 = "en" then ".."
    else "../" ^ l2 in*)
  let langs = ["en"] in
  let out_dir lang = "www-"^lang in
  let filter _ = true in
  let process_html lang p =
    eprintf "Processing %s\n%!" (Path.full p);
    (*let tpl = Diffiety.lang tpl lang in
    let tpl = Diffiety.url_base tpl (Weberizer.Path.to_base p) in*)
    let url_base = if Path.in_base p then "" else Path.to_base p in
    Weberizer.Binding.string b "url_base" url_base;
   (* let top = Code.toplevel () in
    let path_from_base =
      Filename.concat "src/html/" (Weberizer.Path.from_base p) in
    Weberizer.Binding.fun_html b "ocaml" (Code.ocaml top path_from_base);*)
    let page = Weberizer.read (Path.full p) ~bindings:b in
    let tpl = Diffiety.title tpl (Weberizer.title_of page) in
    let prefix = if lang = "en" then "" else "../" in
    let img_dir = url_base ^ prefix ^ "img/" in
    (*let tpl = Ocamlorg.img_dir tpl img_dir in
    let tpl = Ocamlorg.css_dir tpl (url_base ^ prefix ^ "css/") in
    let tpl = Ocamlorg.javascript_dir tpl (url_base ^ prefix ^ "js/") in*)
    let body = Weberizer.body_of page in
    let body = Weberizer.protect_emails body in
    let body = img_path_translations p body ~img_dir in
    let tpl = Diffiety.main tpl body in
    (*
    let tpl = add_menu tpl lang p in

    let tpl = Ocamlorg.navigation_of_path tpl p in
    let tpl = Ocamlorg.languages tpl (Path.translations p ~langs ~rel_dir) in
    Code.close_toplevel top;*)
    Diffiety.render tpl
  in
  Weberizer.iter_html ~filter ~langs "src/html" ~out_dir process_html
                      ~perm:0o755
