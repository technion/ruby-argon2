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
#include "../phc-winner-argon2/src/core.h"

#define T_COST_DEF 3
#define LOG_M_COST_DEF 12 /* 2^12 = 4 MiB */
#define LANES_DEF 1
#define THREADS_DEF 1
#define OUT_LEN 32
#define SALT_LEN 16

unsigned int argon2_wrap(char *out, char *pwd, uint8_t *salt, uint32_t t_cost,
                uint32_t m_cost, uint32_t lanes)
{
    unsigned pwd_length;
    uint8_t hash[OUT_LEN];
    argon2_context context;

    if (!pwd) {
        return ARGON2_PWD_PTR_MISMATCH;
    }

    if (!salt) {
        return ARGON2_PWD_PTR_MISMATCH;
    }

    pwd_length = strlen(pwd);

    context.out = hash;
    context.outlen = OUT_LEN;
    context.pwd = (uint8_t *)pwd;
    context.pwdlen = pwd_length;
    context.salt = salt;
    context.saltlen = SALT_LEN;
    context.secret = NULL;
    context.secretlen = 0;
    context.ad = NULL;
    context.adlen = 0;
    context.t_cost = t_cost;
    context.m_cost = m_cost;
    context.lanes = lanes;
    context.threads = lanes;
    context.allocate_cbk = NULL;
    context.free_cbk = NULL;
    context.flags = 0;

    int result = argon2i(&context);
    if (result != ARGON2_OK)
        return result;

    encode_string(out, 300, &context);
    return ARGON2_OK;
}
 
