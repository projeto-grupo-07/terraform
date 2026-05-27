-- ==================================================================
-- SCRIPT DE CARGA - BRINKS CALÇADOS
-- CRIA AS TABELAS (IF NOT EXISTS) E POPULA COM OS DADOS
-- ==================================================================

SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;

-- -------------------------
-- 1) CRIAÇÃO DAS TABELAS
-- -------------------------
CREATE TABLE IF NOT EXISTS endereco (
  id INT PRIMARY KEY AUTO_INCREMENT,
  cep VARCHAR(255),
  estado VARCHAR(255),
  cidade VARCHAR(255),
  bairro VARCHAR(255),
  logradouro VARCHAR(255),
  numero INT,
  complemento VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS tela (
  id INT PRIMARY KEY AUTO_INCREMENT,
  titulo VARCHAR(255),
  path VARCHAR(255),
  component_key VARCHAR(255),
  ordem INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS perfil (
  id INT PRIMARY KEY AUTO_INCREMENT,
  nome VARCHAR(255) NOT NULL,
  descricao VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS perfil_tela (
  perfil_id INT NOT NULL,
  tela_id INT NOT NULL,
  PRIMARY KEY (perfil_id, tela_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS funcionario (
  id INT PRIMARY KEY AUTO_INCREMENT,
  nome VARCHAR(255),
  cpf VARCHAR(255),
  salario DECIMAL(10,2),
  email VARCHAR(255),
  comissao DECIMAL(10,2),
  senha VARCHAR(255),
  perfil_id INT,
  ativo BOOLEAN
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS categoria (
  id INT PRIMARY KEY AUTO_INCREMENT,
  descricao VARCHAR(255),
  fk_pai INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS produto (
  id INT PRIMARY KEY AUTO_INCREMENT,
  quantidade INT,
  valor_unitario DECIMAL(10,2),
  preco_custo DECIMAL(10,2),
  fk_categoria INT,
  ativo BOOLEAN,
  nome VARCHAR(255),
  descricao VARCHAR(1024),
  marca VARCHAR(255),
  modelo VARCHAR(255),
  numero INT,
  cor VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS cliente (
  id INT PRIMARY KEY AUTO_INCREMENT,
  nome VARCHAR(255),
  dt_nasc DATE,
  email VARCHAR(255),
  genero CHAR(1),
  telefone VARCHAR(255),
  cpf VARCHAR(255),
  endereco_id INT,
  dt_cadastro DATE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS campanha (
  id INT PRIMARY KEY AUTO_INCREMENT,
  nome VARCHAR(255),
  assunto VARCHAR(255),
  corpo_texto TEXT,
  status VARCHAR(50)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS campanha_cliente (
  campanha_id INT NOT NULL,
  cliente_id INT NOT NULL,
  PRIMARY KEY (campanha_id, cliente_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS venda (
  id INT PRIMARY KEY AUTO_INCREMENT,
  data_hora DATETIME,
  forma_pagamento VARCHAR(50),
  valor_total DECIMAL(10,2),
  fk_vendedor INT,
  fk_cliente INT,
  percentual_comissao_aplicado DECIMAL(10,2),
  valor_comissao DECIMAL(10,2)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS itens_venda (
  id INT PRIMARY KEY AUTO_INCREMENT,
  fk_produto INT,
  fk_venda INT,
  quantidade_venda_produto INT,
  valor_desconto DECIMAL(10,2),
  valor_total_venda_produto DECIMAL(10,2),
  preco_unitario_na_venda DECIMAL(10,2)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS comissao (
  id_comissao INT PRIMARY KEY AUTO_INCREMENT,
  valor_comissao DECIMAL(10,2),
  data_venda DATETIME,
  fkVenda INT,
  fkFuncionario INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS pagamento_comissao (
  id INT PRIMARY KEY AUTO_INCREMENT,
  fk_vendedor INT,
  data_pagamento DATETIME,
  valor DECIMAL(10,2),
  observacao VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -------------------------
-- 2) TRUNCATE (limpa antes de popular)
-- -------------------------
SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE itens_venda;
TRUNCATE TABLE pagamento_comissao;
TRUNCATE TABLE comissao;
TRUNCATE TABLE venda;
TRUNCATE TABLE campanha_cliente;
TRUNCATE TABLE campanha;
TRUNCATE TABLE cliente;
TRUNCATE TABLE produto;
TRUNCATE TABLE categoria;
TRUNCATE TABLE funcionario;
TRUNCATE TABLE perfil_tela;
TRUNCATE TABLE perfil;
TRUNCATE TABLE tela;
TRUNCATE TABLE endereco;

SET FOREIGN_KEY_CHECKS = 1;

-- -------------------------
-- 3) POPULAÇÃO (seu conteúdo)
-- -------------------------

-- 1. ENDEREÇOS
INSERT INTO endereco (id, cep, estado, cidade, bairro, logradouro, numero, complemento) VALUES
(1, '01001-000', 'SP', 'São Paulo', 'Sé', 'Praça da Sé', 100, 'Bloco A'),
(2, '20000-000', 'RJ', 'Rio de Janeiro', 'Centro', 'Av Rio Branco', 200, 'Apto 12'),
(3, '30000-000', 'MG', 'Belo Horizonte', 'Savassi', 'Rua Pernambuco', 300, NULL),
(4, '04000-000', 'SP', 'São Paulo', 'Vila Mariana', 'Rua Vergueiro', 400, 'Casa 2'),
(5, '80000-000', 'PR', 'Curitiba', 'Batel', 'Av Batel', 500, NULL),
(6, '90000-000', 'RS', 'Porto Alegre', 'Moinhos de Vento', 'Rua Padre Chagas', 600, 'Sala 4'),
(7, '40000-000', 'BA', 'Salvador', 'Pelourinho', 'Largo do Pelourinho', 700, NULL),
(8, '50000-000', 'PE', 'Recife', 'Boa Viagem', 'Av Boa Viagem', 800, 'Apto 101'),
(9, '70000-000', 'DF', 'Brasília', 'Asa Sul', 'SQS 101', 900, 'Bloco B');

-- 2. TELAS
INSERT INTO tela (id, titulo, path, component_key, ordem) VALUES
(1, 'Painel de Vendas', '/painel-vendas', 'PAINEL_VENDAS_PAGE', 0),
(2, 'Vendas', '/vendas', 'VENDAS_PAGE', 1),
(3, 'Produtos', '/produtos', 'PRODUTOS_PAGE', 2),
(4, 'Funcionários', '/funcionarios', 'FUNCIONARIOS_PAGE', 3),
(5, 'Comissão', '/comissao', 'COMISSAO_PAGE', 4),
(6, 'Desempenho', '/desempenho', 'DESEMPENHO_PAGE', 5),
(7, 'Estratégica', '/estrategica', 'ESTRATEGICA_PAGE', 6),
(8, 'Campanha', '/campanha', 'CAMPANHA_PAGE', 7),
(9, 'Clientes', '/clientes', 'CLIENTES_PAGE', 8);

-- 3. PERFIS
INSERT INTO perfil (id, nome, descricao) VALUES
(1, 'ADMIN', 'Acesso total ao sistema'),
(2, 'GERENTE', 'Gestão de loja e relatórios'),
(3, 'VENDEDOR', 'Acesso apenas ao PDV e Vendas');

INSERT INTO perfil_tela (perfil_id, tela_id) VALUES
(1,1),(1,2),(1,3),(1,4),(1,5),(1,6),(1,7),(1,8),(1,9),
(2,1),(2,2),(2,3),(2,4),(2,5),(2,6),(2,7),(2,8),(2,9),
(3,1),(3,2);

-- 4. FUNCIONÁRIOS
INSERT INTO funcionario (id, nome, cpf, salario, email, comissao, senha, perfil_id, ativo) VALUES
(1, 'Maria Admin',    '116.580.380-10', 8000.00, 'maria.admin@brinks.com',    0.00, '$2a$10$wvjZNbqbmybP4DTXgRvNLeVcAcWo3im2C2XogDRy5aNpQi2G7hZSi', 1, TRUE),
(2, 'Agenor Gerente', '188.116.470-53', 5000.00, 'agenor.gerente@brinks.com', 0.10, '$2a$10$wvjZNbqbmybP4DTXgRvNLeVcAcWo3im2C2XogDRy5aNpQi2G7hZSi', 2, TRUE),
(3, 'Ana Vendedora',  '864.793.360-54', 2000.00, 'ana.vendas@brinks.com',     0.05, '$2a$10$wvjZNbqbmybP4DTXgRvNLeVcAcWo3im2C2XogDRy5aNpQi2G7hZSi', 3, TRUE),
(4, 'Roberto Vendas', '234.567.890-12', 2000.00, 'roberto.vendas@brinks.com', 0.05, '$2a$10$wvjZNbqbmybP4DTXgRvNLeVcAcWo3im2C2XogDRy5aNpQi2G7hZSi', 3, TRUE),
(5, 'Juliana Caixa',  '987.654.321-00', 2000.00, 'juliana.vendas@brinks.com', 0.05, '$2a$10$wvjZNbqbmybP4DTXgRvNLeVcAcWo3im2C2XogDRy5aNpQi2G7hZSi', 3, TRUE);

-- 5. CATEGORIAS
INSERT INTO categoria (id, descricao, fk_pai) VALUES
(1, 'Calçados', NULL),
(2, 'Outros', NULL),
(3, 'Tênis Esportivo', 1),
(4, 'Tênis Casual', 1),
(5, 'Sandália', 1),
(6, 'Chinelo', 1),
(7, 'Bota', 1),
(8, 'Sapato Social', 1),
(9, 'Chuteira', 1),
(10, 'Acessórios', 2),
(11, 'Meias', 2),
(12, 'Mochilas', 2);

ALTER TABLE categoria AUTO_INCREMENT = 20;

-- 6. PRODUTOS
INSERT INTO produto (
    id, quantidade, valor_unitario, preco_custo, fk_categoria, ativo,
    nome, descricao, marca, modelo, numero, cor
) VALUES
(1, 100, 29.90, 14.50, 6, TRUE,  'Chinelo Havaianas Top',       'Chinelo tradicional de borracha, confortável para o uso diário.', 'Havaianas', 'Top Clássico', 38, 'Azul'),
(2, 50,  399.90, 195.00, 3, TRUE, 'Tênis Nike Revolution 6',     'Tênis de corrida leve e respirável com amortecimento macio.',       'Nike',      'Revolution 6', 42, 'Preto'),
(3, 20,  799.90, 450.00, 3, TRUE, 'Tênis Adidas Ultraboost 22',  'Tênis de alta performance com retorno de energia excepcional.',     'Adidas',    'Ultraboost 22', 40, 'Branco'),
(4, 35,  149.90, 60.00,  5, TRUE, 'Sandália Vizzano Salto Fino', 'Sandália elegante com salto fino e fechamento ajustável.',          'Vizzano',   'Salto Fino', 37, 'Bege'),
(5, 15,  249.90, 120.00, 7, TRUE, 'Bota Coturno Dakota',         'Coturno robusto com sola tratorada e acabamento resistente.',       'Dakota',    'Coturno Tratorado', 36, 'Preto'),
(6, 25,  229.90, 110.00, 8, TRUE, 'Sapato Social Pegada Couro',  'Sapato social masculino em couro legítimo, design clássico.',       'Pegada',    'Social Couro', 41, 'Marrom'),
(7, 40,  499.90, 200.00, 3, TRUE, 'Tênis Mizuno Wave Titan',     'Tênis esportivo com placa Wave para maior estabilidade.',           'Mizuno',    'Wave Titan', 43, 'Cinza'),
(8, 30,  349.90, 180.00, 9, TRUE, 'Chuteira Puma Future Match',   'Chuteira de campo para máximo controle de bola.',                   'Puma',      'Future Match', 39, 'Laranja'),
(9, 60,  229.90, 100.00, 4, TRUE, 'Tênis Converse Chuck Taylor', 'O clássico tênis de lona unissex com cano baixo.',                  'Converse',  'Chuck Taylor', 38, 'Branco'),
(10, 45, 379.90, 180.00, 4, TRUE, 'Tênis Vans Old Skool',        'Tênis casual de lona e camurça com a icônica sidestripe.',          'Vans',      'Old Skool', 40, 'Preto'),
(11, 200, 39.90, 15.00,  11, TRUE, 'Kit 3 Pares de Meia Lupo',   'Meias esportivas de algodão com cano médio.',                       'Lupo',      'Kit 3 Pares', 40, 'Branca'),
(12, 50,  79.90, 35.00,  10, TRUE, 'Cinto Masculino Fasolo Couro','Cinto social masculino confeccionado em couro legítimo.',           'Fasolo',    'Cinto Couro', 100, 'Preto'),
(13, 20,  179.90, 80.00, 12, TRUE, 'Mochila Nike Brasilia JDI',   'Mochila compacta com compartimento principal espaçoso.',           'Nike',      'Brasilia JDI', 0, 'Preto'),
(14, 80,  119.90, 45.00,  6, TRUE, 'Sandália Kenner Rakuka',      'Sandália com palmilha extra macia e solado de borracha.',           'Kenner',    'Rakuka', 41, 'Vermelho'),
(15, 18,  329.90, 160.00, 7, TRUE, 'Bota Chelsea Democrata',      'Bota masculina premium com elástico lateral para fácil calce.',     'Democrata', 'Chelsea', 42, 'Marrom');

ALTER TABLE produto AUTO_INCREMENT = 20;

-- 7. CLIENTES
INSERT INTO cliente (id, nome, dt_nasc, email, genero, telefone, cpf, endereco_id, dt_cadastro) VALUES
(1, 'João Souza',        '1985-08-22', 'joao.souza@email.com',        'M', '11988882222', '22233344455', 2, '2026-02-15'),
(2, 'Ana Costa',         '1995-12-05', 'ana.costa@email.com',         'F', '21977773333', '33344455566', 3, '2026-03-20'),
(3, 'Pedro Oliveira',    '1988-05-10', 'pedro.oliveira@email.com',    'M', '31966664444', '44455566677', 4, '2026-04-05'),
(4, 'Alex Santos',       '2000-01-30', 'alex.santos@email.com',       'O', '41955555555', '55566677788', 5, '2026-04-25'),
(5, 'Carla Dias',        '1992-05-20', 'carla.dias@email.com',        'F', '51944446666', '66677788899', NULL, '2026-05-01'),
(6, 'Marcos Lima',       '1978-10-12', 'marcos.lima@email.com',       'M', '61933337777', '77788899900', 6, '2026-05-10'),
(7, 'Juliana Mendes',    '1999-02-28', 'juliana.mendes@email.com',    'F', '71922228888', '88899900011', 7, '2026-05-15'),
(8, 'Lucas Fernandes',   '1982-07-07', 'lucas.fernandes@email.com',   'M', '81911119999', '99900011122', 8, '2026-05-17'),
(9, 'Sam Ribeiro',       '1996-05-01', 'sam.ribeiro@email.com',       'O', '91900000000', NULL,            9, '2026-05-18');

-- 8. CAMPANHAS
INSERT INTO campanha (id, nome, assunto, corpo_texto, status) VALUES
(1, 'Campanha Dia das Mães', 'Promoção especial para Dia das Mães', 'Mensagem promocional de Dia das Mães.', 'INICIADA'),
(2, 'Black Friday', 'Ofertas imperdíveis Black Friday', 'Mensagem promocional Black Friday.', 'EM_ANDAMENTO'),
(3, 'Natal 2025', 'Presentes e descontos de Natal', 'Mensagem promocional Natal.', 'CONCLUIDA'),
(4, 'Volta às Aulas', 'Descontos para volta às aulas', 'Mensagem promocional volta às aulas.', 'PENDENTE');

INSERT INTO campanha_cliente (campanha_id, cliente_id) VALUES
(1,1),(1,2),(1,4),
(2,1),(2,3),(2,5),(2,6),
(3,2),(3,4),(3,7),
(4,1),(4,8),(4,9);

-- 9. VENDAS
INSERT INTO venda (
    id, data_hora, forma_pagamento, valor_total, fk_vendedor, fk_cliente,
    percentual_comissao_aplicado, valor_comissao
) VALUES
(1,  '2026-03-03 10:00:00', 'CREDITO',  629.80, 3, 1, 0.05, 31.49),
(2,  '2026-03-06 15:30:00', 'PIX',      459.80, 4, 2, 0.05, 22.99),
(3,  '2026-03-09 11:20:00', 'DEBITO',   839.80, 5, 3, 0.05, 41.99),
(4,  '2026-03-12 17:45:00', 'CREDITO',  509.70, 3, 4, 0.05, 25.49),
(5,  '2026-03-15 14:00:00', 'PIX',      229.80, 4, 5, 0.05, 11.49),
(6,  '2026-03-18 09:30:00', 'CREDITO',  729.80, 5, 6, 0.05, 36.49),
(7,  '2026-03-21 10:00:00', 'CREDITO',  759.80, 3, 7, 0.05, 37.99),
(8,  '2026-03-24 16:20:00', 'PIX',      609.80, 4, 8, 0.05, 30.49),
(9,  '2026-03-27 11:00:00', 'DEBITO',   149.90, 5, 9, 0.05, 7.50),
(10, '2026-03-30 14:00:00', 'CREDITO',  509.80, 3, 1, 0.05, 25.49),
(11, '2026-04-02 10:00:00', 'PIX',      349.90, 4, 2, 0.05, 17.50),
(12, '2026-04-05 18:30:00', 'CREDITO',  879.80, 5, 3, 0.05, 43.99),
(13, '2026-04-08 12:00:00', 'CREDITO',  609.80, 3, 4, 0.05, 30.49),
(14, '2026-04-11 15:00:00', 'PIX',      829.80, 4, 5, 0.05, 41.49),
(15, '2026-04-14 10:00:00', 'DINHEIRO', 419.80, 5, 6, 0.05, 20.99),
(16, '2026-04-17 11:00:00', 'DEBITO',   269.80, 3, 7, 0.05, 13.49),
(17, '2026-04-20 14:30:00', 'PIX',      579.80, 4, 8, 0.05, 28.99),
(18, '2026-04-23 16:00:00', 'CREDITO',  379.90, 5, 9, 0.05, 19.00),
(19, '2026-04-26 09:00:00', 'CREDITO',  649.80, 3, 1, 0.05, 32.49),
(20, '2026-04-28 13:00:00', 'PIX',      499.90, 4, 2, 0.05, 25.00),
(21, '2026-04-30 15:00:00', 'DEBITO',   309.80, 5, 3, 0.05, 15.49),
(22, '2026-05-02 17:00:00', 'CREDITO',  799.80, 3, 4, 0.05, 39.99),
(23, '2026-05-04 10:00:00', 'PIX',      269.80, 4, 5, 0.05, 13.49),
(24, '2026-05-06 14:00:00', 'CREDITO',  579.80, 5, 6, 0.05, 28.99),
(25, '2026-05-08 11:00:00', 'DEBITO',   459.80, 3, 7, 0.05, 22.99),
(26, '2026-05-10 16:00:00', 'PIX',      629.80, 4, 8, 0.05, 31.49),
(27, '2026-05-12 18:00:00', 'CREDITO',  879.80, 5, 9, 0.05, 43.99),
(28, '2026-05-14 10:00:00', 'CREDITO',  729.80, 3, 1, 0.05, 36.49),
(29, '2026-05-16 14:00:00', 'PIX',      349.80, 4, 2, 0.05, 17.49),
(30, '2026-05-18 08:30:00', 'PIX',       69.80, 3, 3, 0.05, 3.49),
(31, '2026-05-19 10:15:00', 'CREDITO',  609.80, 4, 4, 0.05, 30.49),
(32, '2026-05-20 13:00:00', 'DEBITO',   229.90, 5, 5, 0.05, 11.50),
(33, '2026-05-21 15:45:00', 'PIX',      779.80, 3, 6, 0.05, 38.99),
(34, '2026-05-22 17:20:00', 'DINHEIRO', 119.80, 4, 7, 0.05, 5.99),
(35, '2026-05-23 18:00:00', 'CREDITO',  409.80, 5, 8, 0.05, 20.49);

ALTER TABLE venda AUTO_INCREMENT = 50;

-- 10. ITENS_VENDA
INSERT INTO itens_venda (
    fk_produto, fk_venda, quantidade_venda_produto, valor_desconto,
    valor_total_venda_produto, preco_unitario_na_venda
) VALUES
(2,  1, 1, 0.00, 399.90, 399.90),
(1,  1, 2, 0.00,  59.80,  29.90),
(11, 1, 1, 0.00,  39.90,  39.90),
(9,  2, 2, 0.00, 459.80, 229.90),
(3,  3, 1, 0.00, 799.90, 799.90),
(11, 3, 1, 0.00,  39.90,  39.90),
(10, 4, 1, 0.00, 379.90, 379.90),
(1,  4, 3, 0.00,  89.70,  29.90),
(1,  5, 2, 0.00,  59.80,  29.90),
(12, 5, 1, 0.00,  79.90,  79.90),
(11, 5, 1, 10.00, 29.90,  39.90),
(7,  6, 1, 0.00, 499.90, 499.90),
(9,  6, 1, 0.00, 229.90, 229.90),
(10, 7, 1, 0.00, 379.90, 379.90),
(8,  7, 1, 0.00, 349.90, 349.90),
(9,  8, 1, 10.00, 219.90, 229.90),
(14, 8, 1, 0.00, 119.90, 119.90),
(11, 8, 1, 0.00,  39.90,  39.90),
(12, 8, 1, 0.00,  79.90,  79.90),
(4,  9, 1, 0.00, 149.90, 149.90),
(15, 10, 1, 0.00, 329.90, 329.90),
(13, 10, 1, 0.00, 179.90, 179.90),
(8, 11, 1, 0.00, 349.90, 349.90),
(3, 12, 1, 0.00, 799.90, 799.90),
(11,12, 1, 0.00,  39.90,  39.90),
(12,12, 1, 0.00,  79.90,  79.90),
(9, 13, 1, 0.00, 229.90, 229.90),
(13,13, 1, 0.00, 179.90, 179.90),
(12,13, 1, 0.00,  79.90,  79.90),
(11,13, 1, 0.00,  39.90,  39.90),
(7, 14, 1, 0.00, 499.90, 499.90),
(5, 14, 1, 0.00, 249.90, 249.90),
(14,15, 1, 0.00, 119.90, 119.90),
(12,15, 1, 0.00,  79.90,  79.90),
(4, 15, 1, 0.00, 149.90, 149.90),
(12,16, 1, 0.00,  79.90,  79.90),
(1, 16, 2, 0.00,  59.80,  29.90),
(11,16, 1, 0.00,  39.90,  39.90),
(14,16, 1, 20.00, 99.90, 119.90),
(6, 17, 1, 0.00, 229.90, 229.90),
(9, 17, 1, 10.00, 219.90, 229.90),
(11,17, 1, 0.00,  39.90,  39.90),
(1, 17, 3, 0.00,  89.70,  29.90),
(10,18, 1, 0.00, 379.90, 379.90),
(2, 19, 1, 0.00, 399.90, 399.90),
(12,19, 1, 0.00,  79.90,  79.90),
(11,19, 1, 0.00,  39.90,  39.90),
(1, 19, 2, 15.00, 44.80,  29.90),
(7, 20, 1, 0.00, 499.90, 499.90),
(4, 21, 1, 0.00, 149.90, 149.90),
(14,21, 1, 0.00, 119.90, 119.90),
(11,21, 1, 0.00,  39.90,  39.90),
(3, 22, 1, 0.00, 799.90, 799.90),
(12,23, 1, 0.00,  79.90,  79.90),
(1, 23, 2, 0.00,  59.80,  29.90),
(11,23, 1, 0.00,  39.90,  39.90),
(14,23, 1, 10.00, 109.90, 119.90),
(6, 24, 1, 0.00, 229.90, 229.90),
(9, 24, 1, 0.00, 229.90, 229.90),
(11,24, 1, 0.00,  39.90,  39.90),
(12,24, 1, 0.00,  79.90,  79.90),
(9, 25, 2, 0.00, 459.80, 229.90),
(2, 26, 1, 0.00, 399.90, 399.90),
(1, 26, 2, 0.00,  59.80,  29.90),
(11,26, 1, 0.00,  39.90,  39.90),
(12,26, 1, 0.00,  79.90,  79.90),
(3, 27, 1, 0.00, 799.90, 799.90),
(11,27, 1, 0.00,  39.90,  39.90),
(12,27, 1, 0.00,  79.90,  79.90),
(7, 28, 1, 0.00, 499.90, 499.90),
(9, 28, 1, 0.00, 229.90, 229.90),
(14,29, 1, 0.00, 119.90, 119.90),
(4, 29, 1, 0.00, 149.90, 149.90),
(11,29, 1, 0.00,  39.90,  39.90),
(1, 29, 1, 0.00,  29.90,  29.90),
(1, 30, 2, 0.00,  59.80,  29.90),
(11,30, 1, 0.00,  39.90,  39.90),
(9, 31, 1, 0.00, 229.90, 229.90),
(13,31, 1, 0.00, 179.90, 179.90),
(12,31, 1, 0.00,  79.90,  79.90),
(11,31, 1, 0.00,  39.90,  39.90),
(4, 32, 1, 0.00, 149.90, 149.90),
(1, 32, 1, 0.00,  29.90,  29.90),
(11,32, 1, 0.00,  39.90,  39.90),
(8, 33, 1, 0.00, 349.90, 349.90),
(13,33, 1, 0.00, 179.90, 179.90),
(10,33, 1, 30.00, 349.90, 379.90),
(12,34, 1, 0.00,  79.90,  79.90),
(1, 34, 1, 0.00,  29.90,  29.90),
(11,34, 1, 10.00, 29.90,  39.90),
(2, 35, 1, 0.00, 399.90, 399.90),
(11,35, 1, 0.00,  39.90,  39.90);

-- 11. COMISSÕES
INSERT INTO comissao (id_comissao, valor_comissao, data_venda, fkVenda, fkFuncionario) VALUES
(1, 31.49, '2026-03-03 10:00:00', 1, 3),
(2, 22.99, '2026-03-06 15:30:00', 2, 4),
(3, 41.99, '2026-03-09 11:20:00', 3, 5),
(4, 25.49, '2026-03-12 17:45:00', 4, 3),
(5, 11.49, '2026-03-15 14:00:00', 5, 4),
(6, 36.49, '2026-03-18 09:30:00', 6, 5),
(7, 37.99, '2026-03-21 10:00:00', 7, 3),
(8, 30.49, '2026-03-24 16:20:00', 8, 4),
(9, 7.50,  '2026-03-27 11:00:00', 9, 5),
(10, 25.49, '2026-03-30 14:00:00', 10, 3),
(11, 17.50, '2026-04-02 10:00:00', 11, 4),
(12, 43.99, '2026-04-05 18:30:00', 12, 5),
(13, 30.49, '2026-04-08 12:00:00', 13, 3),
(14, 41.49, '2026-04-11 15:00:00', 14, 4),
(15, 20.99, '2026-04-14 10:00:00', 15, 5),
(16, 13.49, '2026-04-17 11:00:00', 16, 3),
(17, 28.99, '2026-04-20 14:30:00', 17, 4),
(18, 19.00, '2026-04-23 16:00:00', 18, 5),
(19, 32.49, '2026-04-26 09:00:00', 19, 3),
(20, 25.00, '2026-04-28 13:00:00', 20, 4),
(21, 15.49, '2026-04-30 15:00:00', 21, 5),
(22, 39.99, '2026-05-02 17:00:00', 22, 3),
(23, 13.49, '2026-05-04 10:00:00', 23, 4),
(24, 28.99, '2026-05-06 14:00:00', 24, 5),
(25, 22.99, '2026-05-08 11:00:00', 25, 3),
(26, 31.49, '2026-05-10 16:00:00', 26, 4),
(27, 43.99, '2026-05-12 18:00:00', 27, 5),
(28, 36.49, '2026-05-14 10:00:00', 28, 3),
(29, 17.49, '2026-05-16 14:00:00', 29, 4),
(30, 3.49,  '2026-05-18 08:30:00', 30, 3),
(31, 30.49, '2026-05-19 10:15:00', 31, 4),
(32, 11.50, '2026-05-20 13:00:00', 32, 5),
(33, 38.99, '2026-05-21 15:45:00', 33, 3),
(34, 5.99,  '2026-05-22 17:20:00', 34, 4),
(35, 20.49, '2026-05-23 18:00:00', 35, 5);

-- 12. PAGAMENTOS DE COMISSÃO
INSERT INTO pagamento_comissao (id, fk_vendedor, data_pagamento, valor, observacao) VALUES
(1, 3, '2026-03-20 10:00:00', 1500.00, 'Pagamento referente às vendas de março'),
(2, 4, '2026-03-20 10:30:00', 1400.00, 'Pagamento referente às vendas de março'),
(3, 5, '2026-03-20 11:00:00', 1200.00, 'Pagamento referente às vendas de março');

-- -------------------------
-- 4) ADICIONAR CONSTRAINTS DE FK (após dados, para evitar problemas de ordem)
-- -------------------------
ALTER TABLE perfil_tela
  ADD CONSTRAINT fk_perfil_tela_perfil FOREIGN KEY (perfil_id) REFERENCES perfil(id),
  ADD CONSTRAINT fk_perfil_tela_tela FOREIGN KEY (tela_id) REFERENCES tela(id);

ALTER TABLE funcionario
  ADD CONSTRAINT fk_funcionario_perfil FOREIGN KEY (perfil_id) REFERENCES perfil(id);

ALTER TABLE categoria
  ADD CONSTRAINT fk_categoria_pai FOREIGN KEY (fk_pai) REFERENCES categoria(id);

ALTER TABLE produto
  ADD CONSTRAINT fk_produto_categoria FOREIGN KEY (fk_categoria) REFERENCES categoria(id);

ALTER TABLE cliente
  ADD CONSTRAINT fk_cliente_endereco FOREIGN KEY (endereco_id) REFERENCES endereco(id);

ALTER TABLE campanha_cliente
  ADD CONSTRAINT fk_campanha_cliente_campanha FOREIGN KEY (campanha_id) REFERENCES campanha(id),
  ADD CONSTRAINT fk_campanha_cliente_cliente FOREIGN KEY (cliente_id) REFERENCES cliente(id);

ALTER TABLE venda
  ADD CONSTRAINT fk_venda_vendedor FOREIGN KEY (fk_vendedor) REFERENCES funcionario(id),
  ADD CONSTRAINT fk_venda_cliente FOREIGN KEY (fk_cliente) REFERENCES cliente(id);

ALTER TABLE itens_venda
  ADD CONSTRAINT fk_item_produto FOREIGN KEY (fk_produto) REFERENCES produto(id),
  ADD CONSTRAINT fk_item_venda FOREIGN KEY (fk_venda) REFERENCES venda(id);

ALTER TABLE comissao
  ADD CONSTRAINT fk_comissao_venda FOREIGN KEY (fkVenda) REFERENCES venda(id),
  ADD CONSTRAINT fk_comissao_funcionario FOREIGN KEY (fkFuncionario) REFERENCES funcionario(id);

ALTER TABLE pagamento_comissao
  ADD CONSTRAINT fk_pagamento_vendedor FOREIGN KEY (fk_vendedor) REFERENCES funcionario(id);

-- ============================
-- SCRIPT finalizado
-- ============================