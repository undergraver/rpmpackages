#!/bin/sh

if [ -z "$1" -o ! -d "$1" ]; then
    echo "Pass the directory of the cppcheck sources to build"
    exit 1
fi

N_CPUS=`../numcpus.sh`

pushd $1

make \
	MATCHCOMPILER=yes \
	FILESDIR=/usr/share/cppcheck \
	HAVE_RULES=yes -j $N_CPUS


pkg_version="$(./cppcheck --version | cut -d ' ' -f2- | tr ' ' '_')"

popd

rpmbuild -ba cppcheck.spec --define "_makedir $1" \
	--define "_tmppath $PWD" \
	--define "_pkg_version $pkg_version" \
	--define "_num_cpus $N_CPUS"
	      
rm -f *_list
