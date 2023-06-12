#!/bin/bash

function createOrg1() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/uniMadrid.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/uniMadrid.example.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname ca-uniMadrid --tls.certfiles "${PWD}/organizations/fabric-ca/uniMadrid/tls-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-uniMadrid.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-uniMadrid.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-uniMadrid.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-uniMadrid.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/uniMadrid.example.com/msp/config.yaml"

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-uniMadrid --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/uniMadrid/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-uniMadrid --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/uniMadrid/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-uniMadrid --id.name org1admin --id.secret org1adminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/uniMadrid/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-uniMadrid -M "${PWD}/organizations/peerOrganizations/uniMadrid.example.com/peers/peer0.uniMadrid.example.com/msp" --csr.hosts peer0.uniMadrid.example.com --tls.certfiles "${PWD}/organizations/fabric-ca/uniMadrid/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/uniMadrid.example.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/uniMadrid.example.com/peers/peer0.uniMadrid.example.com/msp/config.yaml"

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-uniMadrid -M "${PWD}/organizations/peerOrganizations/uniMadrid.example.com/peers/peer0.uniMadrid.example.com/tls" --enrollment.profile tls --csr.hosts peer0.uniMadrid.example.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/uniMadrid/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/uniMadrid.example.com/peers/peer0.uniMadrid.example.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/uniMadrid.example.com/peers/peer0.uniMadrid.example.com/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/uniMadrid.example.com/peers/peer0.uniMadrid.example.com/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/uniMadrid.example.com/peers/peer0.uniMadrid.example.com/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/uniMadrid.example.com/peers/peer0.uniMadrid.example.com/tls/keystore/"* "${PWD}/organizations/peerOrganizations/uniMadrid.example.com/peers/peer0.uniMadrid.example.com/tls/server.key"

  mkdir -p "${PWD}/organizations/peerOrganizations/uniMadrid.example.com/msp/tlscacerts"
  cp "${PWD}/organizations/peerOrganizations/uniMadrid.example.com/peers/peer0.uniMadrid.example.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/uniMadrid.example.com/msp/tlscacerts/ca.crt"

  mkdir -p "${PWD}/organizations/peerOrganizations/uniMadrid.example.com/tlsca"
  cp "${PWD}/organizations/peerOrganizations/uniMadrid.example.com/peers/peer0.uniMadrid.example.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/uniMadrid.example.com/tlsca/tlsca.uniMadrid.example.com-cert.pem"

  mkdir -p "${PWD}/organizations/peerOrganizations/uniMadrid.example.com/ca"
  cp "${PWD}/organizations/peerOrganizations/uniMadrid.example.com/peers/peer0.uniMadrid.example.com/msp/cacerts/"* "${PWD}/organizations/peerOrganizations/uniMadrid.example.com/ca/ca.uniMadrid.example.com-cert.pem"

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:7054 --caname ca-uniMadrid -M "${PWD}/organizations/peerOrganizations/uniMadrid.example.com/users/User1@uniMadrid.example.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/uniMadrid/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/uniMadrid.example.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/uniMadrid.example.com/users/User1@uniMadrid.example.com/msp/config.yaml"

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://org1admin:org1adminpw@localhost:7054 --caname ca-uniMadrid -M "${PWD}/organizations/peerOrganizations/uniMadrid.example.com/users/Admin@uniMadrid.example.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/uniMadrid/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/uniMadrid.example.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/uniMadrid.example.com/users/Admin@uniMadrid.example.com/msp/config.yaml"
}

