#include <stdint.h>
#include <stdio.h>
#include <stdarg.h>
#include <stdlib.h>
#include <string.h>
#include <zlib.h>

int main(int argc, char *argv[])
{
	int a;
 	FILE* real_stdout = stdout;
	FILE* fake_stdout = fopen("/dev/null", "w");
	stdout = fake_stdout;