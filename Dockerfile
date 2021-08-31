# Base image, make sure that the Ruby version is compatible with the version in your Gemfile.
FROM ruby:3.0.1-alpine

# Install dependencies needed for the app and delete the packages after installed.
  RUN apk add --update --no-cache  --virtual run-dependencies \
  build-base \
  postgresql-client \
  postgresql-dev \
  yarn \
  git \
  tzdata \
  libpq \
  && rm -rf /var/cache/apk/*

# Create a directory inside the container for the project.
WORKDIR /docker-rails

# Set the folder to where install ruby gems
ENV BUNDLE_PATH /gems

# Install yarn and bundle dependencies
COPY package.json yarn.lock /docker-rails/
RUN yarn install
COPY Gemfile Gemfile.lock /docker-rails/
RUN bundle install

# Copy source code after dependencies installed
COPY . /docker-rails/

# Set the command that runs when the docker image is started
ENTRYPOINT ["bin/rails"]
CMD ["s", "-b", "0.0.0.0"]

# Expose the port that rails uses
EXPOSE 3000
