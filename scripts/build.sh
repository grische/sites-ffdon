#!/usr/bin/env bash

set -eEux

builddir=${BUILDDIR:-"builddir/workdir"}

target=${1}
domain=${2}
gluon_ref=${3:-"v2018.2.4"}
ffdon_ref=${4:-"v2018.2.3_v1.0.08"}
jobs=${JOBS:-$(nproc)}

# Turn "v2018.2.3_v1.0.08-1-g78bbb5d" into "1.0.08-1-g78bbb5d"
version=$(git describe --tags | cut -f2 -d"_" | tr -d 'v')

mkdir -p "${builddir}/targets/${target}"

if [ ! -d "${builddir}/targets/${target}"/gluon ]; then
    git clone --depth 1 --branch "${gluon_ref}" https://github.com/freifunk-gluon/gluon.git "${builddir}/targets/${target}/gluon"
fi

if [ ! -d "${builddir}/targets/${target}"/gluon/site ]; then
    git clone --depth 1 --branch Domaene-"${domain}_${ffdon_ref}" https://github.com/ffdon/sites-ffdon.git "${builddir}/targets/${target}/gluon/site";
fi

if [ -d "patches" ]; then
    # Reset all previous patches
    pushd "${builddir}/targets/${target}/gluon"
    git clean -fdx patches
    popd

    # Apply custom patches
    for patch in patches/*; do
        patch_path=$(realpath "${patch}")
        pushd "${builddir}/targets/${target}/gluon"
        patch -p1 < "${patch_path}"
        popd
    done
fi

pushd "${builddir}/targets/${target}"/gluon
make update GLUON_RELEASE="${gluon_ref}+${version}" GLUON_TARGET="${target}" GLUON_BRANCH=stable GLUON_IMAGEDIR="${builddir}/output/${domain}/versions/v${version}" -j1 V=99
# nproc only returns a number, it is safe to disable it here
# shellcheck disable=SC2086
make        GLUON_RELEASE="${gluon_ref}+${version}" GLUON_TARGET="${target}" GLUON_BRANCH=stable GLUON_IMAGEDIR="${builddir}/output/${domain}/versions/v${version}" -j${jobs} V=99
popd
