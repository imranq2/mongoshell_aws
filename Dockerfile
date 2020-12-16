FROM debian:stable

# https://docs.mongodb.com/manual/tutorial/install-mongodb-on-debian/

# Install required gnupg package
RUN apt-get update && apt-get -y install gnupg wget

# Install required ca-certificates to prevent the error in the certificate verification
RUN apt-get -y install ca-certificates && update-ca-certificates

RUN wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | apt-key add -
RUN echo "deb http://repo.mongodb.org/apt/debian buster/mongodb-org/4.4 main" | tee /etc/apt/sources.list.d/mongodb-org-4.4.list

RUN apt-get update

# Install the MongoDB packages
RUN apt-get -y install mongodb-org-shell
RUN apt-get -y install mongodb-org-tools