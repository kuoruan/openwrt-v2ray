# openwrt-v2ray

V2Ray for OpenWrt.

[![Scan V2Ray Version](https://github.com/nie11kun/openwrt-v2ray/actions/workflows/version-scan.yml/badge.svg)](https://github.com/nie11kun/openwrt-v2ray/actions/workflows/version-scan.yml)
[![Build and Release](https://github.com/nie11kun/openwrt-v2ray/actions/workflows/build-release.yml/badge.svg)](https://github.com/nie11kun/openwrt-v2ray/actions/workflows/build-release.yml)
[![GitHub release (latest by date)](https://img.shields.io/github/v/release/nie11kun/openwrt-v2ray)](https://github.com/nie11kun/openwrt-v2ray/releases)

This repository contains OpenWrt packages for V2Ray, with automated updates and builds via GitHub Actions.

## Automated Workflows

This repository uses GitHub Actions to automate the maintenance of the V2Ray package:

### 1. Auto-Update (`version-scan.yml`)
- **Schedule**: Checked daily at 01:00 UTC.
- **Function**: Scans the upstream [v2fly/v2ray-core](https://github.com/v2fly/v2ray-core) repository for new releases.
- **Action**: If a new version is found:
    1.  Updates the `Makefile` with the new version and sha256 hash.
    2.  Creates a new branch `releases/vX.Y.Z-1`.
    3.  Pushes the branch and tag to the repository.
    4.  **Triggers Release Build**: Automatically starts the build process (Requires `PAT` configuration).

### 2. Build and Release (`build-release.yml`)
- **Trigger**: Triggered when a new tag is pushed.
- **Function**:
    - Sets up the OpenWrt SDK for multiple architectures (e.g., `x86_64`, `aarch64`, `mips`, etc.).
    - Compiles the `v2ray-core` and `v2ray-core-mini` packages.
- **Output**: Publishes a new GitHub Release with the compiled `.ipk` artifacts.

### 3. Build Test (`build-test.yml`)
- **Trigger**: Runs on Pull Requests or pushes to non-release branches.
- **Function**: Verifies that the package compiles correctly on `x86_64` to prevent broken code from merging.

## Configuration

To enable the automated workflows (especially the auto-triggering of releases), you must configure the following **Repository Secret**:

### `PAT` (Personal Access Token)
**Required for**: Auto-triggering the Release workflow after a version update.

1.  Generate a new token in [GitHub Developer Settings](https://github.com/settings/tokens).
    -   **Scopes**: `repo` (Full control) and `workflow`.
2.  Go to this repository's **Settings** -> **Secrets and variables** -> **Actions**.
3.  Add a new secret named `PAT` with your token value.

> [!IMPORTANT]
> Without a valid `PAT`, the Version Scan will fail to push the update, or will push it without triggering the Release Build.

### `OPENWRT_GOLANG_COMMIT` (Optional)
Used to pin a specific commit of the OpenWrt Golang package feed if needed during build.

## Installation

### Install via OPKG
*Instructions assume you have set up a custom repo or downloaded the ipk.*

1.  **Download** the `.ipk` file for your architecture from the [Releases Page](https://github.com/nie11kun/openwrt-v2ray/releases).
2.  **Upload** to your router (e.g., `/tmp/`).
3.  **Install**:
    ```sh
    opkg update
    opkg install /tmp/v2ray-core*.ipk
    ```

**Dependencies**: `ca-certificates`

## Manual Build (Advanced)

If you want to compile this package manually using the OpenWrt SDK:

1.  Download the **OpenWrt SDK** for your target.
2.  Clone this repository into `package/v2ray-core`:
    ```sh
    git clone https://github.com/nie11kun/openwrt-v2ray.git package/v2ray-core
    ```
3.  Update feeds:
    ```sh
    ./scripts/feeds update -a
    ./scripts/feeds install -a
    ```
4.  Configure:
    ```sh
    make menuconfig
    # Select Network -> Project V -> v2ray-core
    ```
5.  Compile:
    ```sh
    make package/v2ray-core/compile V=s
    ```
