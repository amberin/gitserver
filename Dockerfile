FROM alpine:latest
RUN apk update && apk --no-cache add openssh shadow git
RUN adduser --disabled-password --uid 10000 --shell /usr/bin/git-shell user
RUN usermod -p '*' user
# Add symlink to allow shorter ssh:// URL:
RUN ln -s /home/user/git/repo.git /repo
EXPOSE 2222
USER user
WORKDIR /home/user
RUN mkdir hostkeys .ssh git
RUN chmod 0700 .ssh
COPY --chown=user ./run.sh .
COPY --chown=user ./sshd_config .
RUN chmod +x run.sh
CMD ["./run.sh"]
