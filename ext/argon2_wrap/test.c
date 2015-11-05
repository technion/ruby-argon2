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

#include "../phc-winner-argon2/src/argon2.h"

#define OUT_LEN 32
#define SALT_LEN 16



void argon2_wrap(char *out, char *pwd, uint8_t *salt, uint32_t t_cost,
    uint32_t m_cost, uint32_t lanes);
 
int main()
{
    unsigned char out[OUT_LEN];
    char out2[300];
    char *pwd = NULL;
    uint8_t salt[SALT_LEN];

    pwd = strdup("password");
    memset(salt, 0x00, SALT_LEN); /* pad with null bytes */
    memcpy(salt, "somesalt", 8);


    /* ./argon2 password somesalt -t 2 -m 16
     *  Hash: 894af4ff2e2d26f3ce15f77a7e1c25db45b4e20439e9961772ba199caddb001e
     * ./argon2 password somesalt -t 2 -m 20
     * Hash: 58d4d929aeeafa40cc049f032035784fb085e8e0d0c5a51ea067341a93d6d286
     * ./argon2 password somesalt -t 2 -m 18
     * Hash: 55292398cce8fc78685e610d004ca9bda5c325a0a2e6285a0de5f816df139aa6
     * ./argon2 password somesalt -t 2 -m 8
     * Hash: e346b1e1aa7ca58c9bb862e223ba5604064398d4394e49e90972c6b54cef43ed
     * ./argon2 password somesalt -t 1 -m 16
     * Hash: b49199e4ecb0f6659e6947f945e391c940b17106e1d0b0a9888006c7f87a789b
     * ./argon2 password somesalt -t 4 -m 16
     * Hash: 72207b3312d79995fbe7b30664837ae1246f9a98e07eac34835ca3498e705f85
     */
    hash_argon2i( out, OUT_LEN, pwd, strlen(pwd), salt, SALT_LEN, 2, 1<<16 );
    for(int i=0; i<32; ++i )
        printf( "%02x", out[i] );
    printf( "\n" );

    strcpy(pwd, "password"); /* hash_argon2i wipes password content */
    argon2_wrap(out2, pwd, salt, 2, 1<<16, 1);
    printf("%s\n", out2);
    free(pwd);;





}

