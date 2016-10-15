#! /bin/sh

MY_JAVA_VERS="1.6 1.7 1.8"

for i in $MY_JAVA_VERS; do
    echo "$i => $(/usr/libexec/java_home -v $i)";
done
