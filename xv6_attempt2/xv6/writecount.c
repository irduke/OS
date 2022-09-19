#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char**argv) {
    uint wc;
    setwritecount(0);
    printf(1, "test");

    wc = writecount();
    printf(1, "writecount: %d\n", wc);
    
    setwritecount(50);
    wc = writecount();
    printf(1, "writecount: %d\n", wc);

    exit();
}