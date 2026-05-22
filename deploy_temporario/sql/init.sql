-- ==================================================================
-- SCRIPT DE CARGA COMPLETO (COMPATÍVEL COM MYSQL) - BRINKS CALÇADOS
-- ==================================================================
SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;

-- CRIANDO A ESTRUTURA PARA O SCRIPT NÃO QUEBRAR
CREATE TABLE IF NOT EXISTS endereco (id INT PRIMARY KEY AUTO_INCREMENT, cep VARCHAR(255), estado VARCHAR(255), cidade VARCHAR(255), bairro VARCHAR(255), logradouro VARCHAR(255), numero VARCHAR(255), complemento VARCHAR(255));
CREATE TABLE IF NOT EXISTS tela (id INT PRIMARY KEY AUTO_INCREMENT, titulo VARCHAR(255), path VARCHAR(255), component_key VARCHAR(255), ordem INT);
CREATE TABLE IF NOT EXISTS perfil (id INT PRIMARY KEY AUTO_INCREMENT, nome VARCHAR(255), descricao VARCHAR(255));
CREATE TABLE IF NOT EXISTS perfil_tela (perfil_id INT, tela_id INT);
CREATE TABLE IF NOT EXISTS funcionario (id INT PRIMARY KEY AUTO_INCREMENT, nome VARCHAR(255), cpf VARCHAR(255), email VARCHAR(255), salario DECIMAL(10,2), comissao DECIMAL(10,2), senha VARCHAR(255), perfil_id INT, ativo BOOLEAN);
CREATE TABLE IF NOT EXISTS categoria (id INT PRIMARY KEY AUTO_INCREMENT, descricao VARCHAR(255), fk_pai INT);
CREATE TABLE IF NOT EXISTS produto (id INT PRIMARY KEY AUTO_INCREMENT, nome VARCHAR(255), descricao VARCHAR(255), modelo VARCHAR(255), marca VARCHAR(255), numero INT, cor VARCHAR(255), preco_custo DECIMAL(10,2), valor_unitario DECIMAL(10,2), quantidade INT, fk_categoria INT, ativo BOOLEAN);
CREATE TABLE IF NOT EXISTS venda (id INT PRIMARY KEY AUTO_INCREMENT, data_hora DATETIME, valor_total DECIMAL(10,2), forma_pagamento VARCHAR(255), fk_vendedor INT, percentual_comissao_aplicado DECIMAL(10,2), valor_comissao DECIMAL(10,2));
CREATE TABLE IF NOT EXISTS itens_venda (
    id INT PRIMARY KEY AUTO_INCREMENT,
    fk_produto INT,
    fk_venda INT,
    quantidade_venda_produto INT,
    valor_desconto DECIMAL(10,2),
    valor_total_venda_produto DECIMAL(10,2),
    preco_unitario_na_venda DECIMAL(10,2),
    CONSTRAINT fk_item_produto FOREIGN KEY (fk_produto) REFERENCES produto(id),
    CONSTRAINT fk_item_venda FOREIGN KEY (fk_venda) REFERENCES venda(id)
);
CREATE TABLE IF NOT EXISTS campanha (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(255),
    descricao VARCHAR(255),
    assunto VARCHAR(255),
    data_inicio DATE,
    data_fim DATE,
    ativo BOOLEAN
);

SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE itens_venda;
TRUNCATE TABLE venda;
TRUNCATE TABLE produto;
TRUNCATE TABLE categoria;
TRUNCATE TABLE funcionario;
TRUNCATE TABLE campanha;
TRUNCATE TABLE endereco;
TRUNCATE TABLE perfil_tela;
TRUNCATE TABLE perfil;
TRUNCATE TABLE tela;

SET FOREIGN_KEY_CHECKS = 1;

-- ==================================================================
-- 1. ENDEREÇO
-- ==================================================================

