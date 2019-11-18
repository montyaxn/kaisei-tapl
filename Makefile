ch4: ch4.ml ch4_lex.mll ch4_parse.mly tapl_base.ml
	-mkdir ch4_build
	cp tapl_base.ml ch4_sub.ml ch4_lex.mll ch4_parse.mly ch4.ml ch4_build
	cd ch4_build && ocamllex ch4_lex.mll
	cd ch4_build && ocamlyacc ch4_parse.mly
	cd ch4_build && ocamlc -o ch4 tapl_base.ml ch4_sub.ml ch4_parse.mli ch4_parse.ml ch4_lex.ml ch4.ml
	cp ch4_build/ch4 ./

ch4_test : ch4
	./ch4 ch4_test/test1.txt


ch7: ch7.ml tapl_base.ml ch7_sub.ml ch7_lex.mll ch7_parse.mly
	-mkdir ch7_build
	cp tapl_base.ml ch7.ml ch7_sub.ml ch7_lex.mll ch7_parse.mly ch7_build
	cd ch7_build && ocamllex ch7_lex.mll
	cd ch7_build && ocamlyacc ch7_parse.mly
	cd ch7_build && ocamlc -o ch7 tapl_base.ml ch7_sub.ml ch7_parse.mli ch7_parse.ml ch7_lex.ml ch7.ml
	cp ch7_build/ch7 ./


.PHONY: clean

clean:
	@rm -rf *.cmi *.cmx *.cmo *.o ch4 *.out ch4_lex.ml ch4_parse.ml ch4_parse.mli ch4_build ch7 ch7_build
