#!/bin/bash
# Test code for syspro2023 kadai3
# Written by Shinichi Awamoto and Daichi Morita
# Edited by PENG AO

state=0
warn() { echo $1; state=1; }
dir=$(mktemp -d)
trap "rm -rf $dir" 0

check-report() {
    if [ ! -f report-$1.txt ]; then
        $2 "kadai-$1: Missing report-$1.txt."
    elif [ `cat report-$1.txt | wc -l` -eq 0 ]; then
        $2 "kadai-$1: 'report-$1.txt' is empty!"
    fi
}

kadai-a() {
    if [ -d kadai-a ]; then
        cp -r kadai-a $dir
        pushd $dir/kadai-a > /dev/null 2>&1

        if [ ! -f Makefile ]; then
            warn "kadai-a: Missing Makefile"
        fi

        make unsafe_btree > /dev/null 2>&1

        if [ ! -f unsafe_btree ]; then
            warn "kadai-a: Failed to generate the binary(unsafe_btree) with '$ make measure'"
        fi

        if [ `./unsafe_btree | wc -l` -ge 10000 ]; then
            warn "kadai-a: Nodes were not lost"
        fi

        make clean > /dev/null 2>&1

        if [ -f unsafe_btree ]; then
            warn "kadai-a: Failed to remove the binary(unsafe_btree) with '$ make clean'."
        fi

        if [ ! -z "`find . -name \*.o`" ]; then
            warn "kadai-a: Failed to remove object files(*.o) with '$ make clean'."
        fi

        if [ `grep '\-Wall' Makefile | wc -l` -eq 0 ]; then
            warn "kadai-a: Missing '-Wall' option."
        fi

        check-report a warn

        popd > /dev/null 2>&1
    else
        warn "kadai-a: No 'kadai-a' directory!"
    fi
}

kadai-b() {
    if [ -d kadai-b ]; then
        cp -r kadai-b $dir
        pushd $dir/kadai-b > /dev/null 2>&1

        if [ ! -f Makefile ]; then
            warn "kadai-b: Missing Makefile"
        fi

        make unsafe_btree > /dev/null 2>&1

        if [ ! -f unsafe_btree ]; then
            warn "kadai-b: Failed to generate the binary(unsafe_btree) with '$ make measure'"
        fi

        if [ `./unsafe_btree | wc -l` -ne 10000 ]; then
            warn "kadai-b: Nodes were lost"
        fi

        make clean > /dev/null 2>&1

        if [ -f unsafe_btree ]; then
            warn "kadai-b: Failed to remove the binary(unsafe_btree) with '$ make clean'."
        fi

        if [ ! -z "`find . -name \*.o`" ]; then
            warn "kadai-b: Failed to remove object files(*.o) with '$ make clean'."
        fi

        if [ `grep '\-Wall' Makefile | wc -l` -eq 0 ]; then
            warn "kadai-b: Missing '-Wall' option."
        fi

        check-report b warn

        popd > /dev/null 2>&1
    else
        warn "kadai-b: No 'kadai-b' directory!"
    fi
}

kadai-c() {
    if [ -d kadai-c ]; then
        cp -r kadai-c $dir
        pushd $dir/kadai-c > /dev/null 2>&1

        if [ ! -f Makefile ]; then
            warn "kadai-c: Missing Makefile"
        fi

        make bb > /dev/null 2>&1

        if [ ! -f bb ]; then
            warn "kadai-c: Failed to generate the binary(bb) with '$ make measure'"
        fi

        if [ `./bb | wc -l` -ne 10000 ]; then
            warn "kadai-c: Nodes were lost"
        fi

        make clean > /dev/null 2>&1

        if [ -f bb ]; then
            warn "kadai-c: Failed to remove the binary(bb) with '$ make clean'."
        fi

        if [ ! -z "`find . -name \*.o`" ]; then
            warn "kadai-c: Failed to remove object files(*.o) with '$ make clean'."
        fi

        if [ `grep '\-Wall' Makefile | wc -l` -eq 0 ]; then
            warn "kadai-c: Missing '-Wall' option."
        fi

        check-report c warn

        popd > /dev/null 2>&1
    else
        warn "kadai-c: No 'kadai-c' directory!"
    fi
}

kadai-d() {
    if [ -d kadai-d ]; then
        cp -r kadai-d $dir
        pushd $dir/kadai-d > /dev/null 2>&1

        check-report d warn

        popd > /dev/null 2>&1
    fi
}

if [ $# -eq 0 ]; then
    echo "#############################################"
    echo "Running tests..."
fi
for arg in {a..d}; do
    if [ $# -eq 0 ] || [[ "$@" == *"$arg"* ]]; then kadai-$arg; fi
done
if [ $# -eq 0 ]; then
    if [ $state -eq 0 ]; then echo "All tests have passed!"; fi
    echo "#############################################"
fi
exit $state
