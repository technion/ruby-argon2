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
#include <assert.h>

#include "../phc-winner-argon2/src/argon2.h"

#define OUT_LEN 32
#define SALT_LEN 16

/**
 * Hashes a password with Argon2i, producing a raw hash
 * @param t_cost Number of iterations
 * @param m_cost Sets memory usage to 2^m_cost kibibytes
 * @param parallelism Number of threads and compute lanes
 * @param pwd Pointer to password
 * @param pwdlen Password size in bytes
 * @param salt Pointer to salt
 * @param saltlen Salt size in bytes
 * @param hash Buffer where to write the raw hash
 * @param hashlen Desired length of the hash in bytes
 * @pre   Different parallelism levels will give different results
 * @pre   Returns ARGON2_OK if successful

int argon2i_hash_raw(const uint32_t t_cost, const uint32_t m_cost,
                     const uint32_t parallelism, const void *pwd,
                     const size_t pwdlen, const void *salt,
                     const size_t saltlen, void *hash, const size_t hashlen);

*/

void argon2_wrap(char *out, const char *pwd, uint8_t *salt, uint32_t t_cost,
    uint32_t m_cost, uint32_t lanes,
    uint8_t *secret, size_t secretlen);

int wrap_argon2_verify(const char *encoded, const char *pwd,
    const size_t pwdlen,
    uint8_t *secret, size_t secretlen);

 
int main()
{
    unsigned char out[OUT_LEN];
    unsigned char hex_out[OUT_LEN*2];
    char out2[300];
    char *pwd = NULL;
    uint8_t salt[SALT_LEN];
    int i, ret;

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
     * ./argon2 differentpassword somesalt -t 2 -m 16 -p 1
     * Hash: 8e286f605ed7383987a4aac25a28a04808593b6e17613bc31457146c4f3f4361
     * ./argon2 password diffsalt -t 2 -m 16 -p 1
     * Hash: 8f65b47d902fb2aee5e0b2bdc9041b249fc11f06f35551e0bee52716b41e8311
     */

#define RAWTEST(T, M, P, PWD, REF) \
    pwd = strdup(PWD); \
    ret = argon2i_hash_raw(T, 1<<M, P, pwd, strlen(pwd), salt, SALT_LEN, out, OUT_LEN); \
    assert(ret == ARGON2_OK); \
    for(i=0; i<OUT_LEN; ++i ) \
        sprintf((char*)(hex_out + i*2), "%02x", out[i] ); \
    assert(memcmp(hex_out, REF, OUT_LEN*2) == 0); \
    free(pwd); \
    printf( "Ref test: %s: PASS\n", REF);

    RAWTEST(2, 16, 1, "password", "894af4ff2e2d26f3ce15f77a7e1c25db45b4e20439e9961772ba199caddb001e");
    RAWTEST(2, 20, 1, "password", "58d4d929aeeafa40cc049f032035784fb085e8e0d0c5a51ea067341a93d6d286");
    RAWTEST(2, 18, 1, "password", "55292398cce8fc78685e610d004ca9bda5c325a0a2e6285a0de5f816df139aa6");
    RAWTEST(2, 8, 1, "password", "e346b1e1aa7ca58c9bb862e223ba5604064398d4394e49e90972c6b54cef43ed");
    RAWTEST(1, 16, 1, "password", "b49199e4ecb0f6659e6947f945e391c940b17106e1d0b0a9888006c7f87a789b");
    RAWTEST(4, 16, 1, "password", "72207b3312d79995fbe7b30664837ae1246f9a98e07eac34835ca3498e705f85");
    RAWTEST(2, 16, 1, "differentpassword", "8e286f605ed7383987a4aac25a28a04808593b6e17613bc31457146c4f3f4361");
    memcpy(salt, "diffsalt", 8);
    RAWTEST(2, 16, 1, "password", "8f65b47d902fb2aee5e0b2bdc9041b249fc11f06f35551e0bee52716b41e8311");


#define WRAP_TEST(T, M, PWD, REF) \
    pwd = strdup(PWD); \
    argon2_wrap(out2, pwd, salt, T, 1<<M, 1, NULL, 0); \
    free(pwd); \
    assert(memcmp(out2, REF, strlen(REF)) == 0); \
    printf( "Ref test: %s: PASS\n", REF);

    memcpy(salt, "somesalt", 8);
    /* echo password | ./argon2 somesalt -t 2 -m 16
     * $argon2i$m=65536,t=2,p=1$c29tZXNhbHQAAAAAAAAAAA$iUr0/y4tJvPOFfd6fhwl20W04gQ56ZYXcroZnK3bAB4
     */
    WRAP_TEST(2, 16, "password", 
            "$argon2i$m=65536,t=2,p=1$c29tZXNhbHQAAAAAAAAAAA$iUr0/y4tJvPOFfd6fhwl20W04gQ56ZYXcroZnK3bAB4");

    /* echo password | ./argon2 somesalt -t 2 -m 8
     * $argon2i$m=256,t=2,p=1$c29tZXNhbHQAAAAAAAAAAA$40ax4ap8pYybuGLiI7pWBAZDmNQ5TknpCXLGtUzvQ+0
     */
    WRAP_TEST(2, 8, "password", 
            "$argon2i$m=256,t=2,p=1$c29tZXNhbHQAAAAAAAAAAA$40ax4ap8pYybuGLiI7pWBAZDmNQ5TknpCXLGtUzvQ+0");

    /* echo diffpassword | ./argon2 somesalt -t 2 -m 16
     * $argon2i$m=65536,t=2,p=1$c29tZXNhbHQAAAAAAAAAAA$y/IeiuTydN/Sud4UzLqv6Spx8Eqree6FoP088X6WyW4
     */
    WRAP_TEST(2, 16, "diffpassword", 
            "$argon2i$m=65536,t=2,p=1$c29tZXNhbHQAAAAAAAAAAA$y/IeiuTydN/Sud4UzLqv6Spx8Eqree6FoP088X6WyW4");

    ret = wrap_argon2_verify("$argon2i$m=65536,t=2,p=1$c29tZXNhbHQAAAAAAAAAAA$iUr0/y4tJvPOFfd6fhwl20W04gQ56ZYXcroZnK3bAB4", "password",
            strlen("password"), NULL, 0);
    assert(ret == ARGON2_OK);
    printf("Verify OK test: PASS\n");

    ret = wrap_argon2_verify("$argon2i$m=65536,t=2,p=1$c29tZXNhbHQAAAAAAAAAAA$iUr0/y4tJvPOFfd6fhwl20W04gQ56ZYXcroZnK3bAB4", "notpassword",
            strlen("notpassword"), NULL, 0);
    assert(ret == ARGON2_DECODING_FAIL);
    printf("Verify FAIL test: PASS\n");
    return 0;


}

