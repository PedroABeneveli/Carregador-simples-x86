#include <stdio.h>
#include <stdlib.h>

extern void fit(int, int, int, int, int, int, int, int, int);

int main(int argc, char* argv[]) {
    if (argc % 2 == 1 || argc < 4 || argc > 10) {
        printf("Entrada invalida, numero errado de argumentos\n");
        return 0;
    }

    int sz = atoi(argv[1]);
    int e1 = atoi(argv[2]);
    int s1 = atoi(argv[3]);
    int e2 = argc > 4 ? atoi(argv[4]) : -1;
    int s2 = argc > 4 ? atoi(argv[5]) : -1;
    int e3 = argc > 6 ? atoi(argv[6]) : -1;
    int s3 = argc > 6 ? atoi(argv[7]) : -1;
    int e4 = argc > 8 ? atoi(argv[8]) : -1;
    int s4 = argc > 8 ? atoi(argv[9]) : -1;

    fit(sz, e1, s1, e2, s2, e3, s3, e4, s4);

    return 0;
}