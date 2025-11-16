-- ============================================
-- SISTEMA DE BANCO DE DADOS - CAFÉ & ARTE
-- Cafeteria Artesanal - Campo Grande/MS
-- ============================================
-- Autor: Projeto de Extensão
-- Data: 2024-11-16
-- Versão: 1.0.0
-- ============================================

-- Remover banco de dados se existir (apenas para desenvolvimento)
DROP DATABASE IF EXISTS cafe_arte;

-- Criar banco de dados
CREATE DATABASE cafe_arte
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE cafe_arte;

-- ============================================
-- TABELA: categorias
-- Descrição: Armazena as categorias de produtos
-- ============================================
CREATE TABLE categorias (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nome_categoria VARCHAR(50) NOT NULL UNIQUE,
    descricao TEXT,
    ativa BOOLEAN DEFAULT TRUE,
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    atualizado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_nome_categoria (nome_categoria)
) ENGINE=InnoDB;

-- ============================================
-- TABELA: produtos
-- Descrição: Armazena os produtos do cardápio
-- ============================================
CREATE TABLE produtos (
    id_produto INT AUTO_INCREMENT PRIMARY KEY,
    nome_produto VARCHAR(100) NOT NULL,
    descricao TEXT,
    preco DECIMAL(10, 2) NOT NULL CHECK (preco >= 0),
    id_categoria INT NOT NULL,
    imagem_url VARCHAR(255),
    disponivel BOOLEAN DEFAULT TRUE,
    estoque_disponivel BOOLEAN DEFAULT TRUE,
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    atualizado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    
    INDEX idx_nome_produto (nome_produto),
    INDEX idx_categoria (id_categoria),
    INDEX idx_disponivel (disponivel)
) ENGINE=InnoDB;

-- ============================================
-- TABELA: clientes
-- Descrição: Armazena informações dos clientes
-- ============================================
CREATE TABLE clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome_completo VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    telefone VARCHAR(20),
    cpf VARCHAR(14) UNIQUE,
    data_nascimento DATE,
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    atualizado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_email (email),
    INDEX idx_telefone (telefone)
) ENGINE=InnoDB;

-- ============================================
-- TABELA: pedidos
-- Descrição: Armazena os pedidos realizados
-- ============================================
CREATE TABLE pedidos (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    data_pedido TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status_pedido ENUM('pendente', 'confirmado', 'preparando', 'pronto', 'entregue', 'cancelado') 
        DEFAULT 'pendente',
    tipo_pedido ENUM('balcao', 'delivery', 'mesa') DEFAULT 'balcao',
    valor_subtotal DECIMAL(10, 2) NOT NULL CHECK (valor_subtotal >= 0),
    valor_desconto DECIMAL(10, 2) DEFAULT 0.00 CHECK (valor_desconto >= 0),
    valor_total DECIMAL(10, 2) NOT NULL CHECK (valor_total >= 0),
    observacoes TEXT,
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    atualizado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    
    INDEX idx_data_pedido (data_pedido),
    INDEX idx_status (status_pedido),
    INDEX idx_cliente (id_cliente)
) ENGINE=InnoDB;

-- ============================================
-- TABELA: itens_pedido
-- Descrição: Armazena os itens de cada pedido
-- ============================================
CREATE TABLE itens_pedido (
    id_item INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT NOT NULL,
    id_produto INT NOT NULL,
    quantidade INT NOT NULL CHECK (quantidade > 0),
    preco_unitario DECIMAL(10, 2) NOT NULL CHECK (preco_unitario >= 0),
    subtotal DECIMAL(10, 2) NOT NULL CHECK (subtotal >= 0),
    observacoes_item TEXT,
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (id_produto) REFERENCES produtos(id_produto)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    
    INDEX idx_pedido (id_pedido),
    INDEX idx_produto (id_produto)
) ENGINE=InnoDB;

-- ============================================
-- INSERÇÃO DE DADOS - CATEGORIAS
-- ============================================
INSERT INTO categorias (nome_categoria, descricao) VALUES
('Cafés', 'Cafés especiais preparados por baristas certificados'),
('Bebidas', 'Sucos, chás e outras bebidas refrescantes'),
('Acompanhamentos', 'Doces, salgados e outras delícias artesanais');

-- ============================================
-- INSERÇÃO DE DADOS - PRODUTOS
-- ============================================
INSERT INTO produtos (nome_produto, descricao, preco, id_categoria, imagem_url, disponivel) VALUES
-- Cafés
('Espresso', 'Café expresso tradicional italiano', 8.00, 1, 'https://images.unsplash.com/photo-1510591509098-f4fdc6d0ff04?w=400', TRUE),
('Cappuccino', 'Espresso com leite vaporizado e espuma cremosa', 12.00, 1, 'https://images.unsplash.com/photo-1534778101976-62847782c213?w=400', TRUE),
('Café Latte', 'Espresso suave com muito leite vaporizado', 13.00, 1, 'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=400', TRUE),
('Mocha', 'Cappuccino especial com calda de chocolate belga', 14.00, 1, 'https://images.unsplash.com/photo-1578374173728-26c0abfe5d40?w=400', TRUE),

