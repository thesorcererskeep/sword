#include <ctype.h>
#include <stdio.h>
#include <string.h>

#include <sys/ioctl.h>
#include <unistd.h>

/* Splits a string into lines every [width] characters. */
void format_string(char *s, const int width) {
  size_t len = strlen(s);
  size_t i = 0;
  int line_count = 1;
  while (i <= len) {
    char c = s[i];
    if (c == '\n') {
      line_count = 1;
    }
    if (line_count >= width) {
      while (!isspace(c) && i >= 0) {
        i--;
        c = s[i];
      }
      s[i] = '\n';
      line_count = 1;
    }
    line_count++;
    i++;
  }
}

char foo[] = "Mary had a little lamb\nwho's fleece was whittle as a piddle, and every where that Mary went this lamb was sure to go.";

int main(void) {
  /* Get terminal width */
  struct ttysize ts;
  ioctl(STDIN_FILENO, TIOCGSIZE, &ts);
  int  cols = ts.ts_cols;
  printf("Cols: %d\n", cols);

  printf("Original: \n%s\n", foo);
  format_string(foo, cols - 1);
  printf("Formatted:\n%s\n", foo);
  return 0;
}
