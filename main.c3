module calc;
import std::io;
import libc;
import calc::jit;

fn void main() {
	// A simple integer calculator:
	// `+` or `-` means add or subtract by 1
	// `*` or `/` means multiply or divide by 2
	String program = "+ + * - /";
	char[] code = jit::compile(tmem, program);
	isz result = jit::run(code);

	io::printfn("The program \"%s\" calculates the value %d", program, result);
}
