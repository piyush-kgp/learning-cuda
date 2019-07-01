
#include <stdio.h>

__global__ void add(int *a, int *b, int *c){
  *c = *a + *b;
}

int main(){
  int n1=2, n2=3, n3;
  int *d1, *d2, *d3;
  int size = sizeof(int);
  cudaMalloc((void **)&d1, size);
  cudaMalloc((void **)&d2, size);
  cudaMalloc((void **)&d3, size);
  cudaMemcpy(d1, &n1, size, cudaMemcpyHostToDevice);
  cudaMemcpy(d2, &n2, size, cudaMemcpyHostToDevice);
  add<<<1,1>>>(d1, d2, d3);
  cudaMemcpy(&n3, d3, size, cudaMemcpyDeviceToHost);
  printf("Sum of %d and %d = %d\n", n1, n2, n3);
  cudaFree(d1); cudaFree(d2); cudaFree(d3);
  return 0;
}
