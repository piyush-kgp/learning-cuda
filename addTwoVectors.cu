
#include <stdio.h>
#include <stdlib.h>
#define N 10


// F1
// __global__ void add(int *a, int *b, int *c){
//   int idx = blockIdx.x;
//   if (idx<N){
//     c[idx] = a[idx]+b[idx];
//   }
// }


//F2
// __global__ void add(int *a, int *b, int *c){
//   int idx = threadIdx.x;
//   if (idx<N){
//     c[idx] = a[idx]+b[idx];
//   }
// }


// F3
__global__ void add(int *a, int *b, int *c){
  int idx = blockIdx.x*blockDim.x + threadIdx.x;
  if (idx<N){
    c[idx] = a[idx]+b[idx];
  }
}


int main(){
  int a[N], b[N], c[N];
  for (int i=0; i<N; i++){
    a[i] = rand()%100;
    b[i] = rand()%100;
  }
  int *d1, *d2, *d3;
  int size = sizeof(int);
  cudaMalloc((void **)&d1, N*size);
  cudaMalloc((void **)&d2, N*size);
  cudaMalloc((void **)&d3, N*size);
  cudaMemcpy(d1, a, N*size, cudaMemcpyHostToDevice);
  cudaMemcpy(d2, b, N*size, cudaMemcpyHostToDevice);

  // add<<<N,1>>>(d1, d2, d3); //use with F1
  // add<<<1,N>>>(d1, d2, d3); //use with F2
  int nBlocks=2, nThreadsPerBlock=N/2;
  add<<<nBlocks,nThreadsPerBlock>>>(d1, d2, d3); //use with  F3

  cudaMemcpy(c, d3, N*size, cudaMemcpyDeviceToHost);
  cudaFree(d1); cudaFree(d2); cudaFree(d3);
  for (int i=0; i<N; i++){
    printf("Sum of %d and %d = %d\n", a[i], b[i], c[i]);
  }
  return 0;
}
