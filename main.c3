module calc;
import std::io;

fn void main() {
	// A simple integer calculator:
	// `+` or `-` means add or subtract by 1
	// `*` or `/` means multiply or divide by 2
	String program = "+ + * - /";
	uint accumulator;

	foreach (c : program) {
		switch (c) {
		case '+': accumulator += 1;
		case '-': accumulator -= 1;
		case '*': accumulator *= 2;
		case '/': accumulator /= 2;
		}
	}
	io::printfn("The program \"%s\" calculates the value %d", program, accumulator);
}
