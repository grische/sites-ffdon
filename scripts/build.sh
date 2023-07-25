#!/usr/bin/env bash

set -eEux

builddir=${BUILDDIR:-"builddir/workdir"}

target=${1}
gluon_ref=${2:-"v2020.2.3"}
jobs=${JOBS:-$(nproc)}

# Turn "v2018.2.3_v1.0.08-1-g78bbb5d" into "1.0.08-1-g78bbb5d"
version=$(git describe --tags | cut -f2 -d"_" | tr -d 'v')

mkdir -p "${builddir}/targets/${target}"

# Clone Gluon
gluon_build_dir="${builddir}/targets/${target}/gluon"
if [ ! -d "${gluon_build_dir}" ]; then
    gluon_branch="${gluon_ref%.[0-9]}.x"
    git clone --depth 1 --branch "${gluon_branch}" https://github.com/freifunk-gluon/gluon.git "${gluon_build_dir}"
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

# exclude building some devices to work around some flash size constraints
if [ "${target}" = "ar71xx-tiny" ]; then
    export GLUON_DEVICES="tp-link-tl-wr740n-nd-v1
tp-link-tl-wr740n-nd-v3
tp-link-tl-wr740n-nd-v4
tp-link-tl-wr740n-nd-v5
tp-link-tl-wr741n-nd-v1
tp-link-tl-wr741n-nd-v2
tp-link-tl-wr741n-nd-v4
tp-link-tl-wr741n-nd-v5
tp-link-tl-wr743n-nd-v1
tp-link-tl-wr743n-nd-v2
tp-link-tl-wa801n-nd-v1
tp-link-tl-wa801n-nd-v2
tp-link-tl-wa801n-nd-v3
tp-link-tl-wr840n-v2
tp-link-tl-wr841n-nd-v3
tp-link-tl-wr841n-nd-v5
tp-link-tl-wr841n-nd-v7
tp-link-tl-wr841n-nd-v8
tp-link-tl-wr841n-nd-v9
tp-link-tl-wr841n-nd-v10
tp-link-tl-wr841n-nd-v11
tp-link-tl-wr841n-nd-v12
tp-link-tl-wr843n-nd-v1
tp-link-tl-wr941n-nd-v2
tp-link-tl-wr941n-nd-v3
tp-link-tl-wr941n-nd-v4
tp-link-tl-wr941n-nd-v5
tp-link-tl-wr941n-nd-v6
tp-link-tl-wr940n-v4
tp-link-tl-wr940n-v6
tp-link-tl-wa730re-v1
tp-link-tl-wa750re-v1
tp-link-tl-wa830re-v1
tp-link-tl-wa830re-v2
tp-link-tl-wa850re-v1
tp-link-tl-wa860re-v1
tp-link-tl-wa901n-nd-v1
tp-link-tl-wa901n-nd-v2
tp-link-tl-wa901n-nd-v3
tp-link-tl-wa901n-nd-v4
tp-link-tl-wa901n-nd-v5"
fi

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