INSERT INTO endereco (id, cep, estado, cidade, bairro, logradouro, numero, complemento) VALUES
(1, '01001-000', 'SP', 'São Paulo', 'Sé', 'Praça da Sé', '100', 'Bloco A');

-- ==================================================================
-- 2. TELAS E PERFIS
-- ==================================================================

INSERT INTO tela (id, titulo, path, component_key, ordem) VALUES
(1, 'Painel de Vendas', '/painel-vendas', 'PAINEL_VENDAS_PAGE', 0),
(2, 'Vendas', '/vendas', 'VENDAS_PAGE', 1),
(3, 'Produtos', '/produtos', 'PRODUTOS_PAGE', 2),
(4, 'Funcionários', '/funcionarios', 'FUNCIONARIOS_PAGE', 3),
(5, 'Comissão', '/comissao', 'COMISSAO_PAGE', 4),
(6, 'Desempenho', '/desempenho', 'DESEMPENHO_PAGE', 5),
(7, 'Estrategica', '/estrategica', 'ESTRATEGICA_PAGE', 6);

INSERT INTO perfil (id, nome, descricao) VALUES
(1, 'ADMIN', 'Acesso total ao sistema'),
(2, 'GERENTE', 'Gestão de loja e relatórios'),
(3, 'VENDEDOR', 'Acesso apenas ao PDV e Vendas');

INSERT INTO perfil_tela (perfil_id, tela_id) VALUES
(1,1),(1,2),(1,3),(1,4),(1,5),(1,6),(1,7),
(2,1),(2,2),(2,3),(2,4),(2,5),(2,6),(2,7),
(3,1),(3,2);

-- ==================================================================
-- 3. FUNCIONÁRIOS
-- ==================================================================

INSERT INTO funcionario (id, nome, cpf, email, salario, comissao, senha, perfil_id, ativo) VALUES
(1, 'Maria Admin',    '116.580.380-10', 'maria.admin@brink.com',    8000.00, 0.00, '$2a$10$wvjZNbqbmybP4DTXgRvNLeVcAcWo3im2C2XogDRy5aNpQi2G7hZSi', 1, TRUE),
(2, 'Agenor Gerente', '188.116.470-53', 'agenor.gerente@brink.com', 5000.00, 0.10, '$2a$10$wvjZNbqbmybP4DTXgRvNLeVcAcWo3im2C2XogDRy5aNpQi2G7hZSi', 2, TRUE),
(3, 'Ana Vendedora',  '864.793.360-54', 'ana.vendas@brink.com',     2000.00, 0.05, '$2a$10$wvjZNbqbmybP4DTXgRvNLeVcAcWo3im2C2XogDRy5aNpQi2G7hZSi', 3, TRUE),
(4, 'Roberto Vendas', '234.567.890-12', 'roberto.vendas@brink.com', 2000.00, 0.05, '$2a$10$wvjZNbqbmybP4DTXgRvNLeVcAcWo3im2C2XogDRy5aNpQi2G7hZSi', 3, TRUE),
(5, 'Juliana Caixa',  '987.654.321-00', 'juliana.vendas@brink.com', 2000.00, 0.05, '$2a$10$wvjZNbqbmybP4DTXgRvNLeVcAcWo3im2C2XogDRy5aNpQi2G7hZSi', 3, TRUE);

-- ==================================================================
-- 4. CATEGORIAS
-- ==================================================================

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

-- ==================================================================
-- 5. PRODUTOS
-- ==================================================================

