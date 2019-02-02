#include <stdlib.h>

static int warning()
{
}

static void allocate(void)
{
	char *buf;

	buf = malloc(10000);

	free(buf);
}

int main(void)
{
	allocate();

	return 0;
}