-- Bebidas
('Suco Natural de Laranja', 'Suco fresco espremido na hora', 9.00, 2, 'https://images.unsplash.com/photo-1600271886742-f049cd451bba?w=400', TRUE),
('Chá Gelado', 'Chá verde gelado com limão siciliano', 8.00, 2, 'https://images.unsplash.com/photo-1556679343-c7306c1976bc?w=400', TRUE),
('Smoothie de Frutas Vermelhas', 'Bebida cremosa com morango, framboesa e iogurte', 15.00, 2, 'https://images.unsplash.com/photo-1505252585461-04db1eb84625?w=400', TRUE),

-- Acompanhamentos
('Croissant Artesanal', 'Croissant francês tradicional folhado', 7.00, 3, 'https://images.unsplash.com/photo-1555507036-ab1f4038808a?w=400', TRUE),
('Brownie de Chocolate', 'Brownie úmido com pedaços de chocolate belga', 10.00, 3, 'https://images.unsplash.com/photo-1607920591413-4ec007e70023?w=400', TRUE),
('Pão de Queijo Mineiro', 'Tradicional pão de queijo quentinho', 6.00, 3, 'https://images.unsplash.com/photo-1618897996318-5a901fa6ca71?w=400', TRUE);

-- ============================================
-- INSERÇÃO DE DADOS - CLIENTES
-- ============================================
INSERT INTO clientes (nome_completo, email, telefone, cpf, data_nascimento) VALUES
('Ana Paula Silva', 'ana.silva@email.com', '(67) 99123-4567', '123.456.789-00', '1990-05-15'),
('Carlos Eduardo Santos', 'carlos.santos@email.com', '(67) 98765-4321', '987.654.321-00', '1985-08-22'),
('Maria Fernanda Oliveira', 'maria.oliveira@email.com', '(67) 99888-7766', '456.789.123-00', '1995-12-10'),
('João Pedro Costa', 'joao.costa@email.com', '(67) 97777-6655', '789.123.456-00', '1988-03-28');

-- ============================================
-- INSERÇÃO DE DADOS - PEDIDOS
-- ============================================
INSERT INTO pedidos (id_cliente, status_pedido, tipo_pedido, valor_subtotal, valor_desconto, valor_total, observacoes) VALUES
(1, 'entregue', 'balcao', 20.00, 2.00, 18.00, 'Sem açúcar no cappuccino'),
(2, 'pronto', 'delivery', 35.00, 0.00, 35.00, 'Entregar no endereço cadastrado'),
(3, 'preparando', 'mesa', 27.00, 3.00, 24.00, 'Mesa 5 - Aniversário'),
(1, 'confirmado', 'balcao', 15.00, 0.00, 15.00, NULL);

-- ============================================
-- INSERÇÃO DE DADOS - ITENS_PEDIDO
-- ============================================
INSERT INTO itens_pedido (id_pedido, id_produto, quantidade, preco_unitario, subtotal, observacoes_item) VALUES
-- Pedido 1 (Ana Paula)
(1, 2, 1, 12.00, 12.00, 'Sem açúcar'),
(1, 8, 1, 7.00, 7.00, 'Bem quentinho'),

-- Pedido 2 (Carlos Eduardo)
(2, 1, 2, 8.00, 16.00, NULL),
(2, 4, 1, 14.00, 14.00, 'Extra chocolate'),
(2, 9, 1, 10.00, 10.00, NULL),

-- Pedido 3 (Maria Fernanda)
(3, 3, 2, 13.00, 26.00, 'Com leite desnatado'),
(3, 10, 2, 6.00, 12.00, NULL),

-- Pedido 4 (Ana Paula - segundo pedido)
(4, 5, 1, 9.00, 9.00, NULL),
(4, 8, 1, 7.00, 7.00, NULL);

-- ============================================
-- VIEWS ÚTEIS
-- ============================================

-- View: Produtos por categoria com informações completas
CREATE VIEW vw_produtos_por_categoria AS
SELECT 
    p.id_produto,
    p.nome_produto,
    p.descricao,
    p.preco,
    c.nome_categoria,
    p.disponivel,
    p.estoque_disponivel
FROM produtos p
INNER JOIN categorias c ON p.id_categoria = c.id_categoria
WHERE p.disponivel = TRUE
ORDER BY c.nome_categoria, p.nome_produto;

-- View: Resumo de pedidos com informações do cliente
CREATE VIEW vw_resumo_pedidos AS
SELECT 
    pe.id_pedido,
    cl.nome_completo AS cliente,
    cl.email,
    cl.telefone,
    pe.data_pedido,
    pe.status_pedido,
    pe.tipo_pedido,
    pe.valor_total,
    COUNT(ip.id_item) AS total_itens
