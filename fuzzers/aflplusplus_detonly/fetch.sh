#!/bin/bash
set -e

##
# Pre-requirements:
# - env FUZZER: path to fuzzer work dir
##

# from v4.10c, the skipdet overwrite default deterministic, so use several commits before
git clone --no-checkout https://github.com/AFLplusplus/AFLplusplus "$FUZZER/repo"
git -C "$FUZZER/repo" checkout eda770fd32b804e3ebd6a43738c0002f6118a463

pushd "$FUZZER/repo"
cp "$FUZZER/src/det-only.diff" .
git apply det-only.diff

rm "$FUZZER/repo/utils/aflpp_driver/aflpp_driver.c"
wget -O "$FUZZER/repo/utils/aflpp_driver/aflpp_driver.c" \
	https://raw.githubusercontent.com/AFLplusplus/AFLplusplus/458eb0813a6f7d63eed97f18696bca8274533123/utils/aflpp_driver/aflpp_driver.c

# Fix: CMake-based build systems fail with duplicate (of main) or undefined references (of LLVMFuzzerTestOneInput)
sed -i '{s/^int main/__attribute__((weak)) &/}' $FUZZER/repo/utils/aflpp_driver/aflpp_driver.c
sed -i '{s/^int LLVMFuzzerTestOneInput/__attribute__((weak)) &/}' $FUZZER/repo/utils/aflpp_driver/aflpp_driver.c
cat >> $FUZZER/repo/utils/aflpp_driver/aflpp_driver.c << EOF
__attribute__((weak))
int LLVMFuzzerTestOneInput(const uint8_t *Data, size_t Size)
{
  // assert(0 && "LLVMFuzzerTestOneInput should not be implemented in afl_driver");
  return 0;
}
EOF

patch -p1 -d "$FUZZER/repo" << EOF
--- a/utils/aflpp_driver/aflpp_driver.c
+++ b/utils/aflpp_driver/aflpp_driver.c
@@ -53,7 +53,7 @@
   #include "hash.h"
 #endif
 
-int                   __afl_sharedmem_fuzzing = 1;
+int                   __afl_sharedmem_fuzzing = 0;
 extern unsigned int * __afl_fuzz_len;
 extern unsigned char *__afl_fuzz_ptr;
 
@@ -111,7 +111,8 @@ extern unsigned int * __afl_fuzz_len;
 __attribute__((weak)) int LLVMFuzzerInitialize(int *argc, char ***argv);
 
 // Notify AFL about persistent mode.
-static volatile char AFL_PERSISTENT[] = "##SIG_AFL_PERSISTENT##";
+// DISABLED to avoid afl-showmap misbehavior
+static volatile char AFL_PERSISTENT[] = "##SIG_AFL_NOT_PERSISTENT##";
 int                  __afl_persistent_loop(unsigned int);
 
 // Notify AFL about deferred forkserver.
EOF
