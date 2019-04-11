//ECGR 6090 Heterogeneous Computing Homework 0
// Problem 1 a - Vector Add on GPU
//Written by Aneri Sheth - 801085402

// Reference taken from Lecture Slides by Dr. Tabkhi 
// Other references taken from - http://ecee.colorado.edu/~siewerts/extra/code/example_code_archive/a490dmis_code/CUDA/cuda_work/samples/0_Simple/vectorAdd/vectorAdd.cu and https://docs.nvidia.com/cuda/cuda-c-best-practices-guide/index.html#using-cuda-gpu-timers


#include<stdio.h>
#include<stdlib.h>
#include<time.h>

#define n 1000 //job size = 1K, 10K, 100K, 1M and 10M

__global__ void add(int *a, int *b, int *c)  //add kernel
{
	c[blockIdx.x] = a[blockIdx.x] + b[blockIdx.x];
}

//function to generate random numbers 
void random_ints(int* x, int size)
{
	int i;
	for (i=0;i<size;i++) {
		x[i]=rand()%n;
	}
}

int main(void)
{

	int *a, *b, *c; // CPU copies 
	int *d_a, *d_b, *d_c; // GPU copies
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
	add<<<1,n>>>(d_a, d_b, d_c); //1 thread block with n threads 

	//Copy from device to host
	cudaMemcpy(c, d_c, size, cudaMemcpyDeviceToHost);
	
	cudaEventRecord( stop, 0 );
	cudaEventSynchronize(stop);
	cudaEventElapsedTime( &time, start, stop );
	cudaEventDestroy( start );
	cudaEventDestroy( stop );

	printf("GPU Execution Time = %f\n",time);

	for (int i=0;i<n;i++) {
		printf("a[%d]=%d , b[%d]=%d, c[%d]=%d\n",i,a[i],i,b[i],i,c[i]);
	} //print the result
	
	free(a); free(b); free(c);
	cudaFree(d_a); cudaFree(d_b); cudaFree(d_c);

	return 0;
}


