#Docker para la App
FROM tundervirld/ruby-2.6.4:new-app-rails-5.2

LABEL author="R3M"

# # Add a script to be executed every time the container starts.
COPY docker-entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]
