//ECGR 6090 Heterogeneous Computing Homework 0
// Problem 1 b - Vector Add on GPU
//Written by Aneri Sheth - 801085402

// Reference taken from Lecture Slides by Dr. Tabkhi 
// Other references taken from - http://ecee.colorado.edu/~siewerts/extra/code/example_code_archive/a490dmis_code/CUDA/cuda_work/samples/0_Simple/vectorAdd/vectorAdd.cu and https://docs.nvidia.com/cuda/cuda-c-best-practices-guide/index.html#using-cuda-gpu-timers


#include<stdio.h>
#include<stdlib.h>
#include<time.h>

#define n 1000000 //fixed job size
#define m 128 //thread block size

__global__ void add(int *a, int *b, int *c, int k)  //add kernel
{
	int index = threadIdx.x+ blockIdx.x * blockDim.x
	if (index<k)
		c[index] = a[index] + b[index];
}

//function to get random numbers
void random_ints(int* x, int size)
{
	int i;
	for (i=0;i<size;i++) {
		x[i]=rand()%n;
	}
}

int main(void)
{

	int *a, *b, *c; //CPU copies
	int *d_a, *d_b, *d_c; //GPU copies
	int size = n * sizeof(int);

	cudaEvent_t start, stop; //time start and stop
	float time;

	cudaEventCreate(&start);
	cudaEventCreate(&stop);

	//Allocate device memory
	cudaMalloc((void **)&d_a, size);
	cudaMalloc((void **)&d_b, size);
	cudaMalloc((void **)&d_c, size);

	//Allocate CPU memory
	a = (int *)malloc(size); random_ints(a, n);
	b = (int *)malloc(size); random_ints(b, n);
	c = (int *)malloc(size);

	cudaEventRecord( start, 0 );
	
	//Copy CPU memory to GPU memory	
	cudaMemcpy(d_a, a, size, cudaMemcpyHostToDevice);
	cudaMemcpy(d_b, b, size, cudaMemcpyHostToDevice);
	
	
	//Call the add kernel
	add<<<(n+m-1)/m,m>>>(d_a, d_b, d_c,n); 
	
	printf("GPU Execution Time = %f\n,time);
	
	// Copy from device to host
	cudaMemcpy(c, d_c, size, cudaMemcpyDeviceToHost);
	cudaEventRecord( stop, 0 );
	cudaEventSynchronize(stop);
	cudaEventElapsedTime( &time, start, stop );
	cudaEventDestroy( start );
	cudaEventDestroy( stop );
	printf("Time = %f\n",time);


	for (int i=0;i<n;i++) {
		printf("a[%d]=%d , b[%d]=%d, c[%d]=%d\n",i,a[i],i,b[i],i,c[i]); 
	} //print the result
	
	free(a); free(b); free(c);
	cudaFree(d_a); cudaFree(d_b); cudaFree(d_c);

	return 0;

}


