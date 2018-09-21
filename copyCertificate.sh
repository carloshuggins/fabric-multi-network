#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
WORKING_DIR="Certificates";
KEY1="INSERT_ORDERER_CA_CERT";
KEY2="INSERT_ORG1_CA_CERT"
ORG1=crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
if [ -d "$DIR/$WORKING_DIR" ]
then 
        rm -Rf $WORKING_DIR; 
fi
if [ -d "multi-network.json" ]
then 
        rm -f multi-network.json 
fi
mkdir -p $DIR/$WORKING_DIR;
cd $DIR/$WORKING_DIR;
cp $DIR/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/ca.crt orderer-ca.crt
cp $DIR/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt org1-ca.crt
cp $DIR/multi-network-template.json $DIR/multi-network.json
sed -i -e "s|$KEY1|$(awk 'NF {sub(/\r/, ""); printf "%s\\\\n",$0;}' $DIR/$WORKING_DIR/orderer-ca.crt)|g" $DIR/multi-network.json
sed -i -e "s|$KEY2|$(awk 'NF {sub(/\r/, ""); printf "%s\\\\n",$0;}' $DIR/$WORKING_DIR/org1-ca.crt)|g" $DIR/multi-network.json

cp -p $DIR/$ORG1/signcerts/A*.pem $DIR/$WORKING_DIR
cp -p $DIR/$ORG1/keystore/*_sk $DIR/$WORKING_DIR

composer card create -p $DIR/multi-network.json -u PeerAdmin -c $DIR/$WORKING_DIR/Admin@org1.example.com-cert.pem -k $DIR/$WORKING_DIR/*_sk -r PeerAdmin -r ChannelAdmin -f $DIR/$WORKING_DIR/PeerAdmin@bymn-org1.$
composer card import -f $DIR/$WORKING_DIR/PeerAdmin@bymn-org1.card --card PeerAdmin@bymn-org1


