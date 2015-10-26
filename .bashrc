function configure_cue {
  require cue

  function guess_scheme {
    echo "${CUE_SCHEME:-${ITERM_PROFILE:-sdark}}"
  }

  : ${CUE_SCHEME:="$(cat ~/.cue-scheme 2>&- || true)"}
  export CUE_SCHEME
  case "$(guess_scheme)" in
    slight) slight || true ;;
    *)      sdark  || true ;;
  esac
}

function configure_tty {
  if tty 2>&- > /dev/null; then
    set +efu
  fi
}

function bashrc {
  local shome="$(cd -P -- "${BASH_SOURCE%/*}" && pwd -P)"

  source "$shome/.profile.d/app.pre"
  source "$APP_PATH/jq/script/profile"
  source "$APP_PATH/app/script/profile"

  if [[ -z "${REQUIRE:-}" ]]; then
    if [[ -f "$shome/.bashrc.app" ]]; then
      time source "$shome/.bashrc.app"
    else
      time require
    fi
    export REQUIRE=1
  fi

  configure_cue
  configure_tty
}

bashrc || echo WARNING: "Something's wrong with .bashrc"
