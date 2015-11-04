/* Wrapper for argon Ruby bindings
 * lolware.net
 * Much of this code is based on run.c from the reference implementation
 */
#include <stdio.h>
#include <stdint.h>
#include <inttypes.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#define SALT_LEN 16


void argon2_wrap(uint8_t *out, char *pwd, uint8_t *salt, uint32_t t_cost,
    uint32_t m_cost, uint32_t lanes);
 
int main()
{
    unsigned char out[300];
    char *pwd = NULL;
    uint8_t salt[SALT_LEN];

    pwd = strdup("password");
    memset(salt, 0x00, SALT_LEN); /* pad with null bytes */
    memcpy(salt, "somesalt", 8);

    argon2_wrap(out, pwd, salt, 2, 1<<16, 4);

    printf("%s\n", out);

}

