@test "Waiting for the container to be ready." {
  run sleep 5
  [ "${status}" -eq 0 ]
}

@test "Logging in and running a simple command." {
  run ssh -i id_rsa.priv -o Port=2222 -o "StrictHostKeyChecking no" root@localhost "id"
  [ "${status}" -eq 0 ]
}

@test "Logging in and checking CentOS Version." {
  run ssh -i id_rsa.priv -o Port=2222 -o "StrictHostKeyChecking no" root@localhost "grep 8 /etc/redhat-release"
  [ "${status}" -eq 0 ]
}

@test "Logging in and checking root filesystem." {
  run ssh -i id_rsa.priv -o Port=2222 -o "StrictHostKeyChecking no" root@localhost "df -t overlay /"
  [ "${status}" -eq 0 ]
}

@test "Logging in and install lsof." {
  run ssh -i id_rsa.priv -o Port=2222 -o "StrictHostKeyChecking no" root@localhost "dnf -y install lsof"
  [ "${status}" -eq 0 ]
}

@test "Logging in and using rpm to remove lsof." {
  run ssh -i id_rsa.priv -o Port=2222 -o "StrictHostKeyChecking no" root@localhost "rpm -e lsof"
  [ "${status}" -eq 0 ]
}

@test "Installing epel-release." {
  run ssh -i id_rsa.priv -o Port=2222 -o "StrictHostKeyChecking no" root@localhost "dnf -y install epel-release"
  [ "${status}" -eq 0 ]
}

@test "Killing the container with CTRL and C." {
  run sudo kill -SIGINT $(docker inspect --format='{{.State.Pid}}' $(docker ps -ql))
  [ "${status}" -eq 0 ]
}

@test "Waiting for the container to stop." {
  run sleep 10
}

@test "Checking if container is killed." {
  result=$(docker ps | grep docker-centos-openssh | wc -l | bc)
  [ "${result}" -eq 0 ]
}
