#!/usr/bin/env bash

# 用于生成开发用的keystore和trust store以及对应的android端用的bks格式的trust store
# 需要 bcprov-ext-jdk15on-1.46.jar 与这个脚本在同一个目录

SCRIPT_DIR=$(cd "$(dirname "$0")"; pwd);

TARGET_DIR="${SCRIPT_DIR}/new_certs"

KEYSTORE="${TARGET_DIR}/keystore.jks"
TRUSTSOTRE="${TARGET_DIR}/truststore.jks"
BKS_TRUSTSOTRE="${TARGET_DIR}/android_truststore.bks"
SEVER_CERT="${TARGET_DIR}/server.cer"

ALIAS="<your alias>"
KEYPASS="<password>"

mkdir -p ${TARGET_DIR}

## Generate a Self Signed Certificate using Java Keytool
echo "1. generate Generate a Self Signed Certificate"
keytool -genkey -alias "${ALIAS}"  -keyalg RSA -keypass "${KEYPASS}" \
    -storepass "${KEYPASS}" -keystore "${KEYSTORE}" -validity 3600


echo "2. export certificate  from generated keystore"
# export cert
keytool -export -alias "${ALIAS}" -storepass "${KEYPASS}" -file "${SEVER_CERT}" -keystore "${KEYSTORE}"

echo "3. create a trust store and import certificate into it"
#  create trust store and import certificate into the trust sotre
keytool -import -v -trustcacerts -keystore "${TRUSTSOTRE}"  \
    -alias "${ALIAS}" -file "${SEVER_CERT}" -keypass "${KEYPASS}"

echo "4. generate android bks trustsotre";
keytool -import -v -trustcacerts -file "${SEVER_CERT}" \
    -alias "${ALIAS}" -keystore "${BKS_TRUSTSOTRE}" \
    -provider "org.bouncycastle.jce.provider.BouncyCastleProvider" \
    -providerpath "${SCRIPT_DIR}/bcprov-ext-jdk15on-1.46.jar" -storetype BKS \
    -storepass "${KEYPASS}"


