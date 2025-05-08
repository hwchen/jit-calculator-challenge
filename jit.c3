module calc::jit;
import std::collections;
import std::core::mem;
import std::io;

// JIT code from:
// https://eli.thegreenplace.net/2013/11/05/how-to-jit-an-introduction
// https://github.com/mattnappo/jitcalc/blob/main/src/soln2.rs

fn char[] compile(Allocator alloc, String program) {
	@pool() {
		List{char} out;
		// this will tak the init value from fn arg
		out.add_array({0x48, 0x89, 0xf8});// mov %rdi, %rax
		foreach (c : program) {
			switch (c) {
			// These work on example from https://github.com/mattnappo/jitcalc/blob/main/src/soln2.rs
			// but give err here. Otherwise should use inc/sub
			//case '+': out.add_array({0x48, 0xff, 0xc0});// inc %rax
			//case '-': out.add_array({0x48, 0xff, 0xe8});// sub %rax
			case '+': out.add_array({0x48, 0x83, 0xc0, 0x01});// add $1, %rax
			case '-': out.add_array({0x48, 0x83, 0xe8, 0x01});// sub $1, %rax
			// just use shift here, although imul and idiv would be more accurate, just need to
			// read docs or get examples
			case '*': out.add_array({0x48, 0xd1, 0xe0});// sal $1, %rax
			case '/': out.add_array({0x48, 0xd1, 0xf8});// sar $1, %rax
			}
		}
		out.push(0xc3);// ret
		return out.to_array(alloc);
	};
}

fn isz run(char[] code) {
	void* m = alloc_executable_memory(code.len)!!;
	mem::copy(m, code, code.len);
	JittedFunc func = m;
	return func(0);
}

alias JittedFunc = fn isz(isz);
faultdef ALLOC_BYTECODE_ERROR;

fn void*? alloc_executable_memory(usz size) {
	void* ptr = mmap((void*)0, size,
		PROT_READ | PROT_WRITE | PROT_EXEC,
		MAP_PRIVATE | MAP_ANONYMOUS,
		-1, 0
	);
	if ((iptr)ptr < 0) {
		return ALLOC_BYTECODE_ERROR?;
	}
	return ptr;
}

// mmap helpers
// from sys/mann.h

extern fn void* mmap(void* address, usz length, int protect, int flags, int filedes, usz offset);

const usz PROT_READ     = 0x1;
const usz PROT_WRITE    = 0x2;
const usz PROT_EXEC     = 0x4;
const usz MAP_PRIVATE   = 0x02;
const usz MAP_ANONYMOUS = 0x20;
