FROM ubuntu:18.04

RUN apt-get update && apt-get upgrade -y && apt-get autoremove && apt-get clean
RUN apt-get install -y htop curl git vim sudo tmux gnupg wget libcurl3-dev libpq-dev zlib1g-dev && apt-get autoremove && apt-get clean

ENV PATH="/root/.rbenv/bin:$PATH"

# Rbenv
RUN curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash || true
RUN curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-doctor | bash || true

# Ruby
RUN apt-get install -y gcc g++ make libssl-dev libreadline-dev zlib1g-dev && apt-get autoremove && apt-get clean
RUN apt-get install -y bzip2 && apt-get autoremove && apt-get clean
RUN rbenv install 3.1.2

# Yarn
RUN curl -sL https://deb.nodesource.com/setup_16.x | sudo bash -
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get upgrade -y && apt-get install -y yarn && apt-get autoremove && apt-get clean

# Overmind
RUN curl -fsSL https://github.com/DarthSim/overmind/releases/download/v2.1.0/overmind-v2.1.0-linux-amd64.gz | gunzip > /usr/bin/overmind && chmod +x /usr/bin/overmind

# Chromedriver
RUN curl -fsSL https://chromedriver.storage.googleapis.com/91.0.4472.19/chromedriver_linux64.zip | gunzip > /usr/bin/chromedriver && chmod +x /usr/bin/chromedriver

# Chrome
RUN sh -c 'echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list'
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
RUN apt-get update && apt-get autoremove && apt-get clean
RUN apt-get install -y google-chrome-stable && apt-get autoremove && apt-get clean

# icu required (brew install icu4c or apt-get install libicu-dev) for gem charlock_holmes
RUN apt-get install -y libicu-dev && apt-get autoremove && apt-get clean

# Postgres
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get install -y postgresql
RUN echo 'host all  all    0.0.0.0/0  md5' >> /etc/postgresql/10/main/pg_hba.conf
RUN echo "listen_addresses = '*'" >> /etc/postgresql/10/main/postgresql.conf
RUN service postgresql start && sudo -u postgres psql -c " \
    create user tps_development with password 'tps_development' superuser; \
    create user tps_test with password 'tps_test' superuser; \
    "
    
# DS
RUN git clone https://github.com/betagouv/demarches-simplifiees.fr.git ds
WORKDIR /ds
RUN echo 'eval "$(rbenv init -)"' >> /root/.bashrc

CMD bash -c "service postgresql start ; while true; do sleep 1 ; done"