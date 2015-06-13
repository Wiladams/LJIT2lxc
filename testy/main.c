

#include <stdio.h>
#include <sys/types.h>

// Simple test to check the size of these things
// to create an appropriate typedef
int main()
{
    printf("pid_t: %zu\n", sizeof(pid_t));
    printf("uid_t: %zu\n", sizeof(uid_t));
    printf("gid_t: %zu\n", sizeof(gid_t));
}

