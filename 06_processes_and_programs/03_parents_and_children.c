#include <unistd.h>
#include <stdio.h>

void println(void) {
  printf("\n");
}

void child_process(void) {
  printf("child's pid %d ppid %d", getpid(), getppid());
  println();
}

void parent_process(void) {
  printf("parent's pid %d ppid %d", getpid(), getppid());
  println();
}

int main(void) {
  pid_t pid;

  pid = fork();

  if (pid == 0) {
    printf("CHILD");
    println();
    child_process();
  } else {
    printf("PARENT");
    println();
    parent_process();
    sleep(1);
    printf("PARENT EXITING");
    println();
  }

  return 0;
}