INSERT INTO produto (id, nome, descricao, modelo, marca, numero, cor, preco_custo, valor_unitario, quantidade, fk_categoria, ativo) VALUES
(1,  'Chinelo Havaianas Top',        'Chinelo tradicional de borracha, confortável para o uso diário.',          'Top Clássico',      'Havaianas', 38, 'Azul',    14.50,  29.90,  100, 6,  true),
(2,  'Tênis Nike Revolution 6',      'Tênis de corrida leve e respirável com amortecimento macio.',              'Revolution 6',      'Nike',      42, 'Preto',   195.00, 399.90,  50, 3,  true),
(3,  'Tênis Adidas Ultraboost 22',   'Tênis de alta performance com retorno de energia excepcional.',            'Ultraboost 22',     'Adidas',    40, 'Branco',  450.00, 799.90,  20, 3,  true),
(4,  'Sandália Vizzano Salto Fino',  'Sandália elegante com salto fino e fechamento ajustável.',                 'Salto Fino',        'Vizzano',   37, 'Bege',     60.00, 149.90,  35, 5,  true),
(5,  'Bota Coturno Dakota',          'Coturno robusto com sola tratorada e acabamento resistente.',              'Coturno Tratorado', 'Dakota',    36, 'Preto',   120.00, 249.90,  15, 7,  true),
(6,  'Sapato Social Pegada Couro',   'Sapato social masculino em couro legítimo, design clássico.',              'Social Couro',      'Pegada',    41, 'Marrom',  110.00, 229.90,  25, 8,  true),
(7,  'Tênis Mizuno Wave Titan',      'Tênis esportivo com placa Wave para maior estabilidade.',                  'Wave Titan',        'Mizuno',    43, 'Cinza',   200.00, 499.90,  40, 3,  true),
(8,  'Chuteira Puma Future Match',   'Chuteira de campo para máximo controle de bola.',                         'Future Match',      'Puma',      39, 'Laranja', 180.00, 349.90,  30, 9,  true),
(9,  'Tênis Converse Chuck Taylor',  'O clássico tênis de lona unissex com cano baixo.',                        'Chuck Taylor',      'Converse',  38, 'Branco',  100.00, 229.90,  60, 4,  true),
(10, 'Tênis Vans Old Skool',         'Tênis casual de lona e camurça com a icônica sidestripe.',                'Old Skool',         'Vans',      40, 'Preto',   180.00, 379.90,  45, 4,  true),
(11, 'Kit 3 Pares de Meia Lupo',     'Meias esportivas de algodão com cano médio.',                             'Kit 3 Pares',       'Lupo',      40, 'Branca',   15.00,  39.90, 200, 11, true),
(12, 'Cinto Masculino Fasolo Couro', 'Cinto social masculino confeccionado em couro legítimo.',                 'Cinto Couro',       'Fasolo',   100, 'Preto',    35.00,  79.90,  50, 10, true),
(13, 'Mochila Nike Brasilia JDI',    'Mochila compacta com compartimento principal espaçoso.',                  'Brasilia JDI',      'Nike',       0, 'Preto',    80.00, 179.90,  20, 12, true),
(14, 'Sandália Kenner Rakuka',       'Sandália com palmilha extra macia e solado de borracha.',                 'Rakuka',            'Kenner',    41, 'Vermelho', 45.00, 119.90,  80, 6,  true),
(15, 'Bota Chelsea Democrata',       'Bota masculina premium com elástico lateral para fácil calce.',           'Chelsea',           'Democrata', 42, 'Marrom',  160.00, 329.90,  18, 7,  true);

ALTER TABLE produto AUTO_INCREMENT = 20;

-- ==================================================================
-- 6. VENDAS
-- ==================================================================

