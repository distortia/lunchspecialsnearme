FROM node:4.6
# Install yarn from the local .tgz
RUN mkdir -p /opt
ADD latest.tar.gz /opt/
RUN mv /opt/dist /opt/yarn
ENV PATH "$PATH:/opt/yarn/bin"
# Updates and installs
RUN apt-get update \
  && apt-get install -y postgresql postgresql-contrib \
  && apt-get install sudo \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && mkdir -p /app
# Set up working directory
WORKDIR /app
COPY . /app
# Get postgres ready and install node modules for execution
RUN /etc/init.d/postgresql start # starting the service \
&& sudo -u postgres sh -c 'createuser postgres & createdb alphaity_dev' # creating a root user \
&& sudo -u postgres psql -c "ALTER USER postgres PASSWORD 'postgres';" # setting up the root password \
&& yarn install \
&& echo "module.exports = {development: {client: 'postgresql', connection: {user : 'postgres', password: 'yourpasswordforthisuser', database: 'alphaity_dev'}}}" > knexfile.js

EXPOSE 3000
CMD [ "yarn", "run", "watch"]