FROM pedidos pe
INNER JOIN clientes cl ON pe.id_cliente = cl.id_cliente
LEFT JOIN itens_pedido ip ON pe.id_pedido = ip.id_pedido
GROUP BY pe.id_pedido, cl.nome_completo, cl.email, cl.telefone, 
         pe.data_pedido, pe.status_pedido, pe.tipo_pedido, pe.valor_total
ORDER BY pe.data_pedido DESC;

-- View: Detalhamento completo de pedidos
CREATE VIEW vw_detalhes_pedidos AS
SELECT 
    pe.id_pedido,
    cl.nome_completo AS cliente,
    pe.data_pedido,
    pe.status_pedido,
    pr.nome_produto,
    ip.quantidade,
    ip.preco_unitario,
    ip.subtotal,
    ip.observacoes_item
FROM pedidos pe
INNER JOIN clientes cl ON pe.id_cliente = cl.id_cliente
INNER JOIN itens_pedido ip ON pe.id_pedido = ip.id_pedido
INNER JOIN produtos pr ON ip.id_produto = pr.id_produto
ORDER BY pe.data_pedido DESC, pe.id_pedido, ip.id_item;

-- ============================================
-- CONSULTAS ÚTEIS PARA RELATÓRIOS
-- ============================================

-- Produtos mais vendidos
CREATE VIEW vw_produtos_mais_vendidos AS
SELECT 
    pr.nome_produto,
    c.nome_categoria,
    SUM(ip.quantidade) AS quantidade_vendida,
    SUM(ip.subtotal) AS receita_total,
    COUNT(DISTINCT ip.id_pedido) AS numero_pedidos
FROM itens_pedido ip
INNER JOIN produtos pr ON ip.id_produto = pr.id_produto
INNER JOIN categorias c ON pr.id_categoria = c.id_categoria
GROUP BY pr.id_produto, pr.nome_produto, c.nome_categoria
ORDER BY quantidade_vendida DESC;

-- Clientes mais frequentes
CREATE VIEW vw_clientes_frequentes AS
SELECT 
    cl.nome_completo,
    cl.email,
    COUNT(pe.id_pedido) AS total_pedidos,
    SUM(pe.valor_total) AS valor_total_gasto,
    AVG(pe.valor_total) AS ticket_medio,
    MAX(pe.data_pedido) AS ultimo_pedido
FROM clientes cl
LEFT JOIN pedidos pe ON cl.id_cliente = pe.id_cliente
GROUP BY cl.id_cliente, cl.nome_completo, cl.email
ORDER BY total_pedidos DESC;

-- ============================================
-- PROCEDURES ÚTEIS
-- ============================================

-- Procedure para adicionar item ao pedido
DELIMITER //
CREATE PROCEDURE sp_adicionar_item_pedido(
    IN p_id_pedido INT,
    IN p_id_produto INT,
    IN p_quantidade INT,
    IN p_observacoes TEXT
)
BEGIN
    DECLARE v_preco DECIMAL(10,2);
    DECLARE v_subtotal DECIMAL(10,2);
    
    -- Buscar preço do produto
    SELECT preco INTO v_preco FROM produtos WHERE id_produto = p_id_produto;
    
    -- Calcular subtotal
    SET v_subtotal = v_preco * p_quantidade;
    
    -- Inserir item
    INSERT INTO itens_pedido (id_pedido, id_produto, quantidade, preco_unitario, subtotal, observacoes_item)
    VALUES (p_id_pedido, p_id_produto, p_quantidade, v_preco, v_subtotal, p_observacoes);
    
    -- Atualizar total do pedido
    UPDATE pedidos 
    SET valor_subtotal = (SELECT SUM(subtotal) FROM itens_pedido WHERE id_pedido = p_id_pedido),
        valor_total = valor_subtotal - valor_desconto
    WHERE id_pedido = p_id_pedido;
END //
DELIMITER ;

-- ============================================
-- CONSULTAS DE EXEMPLO
-- ============================================

-- Listar todos os produtos disponíveis por categoria
SELECT * FROM vw_produtos_por_categoria;

-- Ver todos os pedidos com resumo
SELECT * FROM vw_resumo_pedidos;

-- Ver detalhes completos de um pedido específico
SELECT * FROM vw_detalhes_pedidos WHERE id_pedido = 1;

-- Produtos mais vendidos
SELECT * FROM vw_produtos_mais_vendidos LIMIT 5;

-- Clientes VIP (mais de 1 pedido)
SELECT * FROM vw_clientes_frequentes WHERE total_pedidos > 1;

-- Faturamento total por período
SELECT 
    DATE(data_pedido) AS data,
    COUNT(*) AS total_pedidos,
    SUM(valor_total) AS faturamento_dia
FROM pedidos
WHERE status_pedido != 'cancelado'
GROUP BY DATE(data_pedido)
ORDER BY data DESC;

-- ============================================
-- FIM DO SCRIPT
-- ============================================
