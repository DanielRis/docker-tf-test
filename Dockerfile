FROM golang:1.12-alpine

# Install build packages
RUN apk add --no-cache build-base make bash git openssh curl dep

# Install TFLINT
RUN wget -O /tmp/tflint.zip https://github.com/wata727/tflint/releases/download/v0.10.3/tflint_linux_amd64.zip; \
    unzip /tmp/tflint.zip -d /tmp; \
    install -v /tmp/tflint /usr/local/bin; \
    rm /tmp/tflint.zip && rm /tmp/tflint

# Install TFENV
RUN git clone https://github.com/tfutils/tfenv.git ~/.tfenv; \
    ln -s ~/.tfenv/bin/* /usr/local/bin

# Install Terratest
## Log Parser
RUN wget -O /tmp/terratest_log_parser https://github.com/gruntwork-io/terratest/releases/download/v0.13.13/terratest_log_parser_linux_amd64; \
    chmod +x /tmp/terratest_log_parser; \
    mv /tmp/terratest_log_parser /usr/local/bin

## Install Terratest dependencies
RUN mkdir -p $GOPATH/src/terratest/test
COPY files/Gopkg.lock $GOPATH/src/terratest/test
COPY files/Gopkg.toml $GOPATH/src/terratest/test
COPY files/basic_test.go $GOPATH/src/terratest/test
RUN cd $GOPATH/src/terratest/test; \
    dep ensure -v --vendor-only

# Install terraform-compliance
RUN apk add --no-cache python3
RUN pip3 install --upgrade --no-cache pip
RUN pip3 install --no-cache terraform-compliance
