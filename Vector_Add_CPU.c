//ECGR 6090 Heterogeneous Computing Homework 0
// Problem 1 a - Vector Add on CPU
//Written by Aneri Sheth - 801085402


 #include <stdio.h>
 #include <stdlib.h>
 #include <time.h>
 
#define n 1000 //job size = 1K, 10K, 100K, 1M, 10M

int main()
{
	static int a[n];
	static int b[n];
	static int c[n];
	int i;
	//double execution_time = 0.0;
	srand(time(NULL));
	clock_t begin = clock();
	for (i = 0; i<n; i++)
	{
		a[i] = rand()%n;
		b[i] = rand()%n;
		//printf("a = %d\n",a[i]);
		c[i] = a[i] + b[i];
		//printf("a = %d\n",a[i]);
		//printf("b = %d\n",b[i]);

		//printf("c = %d\n",c[i]);

	}
	clock_t end = clock();
	double execution_time = execution_time + (double)(end - begin)/CLOCKS_PER_SEC;
	printf("CPU Execution time = %f\n",execution_time);
	
	return 0;
}


	
