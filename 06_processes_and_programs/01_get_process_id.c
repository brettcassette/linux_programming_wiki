#include <unistd.h>
#include <stdio.h>

int main() {
  printf("%i", getppid());
  return 0;
}
