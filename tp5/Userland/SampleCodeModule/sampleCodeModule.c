/* sampleCodeModule.c */

static int var1 = 0;
static int var2 = 0;

void print_string(char *string, char color){
	int i = 0;
	char *p = (char*)0xB8000;
	while(string[i] != 0){
		p[i*2] = string[i];
		p[i*2+1] = color;
		i++;
	}
}

int main() {
	//All the following code may be removed 

	print_string("ARQUITECTURA DE COMPUTADORAS", 0xfa);

	//Test if BSS is properly set up
	if (var1 == 0 && var2 == 0)
		return 0xDEADC0DE;

	return 0xDEADBEEF;
}