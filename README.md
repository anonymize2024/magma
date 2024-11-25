This is an artifact for FSE'25 submission,

# Regarding MendelFuzz and AFL++ baseline

MendelFuzz has been merged into AFL++ mainstream as the default option. So for MendelFuzz, we just download 
AFL++ and didn't provide additional code repo. 

For AFL++-havoc, we use the same version of AFL++ as MendelFuzz, and patch a line of code to enable AFL++-havoc.

Note that AFL++ discard the original deterministic stage from v4.10c, so for AFL++ with deterministic 
stage, we opt for some commits earlyer (before skip introduced), this is same as AFL++ 4.10c except skipdet module. 


# Run the campaign

you may follow the standard magma instruction to run campaign, the aflplusplus_skipdet is our prototype MendelFuzz.

We modify the captainrc and include all fuzzers in primary evaluation.

If you want to try the det-study (Sec3), we provide aflplusplus_det_study that patch the vanilla AFL++ to include additional logs.


# Reproduce Bug Claims
MAGMA already provide unique bug metric (which is also their core contribution),
just run the script 'tools/benchd/exp2json.py $PATH_TO_WORKDIR bugs.json' and parse

# Reproduce Cov Claims
We replay all generated seeds on AFL++ instrumented binary and use afl-showmap to collect 
each fuzzer-trail's edge coverage. 

We first patch the MAGMA's ENTRYPOINT in 'docker/Dockerfile' and reuse the aflplusplus fuzzer.
In that case when running aflplusplus/libpng, you may step into a container that 
have all libng target build. Then we run '/path/to/afl-showmap -i path/to/queue -o test.map $FUZZER_TIMEOUT_MEMORY_OPTS -C -q -- /path/to/target $ARGS'
for each fuzzer-trail's results and parse the output to obtain the edge. 

Now we're working on the paper, so we don't have sufficient time to automated this process, 
For the same reason we didn't provide the parse script that plot the bug/coverage. 
But we promise we'll provide an automated script/Dockerfile after acceptance.


# Reproduce FuzzBench
We request a Google's cluster campaign and it's already publically available. 
For anonymized reason, we only download the data and host the report on this anonymized github site.
(anonymize2024.github.io/fuzzbench).
We promise we'll replace the link with the public fuzzbench report link (from fuzzbench.com)
upon paper acceptance.

Thanks for your interest in our prototype!