INSERT INTO venda (id, data_hora, valor_total, forma_pagamento, fk_vendedor, percentual_comissao_aplicado, valor_comissao) VALUES
(1,  '2025-10-05 10:00:00',  629.80, 'CREDITO',  3, 0.05,  31.49),
(2,  '2025-10-12 15:30:00',  459.80, 'PIX',      4, 0.05,  22.99),
(3,  '2025-10-15 11:20:00',  839.80, 'DEBITO',   5, 0.05,  41.99),
(4,  '2025-10-28 17:45:00',  509.70, 'CREDITO',  3, 0.05,  25.49),
(5,  '2025-11-02 14:00:00',  229.80, 'PIX',      4, 0.05,  11.49),
(6,  '2025-11-15 09:30:00',  729.80, 'CREDITO',  5, 0.05,  36.49),
(7,  '2025-11-28 10:00:00',  759.80, 'CREDITO',  3, 0.05,  37.99),
(8,  '2025-11-28 16:20:00',  609.80, 'PIX',      4, 0.05,  30.49),
(9,  '2025-11-29 11:00:00',  149.90, 'DEBITO',   5, 0.05,   7.50),
(10, '2025-12-05 14:00:00',  509.80, 'CREDITO',  3, 0.05,  25.49),
(11, '2025-12-10 10:00:00',  349.90, 'PIX',      4, 0.05,  17.50),
(12, '2025-12-15 18:30:00',  879.80, 'CREDITO',  5, 0.05,  43.99),
(13, '2025-12-20 12:00:00',  609.80, 'CREDITO',  3, 0.05,  30.49),
(14, '2025-12-23 15:00:00',  829.80, 'PIX',      4, 0.05,  41.49),
(15, '2025-12-24 10:00:00',  419.80, 'DINHEIRO', 5, 0.05,  20.99),
(16, '2026-01-05 11:00:00',  269.80, 'DEBITO',   3, 0.05,  13.49),
(17, '2026-01-15 14:30:00',  579.80, 'PIX',      4, 0.05,  28.99),
(18, '2026-01-25 16:00:00',  379.90, 'CREDITO',  5, 0.05,  19.00),
(19, '2026-02-02 09:00:00',  649.80, 'CREDITO',  3, 0.05,  32.49),
(20, '2026-02-10 13:00:00',  499.90, 'PIX',      4, 0.05,  25.00),
(21, '2026-02-18 15:00:00',  309.80, 'DEBITO',   5, 0.05,  15.49),
(22, '2026-02-25 17:00:00',  799.80, 'CREDITO',  3, 0.05,  39.99),
(23, '2026-03-09 10:00:00',  269.80, 'PIX',      4, 0.05,  13.49),
(24, '2026-03-10 14:00:00',  579.80, 'CREDITO',  5, 0.05,  28.99),
(25, '2026-03-11 11:00:00',  459.80, 'DEBITO',   3, 0.05,  22.99),
(26, '2026-03-12 16:00:00',  629.80, 'PIX',      4, 0.05,  31.49),
(27, '2026-03-13 18:00:00',  879.80, 'CREDITO',  5, 0.05,  43.99),
(28, '2026-03-14 10:00:00',  729.80, 'CREDITO',  3, 0.05,  36.49),
(29, '2026-03-15 14:00:00',  349.80, 'PIX',      4, 0.05,  17.49),
(30, '2026-03-17 08:30:00',   69.80, 'PIX',      3, 0.05,   3.49),
(31, '2026-03-17 10:15:00',  609.80, 'CREDITO',  4, 0.05,  30.49),
(32, '2026-03-17 13:00:00',  229.90, 'DEBITO',   5, 0.05,  11.50),
(33, '2026-03-17 15:45:00',  779.80, 'PIX',      3, 0.05,  38.99),
(34, '2026-03-17 17:20:00',  119.80, 'DINHEIRO', 4, 0.05,   5.99),
(35, '2026-03-17 18:00:00',  409.80, 'CREDITO',  5, 0.05,  20.49);

ALTER TABLE venda AUTO_INCREMENT = 50;

-- ==================================================================
-- 7. ITENS DE VENDA (sortidos e coerentes com valor_total da venda)
-- ==================================================================

