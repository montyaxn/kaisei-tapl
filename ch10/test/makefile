test : test.ml test1.txt test2.txt test3.txt test4.txt test5.txt test6.txt test7.txt
	-mkdir _build
	cp test.ml test1.txt test2.txt test3.txt test4.txt test5.txt test6.txt test7.txt _build
	cd _build && ocamlc -o test test.ml
	cd _build && ./test

clean :
	rm -rf _build