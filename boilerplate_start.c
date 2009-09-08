
int main(int argc, char *argv[])
{
	int a;
 	FILE* real_stdout = stdout;
	FILE* fake_stdout = fopen("/dev/null", "w");
	stdout = fake_stdout;