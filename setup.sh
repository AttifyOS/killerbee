#!/usr/bin/env bash

set -e

show_usage() {
  echo "Usage: $(basename $0) takes exactly 1 argument (install | uninstall)"
}

if [ $# -ne 1 ]
then
  show_usage
  exit 1
fi

check_env() {
  if [[ -z "${APM_TMP_DIR}" ]]; then
    echo "APM_TMP_DIR is not set"
    exit 1
  
  elif [[ -z "${APM_PKG_INSTALL_DIR}" ]]; then
    echo "APM_PKG_INSTALL_DIR is not set"
    exit 1
  
  elif [[ -z "${APM_PKG_BIN_DIR}" ]]; then
    echo "APM_PKG_BIN_DIR is not set"
    exit 1
  fi
}

install() {
  wget https://github.com/AttifyOS/killerbee/releases/download/v3.0.0-beta.2/killerbee_3.0.0-beta.2.tar.gz -O $APM_TMP_DIR/killerbee_3.0.0-beta.2.tar.gz
  tar xf $APM_TMP_DIR/killerbee_3.0.0-beta.2.tar.gz -C $APM_PKG_INSTALL_DIR/
  rm $APM_TMP_DIR/killerbee_3.0.0-beta.2.tar.gz

  for tool in zbjammer zbdump zbreplay zbopenear zborphannotify zbpanidconflictflood zbstumbler zbkey zbrealign zbfakebeacon zbid zbconvert zbwardrive zbdsniff zbgoodfind zbcat zbassocflood zbscapy zbwireshark
  do
    echo '#!/usr/bin/env sh' > $APM_PKG_BIN_DIR/$tool
    echo "PATH=$APM_PKG_INSTALL_DIR/bin:\$PATH $APM_PKG_INSTALL_DIR/bin/$tool" >> $APM_PKG_BIN_DIR/$tool
    chmod +x $APM_PKG_BIN_DIR/$tool
  done
}

uninstall() {
  rm -rf $APM_PKG_INSTALL_DIR/*
  for tool in zbjammer zbdump zbreplay zbopenear zborphannotify zbpanidconflictflood zbstumbler zbkey zbrealign zbfakebeacon zbid zbconvert zbwardrive zbdsniff zbgoodfind zbcat zbassocflood zbscapy zbwireshark
  do
    rm $APM_PKG_BIN_DIR/$tool
  done
}

run() {
  if [[ "$1" == "install" ]]; then 
    install
  elif [[ "$1" == "uninstall" ]]; then 
    uninstall
  else
    show_usage
  fi
}

check_env
run $1