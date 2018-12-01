
function prepareEnv() {
  unset JBOSS_MODULES_SYSTEM_PKGS_APPEND
}

function configure() {
  configure_jboss_modules_system_pkgs
}

function configure_jboss_modules_system_pkgs() {
  JBOSS_MODULES_SYSTEM_PKGS=$(generate_jboss_modules_system_pkgs)
}

generate_jboss_modules_system_pkgs() {
  local system_pkgs="jdk.nashorn.api,com.sun.crypto.provider"

  # org.jboss.logmanager can't work as an -Xbootclasspath/a + system package on JDK 9 or later
  if [ -z ${JAVA_VERSION} ] || echo ${JAVA_VERSION} | grep -q "1\.[0-8]\.[0-9]"; then
    system_pkgs="${system_pkgs},org.jboss.logmanager"
  fi

  if [ -n "$JBOSS_MODULES_SYSTEM_PKGS_APPEND" ]; then
    system_pkgs="${system_pkgs},$JBOSS_MODULES_SYSTEM_PKGS_APPEND"
  fi

  echo $system_pkgs
}
