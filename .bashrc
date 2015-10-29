function configure_cue {
  : ${SHLVL_INITIAL:=0}
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

function bootstraprc {
  source "$shome/script/profile"
}

function bashrc {
  local shome="$(cd -P -- "$(dirname "${BASH_SOURCE}")" && pwd -P)"

  if [[ -z "${REQUIRE:-}" ]]; then
    export REQUIRE=1

    if [[ -f "$shome/.bashrc.app" ]]; then
      source "$shome/.bashrc.app"
    else
      bootstraprc
      require
    fi
  else
    bootstraprc
  fi

  configure_cue
}

bashrc || echo WARNING: "Something's wrong with .bashrc"
