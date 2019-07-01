
#include <stdio.h>
#include <stdlib.h>
#define ROWS 2
#define COLS 3


// F1
// __global__ void add(int *a, int *b, int *c){
//   int idx = blockIdx.x*blockDim.x + threadIdx.x;
//   if (idx<ROWS*COLS){
//     c[idx] = a[idx] + b[idx];
//   }
// }

// F2
__global__ void add(int *a, int *b, int *c){
  int col = blockIdx.x*blockDim.x;
  int row = blockIdx.y*blockDim.y;
  if (row<ROWS && col<COLS){
    int idx = row*COLS + col;
    c[idx] = a[idx] + b[idx];
  }
}

int main(){
  int a[ROWS][COLS], b[ROWS][COLS], c[ROWS][COLS];
  for (int i=0; i<ROWS; i++){
    for (int j=0; j<COLS; j++){
      a[i][j] = rand()%100;
      b[i][j] = rand()%100;
    }
  }
  int *d1, *d2, *d3;
  int size = sizeof(int);
  cudaMalloc((void **)&d1, ROWS*COLS*size);
  cudaMalloc((void **)&d2, ROWS*COLS*size);
  cudaMalloc((void **)&d3, ROWS*COLS*size);
  cudaMemcpy(d1, a, ROWS*COLS*size, cudaMemcpyHostToDevice);
  cudaMemcpy(d2, b, ROWS*COLS*size, cudaMemcpyHostToDevice);

  // add<<<ROWS,COLS>>>(d1, d2, d3); //use with F1
  dim3 blocks_per_grid(COLS, ROWS); //2-D grid
  add<<<blocks_per_grid,1>>>(d1, d2, d3); //use with F2

  cudaMemcpy(c, d3, ROWS*COLS*size, cudaMemcpyDeviceToHost);
  cudaFree(d1); cudaFree(d2); cudaFree(d3);
  for (int i=0; i<ROWS; i++){
    for (int j=0; j<COLS; j++){
      printf("Sum of %d and %d = %d\n", a[i][j], b[i][j], c[i][j]);
    }
  }
  return 0;
}
