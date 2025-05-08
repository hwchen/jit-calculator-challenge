module calc::jit;
import std::io;
import std::core::mem;

// JIT code from:
// https://eli.thegreenplace.net/2013/11/05/how-to-jit-an-introduction

fn void run() {
	void* m = alloc_executable_memory(SIZE)!!;
	emit_code_into_memory(m);
	JittedFunc func = m;
	long result = func(2);
	io::printfn("result: %d", func(2));
}

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

fn void emit_code_into_memory(char* m) {
  char[] code = {
    0x48, 0x89, 0xf8,                   // mov %rdi, %rax
    0x48, 0x83, 0xc0, 0x04,             // add $4, %rax
    0xc3                                // ret
  };
  mem::copy(m, code, code.len);
}

const usz SIZE = 1024;
alias JittedFunc = fn long(long);


// mmap helpers

faultdef ALLOC_BYTECODE_ERROR;

extern fn void* mmap(void* address, usz length, int protect, int flags, int filedes, usz offset);

const usz PROT_READ     = 0x1;
const usz PROT_WRITE    = 0x2;
const usz PROT_EXEC     = 0x4;
const usz MAP_PRIVATE   = 0x02;
const usz MAP_ANONYMOUS = 0x20;
