FROM ruby:2.6-slim

WORKDIR /srv/slate

EXPOSE 4567

COPY Gemfile .
COPY Gemfile.lock .

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        git \
        nodejs \
    && gem install bundler \
    && bundle install \
    && apt-get remove -y build-essential git \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*
    RUN source /usr/local/rvm/scripts/rvm && rvm install 2.6 && rvm use 2.6 --default

COPY . /srv/slate
ENV NIXPACKS_PATH=/usr/local/rvm/rubies/ruby-2.6/bin:/usr/local/rvm/gems/ruby-2.6/bin:/usr/local/rvm/gems/ruby-2.6@global/bin:$NIXPACKS_PATH

RUN chmod +x /srv/slate/slate.sh

ENTRYPOINT ["/srv/slate/slate.sh"]
CMD ["build"]
