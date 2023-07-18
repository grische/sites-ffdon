#!/usr/bin/env bash

set -eEux

builddir=${BUILDDIR:-"builddir/workdir"}

target=${1}
gluon_ref=${2:-"v2018.2.4"}
jobs=${JOBS:-$(nproc)}

# Turn "v2018.2.3_v1.0.08-1-g78bbb5d" into "1.0.08-1-g78bbb5d"
version=$(git describe --tags | cut -f2 -d"_" | tr -d 'v')

mkdir -p "${builddir}/targets/${target}"

# Clone Gluon
gluon_build_dir="${builddir}/targets/${target}/gluon"
if [ ! -d "${gluon_build_dir}" ]; then
    git clone --depth 1 --branch "${gluon_ref}" https://github.com/freifunk-gluon/gluon.git "${gluon_build_dir}"
fi

# Add site information
ln -sfT "${PWD}" "${gluon_build_dir}/site"

if [ -d "patches" ]; then
    # Reset all previous patches
    pushd "${gluon_build_dir}"
    git clean -fdx patches
    popd

    # Apply custom patches
    for patch in patches/*; do
        patch_path=$(realpath "${patch}")
        pushd "${gluon_build_dir}"
        patch -p1 < "${patch_path}"
        popd
    done
fi

pushd "${gluon_build_dir}"
make update GLUON_RELEASE="${gluon_ref}+${version}" GLUON_TARGET="${target}" GLUON_BRANCH=stable -j1 V=99
# nproc only returns a number, it is safe to disable it here
# shellcheck disable=SC2086
make        GLUON_RELEASE="${gluon_ref}+${version}" GLUON_TARGET="${target}" GLUON_BRANCH=stable -j${jobs} V=99

# Create manifests
for branch in experimental testing stable; do
    make manifest GLUON_RELEASE="${gluon_ref}+${version}" GLUON_BRANCH=${branch} GLUON_AUTOUPDATER_BRANCH=${branch}
done
popd

mkdir -p "output/"
mv -f "${gluon_build_dir}/output"/* "output/"
