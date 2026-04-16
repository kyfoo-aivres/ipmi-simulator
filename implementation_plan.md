# Evaluate and Upgrade to Support IPMI 2.0

## Goal Description
The objective is to evaluate the current IPMI simulator's compliance with the Intel IPMI v2.0 specification and modify the codebase to support missing IPMI 2.0 features.

## User Review Required
> [!WARNING]
> This repository (`ipmi-simulator`) does not contain the actual C/C++ source code for the simulator. It only contains Docker configuration and wrapper scripts that load a pre-compiled `openipmi-lanserv` binary via Alpine's package manager.
> 
> To "upgrade the codes", I need clarification on your goal. There are two potential paths forward:
> 
> **Option 1: Source-Code Upgrade (Recommended if you want to write custom C code)**
> Pull the OpenIPMI source code into this repository, modify its C code to implement missing IPMI 2.0 logic, and then compile it from source in the Docker container.
> 
> **Option 2: Configuration Upgrade**
> Only modify the simulator's configuration (`lan.conf` and `sim.emu`) to ensure all existing IPMI 2.0 capabilities within the pre-compiled `ipmi_sim` binary are properly enabled (e.g. currently SOL and RMCP+ BMC keys are already configured).

## Proposed Changes

### If we proceed with Option 1 (Full Source-Code Upgrade):

#### [MODIFY] Dockerfile
- Remove the `RUN apk add openipmi-lanserv` package installation.
- Install compilation dependencies (e.g. `build-base`, `autoconf`, `popt-dev`, `ncurses-dev`).
- Add steps to clone or download the underlying `OpenIPMI` source code.
- Add `./configure` and `make` steps to build a customized `ipmi_sim` binary.

#### [NEW] Custom OpenIPMI Patches
- Introduce custom C logic based on the Intel IPMI 2.0 Specification to add any missing RMCP+ payload types, advanced firmware firewall features, or newer cipher suites.

### If we proceed with Option 2 (Configuration Only):

#### [MODIFY] lan.conf
- Analyze existing settings and add missing configurations corresponding to IPMI 2.0 features like advanced privilege limits or VLAN configurations if supported.

## Open Questions
> [!IMPORTANT]
> How would you like me to proceed? Should I set up the environment to compile `OpenIPMI` from source so we can introduce new IPMI 2.0 C-code logic, or are we just looking to adjust the `lan.conf` to maximize the current pre-compiled binary's potential?

## Verification Plan

### Manual Verification
- Rebuild the docker image using `make build`.
- Run the simulator using `make run`.
- Use `ipmitool` with LAN+ (IPMI 2.0) to manually verify commands: `ipmitool -H 127.0.0.1 -U ADMIN -P ADMIN -I lanplus sol info` etc.
- Cross-reference standard compliance against the IPMI v2.0 requirements specified in the Intel document.
