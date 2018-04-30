#
#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#
#

FROM  streamsets/datacollector:3.2.0.0-RC2
MAINTAINER Kong <kochan@pivotal.io>

# The paths below should generally be attached to a VOLUME for persistence.
# SDC_CONF is where configuration files are stored. This can be shared.
# SDC_DATA is a volume for storing collector state. Do not share this between containers.
# SDC_LOG is an optional volume for file based logs.
# SDC_RESOURCES is where resource files such as runtime:conf resources and Hadoop configuration can be placed.
# STREAMSETS_LIBRARIES_EXTRA_DIR is where extra libraries such as JDBC drivers should go.

ENV SDC_EXTRA_LIBS="streamsets-datacollector-jdbc-lib,streamsets-datacollector-apache-kafka_1_0-lib"
ARG SDC_USER=sdc


USER root
RUN apk add --no-cache wget curl
RUN cd /tmp \
    && wget -O postgresql-42.2.2.jar https://jdbc.postgresql.org/download/postgresql-42.2.2.jar \
    && mkdir -p ${STREAMSETS_LIBRARIES_EXTRA_DIR} \
    && cp /tmp/postgresql-42.2.2.jar ${STREAMSETS_LIBRARIES_EXTRA_DIR}

RUN ${SDC_DIST}/bin/streamsets stagelibs -list
RUN ${SDC_DIST}/bin/streamsets stagelibs -install=${SDC_EXTRA_LIBS}

COPY ./docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
# Setup filesystem permissions.
RUN chown -R "${SDC_USER}:${SDC_USER}" "${SDC_DIST}/streamsets-libs" \
        "${SDC_CONF}" \
        "${SDC_DATA}" \
        "${SDC_LOG}" \
        "${SDC_RESOURCES}" \
        "${STREAMSETS_LIBRARIES_EXTRA_DIR}" \
        /docker-entrypoint.sh

USER ${SDC_USER}
EXPOSE 18630

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["dc", "-exec"]