function createOrg2() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/uniBogota.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/uniBogota.example.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:8054 --caname ca-uniBogota --tls.certfiles "${PWD}/organizations/fabric-ca/uniBogota/tls-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-uniBogota.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-uniBogota.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-uniBogota.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-uniBogota.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/uniBogota.example.com/msp/config.yaml"

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-uniBogota --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/uniBogota/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-uniBogota --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/uniBogota/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-uniBogota --id.name org2admin --id.secret org2adminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/uniBogota/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-uniBogota -M "${PWD}/organizations/peerOrganizations/uniBogota.example.com/peers/peer0.uniBogota.example.com/msp" --csr.hosts peer0.uniBogota.example.com --tls.certfiles "${PWD}/organizations/fabric-ca/uniBogota/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/uniBogota.example.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/uniBogota.example.com/peers/peer0.uniBogota.example.com/msp/config.yaml"

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-uniBogota -M "${PWD}/organizations/peerOrganizations/uniBogota.example.com/peers/peer0.uniBogota.example.com/tls" --enrollment.profile tls --csr.hosts peer0.uniBogota.example.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/uniBogota/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/uniBogota.example.com/peers/peer0.uniBogota.example.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/uniBogota.example.com/peers/peer0.uniBogota.example.com/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/uniBogota.example.com/peers/peer0.uniBogota.example.com/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/uniBogota.example.com/peers/peer0.uniBogota.example.com/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/uniBogota.example.com/peers/peer0.uniBogota.example.com/tls/keystore/"* "${PWD}/organizations/peerOrganizations/uniBogota.example.com/peers/peer0.uniBogota.example.com/tls/server.key"

  mkdir -p "${PWD}/organizations/peerOrganizations/uniBogota.example.com/msp/tlscacerts"
  cp "${PWD}/organizations/peerOrganizations/uniBogota.example.com/peers/peer0.uniBogota.example.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/uniBogota.example.com/msp/tlscacerts/ca.crt"

  mkdir -p "${PWD}/organizations/peerOrganizations/uniBogota.example.com/tlsca"
  cp "${PWD}/organizations/peerOrganizations/uniBogota.example.com/peers/peer0.uniBogota.example.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/uniBogota.example.com/tlsca/tlsca.uniBogota.example.com-cert.pem"

  mkdir -p "${PWD}/organizations/peerOrganizations/uniBogota.example.com/ca"
  cp "${PWD}/organizations/peerOrganizations/uniBogota.example.com/peers/peer0.uniBogota.example.com/msp/cacerts/"* "${PWD}/organizations/peerOrganizations/uniBogota.example.com/ca/ca.uniBogota.example.com-cert.pem"

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:8054 --caname ca-uniBogota -M "${PWD}/organizations/peerOrganizations/uniBogota.example.com/users/User1@uniBogota.example.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/uniBogota/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/uniBogota.example.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/uniBogota.example.com/users/User1@uniBogota.example.com/msp/config.yaml"

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://org2admin:org2adminpw@localhost:8054 --caname ca-uniBogota -M "${PWD}/organizations/peerOrganizations/uniBogota.example.com/users/Admin@uniBogota.example.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/uniBogota/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/uniBogota.example.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/uniBogota.example.com/users/Admin@uniBogota.example.com/msp/config.yaml"
}

function createOrderer() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/ordererOrganizations/example.com

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/ordererOrganizations/example.com

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:9054 --caname ca-orderer --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml"

  infoln "Registering orderer"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the orderer admin"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the orderer msp"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp" --csr.hosts orderer.example.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml" "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/config.yaml"

  infoln "Generating the orderer-tls certificates"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls" --enrollment.profile tls --csr.hosts orderer.example.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/"* "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/ca.crt"
  cp "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/signcerts/"* "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.crt"
  cp "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/keystore/"* "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.key"

  mkdir -p "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts"
  cp "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/"* "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem"

  mkdir -p "${PWD}/organizations/ordererOrganizations/example.com/msp/tlscacerts"
  cp "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/"* "${PWD}/organizations/ordererOrganizations/example.com/msp/tlscacerts/tlsca.example.com-cert.pem"

  infoln "Generating the admin msp"
  set -x
  fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:9054 --caname ca-orderer -M "${PWD}/organizations/ordererOrganizations/example.com/users/Admin@example.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml" "${PWD}/organizations/ordererOrganizations/example.com/users/Admin@example.com/msp/config.yaml"
}
