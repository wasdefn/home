#!/usr/bin/env bash

function main {
  # link cache files
  if [[ -d /vagrant ]]; then
    ln -nfs /vagrant/{distfiles,cache,packages} ~/
  fi

  # make sure we are at home
  set -x
  cd

  # initialize new ssh hosts
  ssh -oStrictHostKeyChecking=no github.com true
  ssh -oStrictHostKeyChecking=no bitbucket.org true
  ssh -oStrictHostKeyChecking=no localhost true

  # clone home
  git clone git@github.com:defn/home home
  mv home/.git .
  git reset --hard
  git clean -fd

  # bootstrap app
  git clone git@github.com:defn/app work/app
  pushd work/app
  set +x; source script/profile; set -x
  app bootstrap
  popd

  # bootstrap home
  script/bootstrap
  set +x; require; set -x

  # bootstrap pkgsrc
  script/bootstrap pkgsrc || true

  # bootstrap everything
  app bootstrap
}

main "$@"
