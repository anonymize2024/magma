This is an artifact for ICSE25 R1 #35 submission,

you may follow the standard magma instruction to run campaign, the aflplusplus_skipdet is our prototype SkipDet.

Note that AFL++ discard the original deterministic stage from v4.10c, so for AFL++ with deterministic stage, we opt for some commits earlyer (before skip introduced), this is same as AFL++ 4.10c except skipdet module. 

We modify the captainrc and include all fuzzers in primary evaluation.

If you want to try the det-study (Sec3), we provide aflplusplus_det_study that patch the vanilla AFL++ to include additional logs.

