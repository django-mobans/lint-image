FROM opensuse/tumbleweed

LABEL name=django-mobans-lint-image \
      version=0.1 \
      maintainer="jayvdb@gmail.com"

RUN \
  # Remove unnecessary repos to avoid refreshes
  zypper removerepo 'http://download.opensuse.org/tumbleweed/repo/non-oss/' && \
  # Package dependencies
  echo 'Running zypper install ...' && \
  (time zypper -vv --no-gpg-checks --non-interactive \
    --plus-repo http://download.opensuse.org/repositories/devel:languages:python/openSUSE_Tumbleweed/ \
    --plus-repo http://download.opensuse.org/repositories/home:jayvdb:coala/openSUSE_Tumbleweed/ \
    install --replacefiles --download-in-advance \
        coala \
        nltk-data-averaged_perceptron_tagger \
        nltk-data-punkt \
        python3-coala-bears \
        python3-autoflake \
        python3-autopep8 \
        python3-eradicate \
        python3-git-url-parse \
        python3-nltk \
        python3-pyflakes \
        python3-yamllint \
        git-core \
        ShellCheck \
        "python=3.7" \
        nodejs10 \
        npm10 \
      > /tmp/zypper.out \
    || (cat /tmp/zypper.out && false)) \
    && \
  grep -E '(new packages to install|^Retrieving: )' /tmp/zypper.out \
    && \
  # Clear zypper cache
  time zypper clean -a && \
  find /tmp -mindepth 1 -prune -exec rm -rf '{}' '+'

RUN npm install -g \
  dockerfile_lint \
  && npm cache clear --force

CMD ["coala", "--ci"]
