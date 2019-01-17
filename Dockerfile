FROM okdocker/pynode:3.6-10.x

LABEL name=django-mobans-lint-image \
      version=0.1 \
      maintainer="jayvdb@gmail.com"

RUN apt-get update \
  && apt-get install --no-install-recommends -y \
    git \
    shellcheck \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN \
  pip install --no-cache-dir 'git+https://github.com/coala/coala' && \
  pip install --no-cache-dir 'git+https://github.com/coala/coala-bears'

RUN npm install -g \
  dockerfile_lint \
  && npm cache clear --force

CMD ["coala", "--ci"]
