O QUE É O TERRAFORM E PARA QUE SERVE
Terraform é uma ferramenta de Infraestrutura como Código (IaC). Serve para automatizar a criação, alteração e destruição de recursos em provedores de nuvem (neste caso, AWS) através de código, substituindo a necessidade de criar servidores e redes manualmente pelo painel da AWS.

COMO USAR (APÓS O GIT PULL)

1. Atualize as credenciais da AWS
Como você utiliza ambiente de laboratório, suas credenciais expiram. Copie as novas chaves (Access Key, Secret Key e Session Token) do portal do laboratório e cole no seu arquivo ~/.aws/credentials ou exporte no seu terminal.

2. Inicialize o Terraform
Baixa os plugins essenciais (provider da AWS e módulo de rede). Rode apenas uma vez na máquina:

terraform init

4. Verifique o plano (Opcional, mas recomendado)
Exibe um resumo de todos os recursos que serão criados na nuvem.

terraform plan

6. Crie a infraestrutura
Aplica o código e sobe as máquinas e a rede na AWS. O console vai pausar; digite 'yes' e dê Enter para confirmar. (No final, o terminal exibirá o link DNS do Load Balancer para você acessar a aplicação).

terraform apply

8. Destrua a infraestrutura após o uso
Apaga tudo o que foi criado para evitar o consumo de créditos/limites do laboratório. Digite 'yes' para confirmar.

terraform destroy
