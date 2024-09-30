FROM python:3.11-slim-bullseye

WORKDIR /project

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y curl unzip vim groff less make jq zip

RUN mkdir /root/.aws/

# コマンド追加
RUN echo "alias ta='terraform apply -auto-approve'" >> ~/.bashrc
RUN echo "alias tp='terraform plan'" >> ~/.bashrc
RUN echo "alias ti='terraform init'" >> ~/.bashrc
RUN echo "alias td='terraform destroy -auto-approve'" >> ~/.bashrc
# RUN echo "alias tf_st='terraform state list'" >> ~/.bashrc
# RUN echo "alias tf_sh='terraform show'" >> ~/.bashrc
# RUN echo "alias tf_co='terraform console'" >> ~/.bashrc
# RUN echo "alias tf_mv='terraform mv'" >> ~/.bashrc
# RUN echo "alias tf_va='terraform validate'" >> ~/.bashrc
RUN echo "alias sl='aws sso login --profile aws-admin'" >> ~/.bashrc

# aws-cliのインストール
ARG AWSCLI_VERSION="2.17.12"
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-2.17.12.zip" -o "/tmp/awscliv2.zip"
RUN unzip -o /tmp/awscliv2.zip -d /tmp
RUN /tmp/aws/install
RUN rm -rf /tmp/aws /tmp/awscliv2.zip

# Session Manager Pluginをダウンロードしてインストール
ARG SESSION_MANAGER_PLUGIN_VERSION="1.2.650.0"
RUN curl "https://s3.amazonaws.com/session-manager-downloads/plugin/${SESSION_MANAGER_PLUGIN_VERSION}/ubuntu_64bit/session-manager-plugin.deb" -o "/tmp/session-manager-plugin.deb"
RUN dpkg -i /tmp/session-manager-plugin.deb
RUN rm /tmp/session-manager-plugin.deb

# teraformのインストール
ARG TERRAFORM_VERSION="1.8.0"
RUN curl "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" -o "/tmp/terraform.zip"
RUN unzip /tmp/terraform.zip -d /tmp
RUN mv /tmp/terraform /usr/local/bin/
RUN rm /tmp/terraform.zip

# tflintのインストール
ARG TFLINT_VERSION="0.52.0"
RUN curl -L "https://github.com/terraform-linters/tflint/releases/download/v${TFLINT_VERSION}/tflint_linux_amd64.zip" -o "/tmp/tflint.zip"
RUN unzip /tmp/tflint.zip -d /tmp
RUN mv /tmp/tflint /usr/local/bin/
RUN rm /tmp/tflint.zip

# # terraformerのインストール
# # 必要ない場合は消す
# ARG PROVIDER=aws
# RUN curl -LO "https://github.com/GoogleCloudPlatform/terraformer/releases/download/$(curl -s https://api.github.com/repos/GoogleCloudPlatform/terraformer/releases/latest | grep tag_name | cut -d '"' -f 4)/terraformer-${PROVIDER}-linux-amd64"
# RUN chmod +x terraformer-${PROVIDER}-linux-amd64
# RUN mv terraformer-${PROVIDER}-linux-amd64 /usr/local/bin/terraformer

# # samのインストール
# ARG SAM_VERSION="latest"
# RUN curl -L "https://github.com/aws/aws-sam-cli/releases/${SAM_VERSION}/download/aws-sam-cli-linux-x86_64.zip" -o "/tmp/sam.zip"
# RUN unzip /tmp/sam.zip -d /tmp/sam
# RUN /tmp/sam/install
# RUN rm /tmp/sam.zip
# RUN rm -rf /tmp/sam
