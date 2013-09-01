let () =
  let basedir = Sys.argv.(1) in
  let dirs = Sys.readdir basedir in
  Array.iter (fun _dir ->
    let dir = basedir ^ "/" ^ _dir in
    let files = Sys.readdir dir in
    let index = dir ^ "/" ^ "index.html" in
    let oc = open_out index in
    Printf.fprintf oc "<html><head><title>%s</title></head><body>\n" _dir;
    Array.iter (fun file ->
      Printf.fprintf oc "<a href='%s'>%s</a><br/>\n" file file
    ) files;
    Printf.fprintf oc "</body></html>\n";
    close_out oc;
  ) dirs
