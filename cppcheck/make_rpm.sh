#!/bin/sh

if [ -z "$1" -o ! -d "$1" ]; then
    echo "Pass the directory of the cppcheck sources to build"
    exit 1
fi

pushd $1

make \
	MATCHCOMPILER=yes \
	FILESDIR=/usr/share/cppcheck \
	HAVE_RULES=yes 


pkg_version="$(./cppcheck --version | cut -d ' ' -f2- | tr ' ' '_')"

popd

rpmbuild -bb cppcheck.spec --define "_makedir $1" \
	--define "_tmppath $PWD" \
	--define "_pkg_version $pkg_version" \
	      
rm -f *_list
