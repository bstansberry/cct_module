#!/usr/bin/env bats

source $BATS_TEST_DIRNAME/../../../added/launch/jboss_modules_system_pkgs.sh

@test "generate_jboss_modules_system_pkgs: By default includes org.jboss.logmanager" {
  result=$(generate_jboss_modules_system_pkgs)
  [ $result = "jdk.nashorn.api,com.sun.crypto.provider,org.jboss.logmanager" ]
}

@test "generate_jboss_modules_system_pkgs: JDK 6 includes org.jboss.logmanager" {
  JAVA_VERSION="1.6.0"
  result=$(generate_jboss_modules_system_pkgs)
  [ $result = "jdk.nashorn.api,com.sun.crypto.provider,org.jboss.logmanager" ]
}

@test "generate_jboss_modules_system_pkgs: JDK 7 includes org.jboss.logmanager" {
  JAVA_VERSION="1.7.0"
  result=$(generate_jboss_modules_system_pkgs)
  [ $result = "jdk.nashorn.api,com.sun.crypto.provider,org.jboss.logmanager" ]
}

@test "generate_jboss_modules_system_pkgs: JDK 8 includes org.jboss.logmanager" {
  JAVA_VERSION="1.8.0"
  result=$(generate_jboss_modules_system_pkgs)
  [ $result = "jdk.nashorn.api,com.sun.crypto.provider,org.jboss.logmanager" ]
}

@test "generate_jboss_modules_system_pkgs: JDK 11 does not include org.jboss.logmanager" {
  JAVA_VERSION="11.0"
  result=$(generate_jboss_modules_system_pkgs)
  echo $result
  [ $result = "jdk.nashorn.api,com.sun.crypto.provider" ]
}
