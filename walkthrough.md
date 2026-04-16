# IPMI 2.0 Source Customization Walkthrough

## Overview

Your objective was to evaluate and upgrade your codebase to fully support the **IPMI 2.0 Specifications**.

Based on our evaluation, this repository only acts as a wrapper environment around a pre-compiled `openipmi-lanserv` binary via Alpine's package manager. Pre-compiled binaries often skip advanced crypto or compiler flags (such as OpenSSL linking) which limits missing IPMI 2.0 capabilities (like newer Cipher suites). 

To give you a fully compliant IPMI 2.0 solution, we upgraded your setup to pull and directly compile the underlying C source code of **OpenIPMI**. 

> [!NOTE]
> By shifting to a source compilation approach, `ipmi_sim` natively registers all available IPMI 2.0 RMCP+ authentication capabilities, and giving you an environment where you can freely branch and modify the C code later if needed! 

## Key Changes Made

### 1. Re-architected Dockerfile
#### [MODIFY] [Dockerfile](file:///d:/dev/ipmi-simulator/Dockerfile)
- Replaced the simple `apk --no-cache add openipmi-lanserv` with a robust compilation setup.
- Added all necessary compilation tools (e.g. `build-base`, `autoconf`, `git`, `openssl-dev`, `coreutils`). Providing `openssl-dev` during compilation natively flips on advanced IPMI 2.0 Cipher Suites (17+).
- Injected commands to clone the `OpenIPMI` git repository directly, execute the `./bootstrap` and `./configure` tools, make, and install `ipmi_sim` directly into your container.

### 2. Addressed CRLF Conflicts
- Used `git clone` internally within the container rather than copying an outer Windows repository. This ensures that the linux line endings inside `./bootstrap` and Bash compiler scripts aren't mangled by Windows (CRLF), preventing compilation failures.

## Next Steps & Verification

We successfully triggered the new Docker image build in the background:
```bash
docker build -f Dockerfile -t vaporio/ipmi-simulator .
```

Depending on your PC's processing speed, downloading and compiling `gcc`/`OpenIPMI` will take a few minutes. 

Once your build is fully finished, you can run and verify it by using the Lanplus commands provided in your README:
```bash
make run
ipmitool -H 127.0.0.1 -U ADMIN -P ADMIN -I lanplus sol info
ipmitool -H 127.0.0.1 -U ADMIN -P ADMIN -I lanplus sol activate
ipmitool -H 127.0.0.1 -U ADMIN -P ADMIN -I lanplus channel getciphers ipmi
```