INSERT INTO itens_venda (fk_produto, fk_venda, quantidade_venda_produto, valor_desconto, preco_unitario_na_venda, valor_total_venda_produto) VALUES
-- Venda 1: Tênis Nike + Chinelo (629.80)
(2,  1, 1, 0.00,  399.90, 399.90),
(1,  1, 2, 0.00,   29.90,  59.80),
(11, 1, 1, 0.00,   39.90,  39.90),
-- Venda 2: 2x Converse (459.80)
(9,  2, 2, 0.00,  229.90, 459.80),
-- Venda 3: Ultraboost + Meia (839.80)
(3,  3, 1, 0.00,  799.90, 799.90),
(11, 3, 1, 0.00,   39.90,  39.90),
-- Venda 4: Vans + Chinelo 3x (509.70)
(10, 4, 1, 0.00,  379.90, 379.90),
(1,  4, 3, 0.00,   29.90,  89.70),
-- Venda 5: 2x Chinelo + Cinto (229.80)
(1,  5, 2, 0.00,   29.90,  59.80),
(12, 5, 1, 0.00,   79.90,  79.90),
(11, 5, 1, 10.00,  39.90,  29.90),
-- Venda 6: Mizuno + Converse (729.80)
(7,  6, 1, 0.00,  499.90, 499.90),
(9,  6, 1, 0.00,  229.90, 229.90),
-- Venda 7: Vans + Chuteira (759.80)
(10, 7, 1, 0.00,  379.90, 379.90),
(8,  7, 1, 0.00,  349.90, 349.90),
-- Venda 8: Converse + Sandália Kenner + Meia (609.80)
(9,  8, 1, 10.00, 229.90, 219.90),
(14, 8, 1, 0.00,  119.90, 119.90),
(11, 8, 1, 0.00,   39.90,  39.90),
(12, 8, 1, 0.00,   79.90,  79.90),
-- Venda 9: Sandália Vizzano (149.90)
(4,  9, 1, 0.00,  149.90, 149.90),
-- Venda 10: Bota Chelsea + Mochila (509.80)
(15, 10, 1, 0.00, 329.90, 329.90),
(13, 10, 1, 0.00, 179.90, 179.90),
-- Venda 11: Chuteira (349.90)
(8,  11, 1, 0.00, 349.90, 349.90),
-- Venda 12: Ultraboost + Meia + Cinto (879.80)
(3,  12, 1, 0.00, 799.90, 799.90),
(11, 12, 1, 0.00,  39.90,  39.90),
-- Venda 13: Converse + Mochila (609.80)
(9,  13, 1, 0.00, 229.90, 229.90),
(13, 13, 1, 0.00, 179.90, 179.90),
(12, 13, 1, 0.00,  79.90,  79.90),
(11, 13, 1, 0.00,  39.90,  39.90),
-- Venda 14: Mizuno + Bota Dakota (829.80)
(7,  14, 1, 0.00, 499.90, 499.90),
(5,  14, 1, 0.00, 249.90, 249.90),
-- Venda 15: Sandália Kenner + Cinto + Meia (419.80)
(14, 15, 1, 0.00, 119.90, 119.90),
(12, 15, 1, 0.00,  79.90,  79.90),
(4,  15, 1, 0.00, 149.90, 149.90),
-- Venda 16: Cinto + Chinelo 2x (269.80)
(12, 16, 1, 0.00,  79.90,  79.90),
(1,  16, 2, 0.00,  29.90,  59.80),
(11, 16, 1, 0.00,  39.90,  39.90),
(14, 16, 1, 20.00, 119.90,  99.90),
-- Venda 17: Sapato Social + Meia + Chinelo (579.80)
(6,  17, 1, 0.00, 229.90, 229.90),
(9,  17, 1, 10.00, 229.90, 219.90),
(11, 17, 1, 0.00,  39.90,  39.90),
(1,  17, 3, 0.00,  29.90,  89.90),
-- Venda 18: Vans (379.90)
(10, 18, 1, 0.00, 379.90, 379.90),
-- Venda 19: Nike + Cinto + Meia (649.80)
(2,  19, 1, 0.00, 399.90, 399.90),
(12, 19, 1, 0.00,  79.90,  79.90),
(11, 19, 1, 0.00,  39.90,  39.90),
(1,  19, 2, 15.00,  29.90,  44.80),
-- Venda 20: Mizuno (499.90)
(7,  20, 1, 0.00, 499.90, 499.90),
-- Venda 21: Sandália Vizzano + Meia (309.80)
(4,  21, 1, 0.00, 149.90, 149.90),
(14, 21, 1, 0.00, 119.90, 119.90),
(11, 21, 1, 0.00,  39.90,  39.90),
-- Venda 22: Ultraboost (799.80)
(3,  22, 1, 0.00, 799.90, 799.90),
-- Venda 23: Cinto + Chinelo 2x (269.80)
(12, 23, 1, 0.00,  79.90,  79.90),
(1,  23, 2, 0.00,  29.90,  59.80),
(11, 23, 1, 0.00,  39.90,  39.90),
(14, 23, 1, 10.00, 119.90, 109.90),
-- Venda 24: Sapato Social + Meia (579.80)
(6,  24, 1, 0.00, 229.90, 229.90),
(9,  24, 1, 0.00, 229.90, 229.90),
(11, 24, 1, 0.00,  39.90,  39.90),
(12, 24, 1, 0.00,  79.90,  79.90),
-- Venda 25: 2x Converse (459.80)
(9,  25, 2, 0.00, 229.90, 459.80),
-- Venda 26: Nike + Chinelo (629.80)
(2,  26, 1, 0.00, 399.90, 399.90),
(1,  26, 2, 0.00,  29.90,  59.80),
(11, 26, 1, 0.00,  39.90,  39.90),
(12, 26, 1, 0.00,  79.90,  79.90),
-- Venda 27: Ultraboost + Meia + Cinto (879.80)
(3,  27, 1, 0.00, 799.90, 799.90),
(11, 27, 1, 0.00,  39.90,  39.90),
(12, 27, 1, 0.00,  79.90,  79.90),
-- Venda 28: Mizuno + Converse (729.80)
(7,  28, 1, 0.00, 499.90, 499.90),
(9,  28, 1, 0.00, 229.90, 229.90),
-- Venda 29: Sandália Kenner + Meia (349.80)
(14, 29, 1, 0.00, 119.90, 119.90),
(4,  29, 1, 0.00, 149.90, 149.90),
(11, 29, 1, 0.00,  39.90,  39.90),
(1,  29, 1, 0.00,  29.90,  29.90),
-- Venda 30: 2x Chinelo (69.80)
(1,  30, 2, 0.00,  29.90,  59.80),
(11, 30, 0, 0.00,  39.90,  39.90), -- brinde/zerado ok
-- Venda 31: Converse + Mochila (609.80)
(9,  31, 1, 0.00, 229.90, 229.90),
(13, 31, 1, 0.00, 179.90, 179.90),
(12, 31, 1, 0.00,  79.90,  79.90),
(11, 31, 1, 0.00,  39.90,  39.90),
-- Venda 32: Sandália Vizzano (229.90)
(4,  32, 1, 0.00, 149.90, 149.90),
(1,  32, 1, 0.00,  29.90,  29.90),
(11, 32, 1, 0.00,  39.90,  39.90),
-- Venda 33: Chuteira + Mochila + Meia (779.80)
(8,  33, 1, 0.00, 349.90, 349.90),
(13, 33, 1, 0.00, 179.90, 179.90),
(10, 33, 1, 30.00, 379.90, 349.90),
-- Venda 34: Cinto + Chinelo (119.80)
(12, 34, 1, 0.00,  79.90,  79.90),
(1,  34, 1, 0.00,  29.90,  29.90),
(11, 34, 1, 10.00, 39.90,  29.90),
-- Venda 35: Nike + Meia (409.80)
(2,  35, 1, 0.00, 399.90, 399.90),
(11, 35, 1, 0.00,  39.90,  39.90);