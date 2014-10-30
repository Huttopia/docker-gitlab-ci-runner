FROM jpetazzo/dind
MAINTAINER informatique@huttopia.fr

RUN apt-get update
RUN apt-get install --yes software-properties-common python-software-properties
RUN add-apt-repository -y ppa:git-core/ppa && \
    add-apt-repository -y ppa:brightbox/ruby-ng && \
    apt-get update && \
    apt-get install -y build-essential checkinstall \
      git-core zlib1g-dev libyaml-dev libssl-dev \
      libgdbm-dev libreadline-dev libncurses5-dev libffi-dev \
      libxml2-dev libxslt-dev libcurl4-openssl-dev libicu-dev \
      ruby2.1 ruby2.1-dev openssh-client && \
    gem install --no-ri --no-rdoc bundler && \
    rm -rf /var/lib/apt/lists/* # 20140818

# Droits sudo sans password pour gitlab_ci_runner
RUN chmod 755 /etc/sudoers
RUN echo "gitlab_ci_runner ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

ADD assets/setup/ /app/setup/
RUN chmod 755 /app/setup/install
RUN /app/setup/install

ADD assets/init /app/init
RUN chmod 755 /app/init

VOLUME ["/home/gitlab_ci_runner/data"]

ENTRYPOINT ["/app/init"]
CMD wrapdocker && app:start