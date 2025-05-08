module calc;
import std::io;
import libc;
import calc::jit;

fn void main() {
	// A simple integer calculator:
	// `+` or `-` means add or subtract by 1
	// `*` or `/` means multiply or divide by 2
	//String program = "+ + * - /";
	//char[] machine_code = jit::compile(program);
	//isz result = jit::run(machine_code);
	jit::run();

	//io::printfn("The program \"%s\" calculates the value %d", program, result);
}
