Sistema de Banco de Dados - Café & Arte
Sistema de gerenciamento de banco de dados para cafeteria artesanal em Campo Grande-MS. Desenvolvido como parte do projeto de extensão para digitalização de pequenos negócios locais.

Sobre o Projeto
Sistema relacional completo para gerenciamento de:
Cardápio digital com categorização de produtos
Pedidos online e presenciais
Cadastro de clientes com histórico
Relatórios gerenciais e análise de vendas

Objetivos
✅ Centralizar informações de produtos e pedidos
✅ Facilitar gestão de estoque e disponibilidade
✅ Gerar relatórios de vendas e desempenho
✅ Melhorar experiência do cliente com histórico

Modelo de Dados
Diagrama Entidade-Relacionamento (ER)
┌─────────────┐       ┌──────────────┐       ┌─────────────┐
│ CATEGORIAS  │──1:N──│  PRODUTOS    │──N:M──│   PEDIDOS   │
└─────────────┘       └──────────────┘       └─────────────┘
                                                     │
                                                    1:N
                                                     │
                                              ┌──────────────┐
                                              │ITENS_PEDIDO  │
                                              └──────────────┘
                                                     │
                                                    N:1
                                                     │
                                              ┌─────────────┐
                                              │  CLIENTES   │
                                              └─────────────┘

Tabelas Principais
1. categorias. Armazena categorias de produtos (Cafés, Bebidas, Acompanhamentos).
Campo	Tipo	Descrição
id_categoria	INT (PK)	Identificador único
nome_categoria	VARCHAR(50)	Nome da categoria
descricao	TEXT	Descrição detalhada
ativa	BOOLEAN	Status ativo/inativo

2. produtos. Cardápio completo da cafeteria.

Campo	Tipo	Descrição	
id_produto	INT (PK)	Identificador único	
nome_produto	VARCHAR(100)	Nome do produto	
descricao	TEXT	Descrição detalhada	
preco	DECIMAL(10,2)	Preço unitário	
id_categoria	INT (FK)	Categoria do produto	
disponivel	BOOLEAN	Disponibilidade	

3. clientes. Cadastro de clientes da cafeteria.
Campo	Tipo	Descrição	
id_cliente	INT (PK)	Identificador único	
nome_completo	VARCHAR(150)	Nome completo	
email	VARCHAR(150)	E-mail (único)	
telefone	VARCHAR(20)	Telefone de contato	
cpf	VARCHAR(14)	CPF (único)	

4. pedidos. Registros de pedidos realizados.
Campo	Tipo	Descrição	
id_pedido	INT (PK)	Identificador único	
id_cliente	INT (FK)	Cliente do pedido	
data_pedido	TIMESTAMP	Data/hora do pedido	
status_pedido	ENUM	Status atual	
tipo_pedido	ENUM	Tipo (balcão/delivery/mesa)	
valor_total	DECIMAL(10,2)	Valor final	

5. itens_pedido. Itens individuais de cada pedido.

Campo	Tipo	Descrição	
id_item	INT (PK)	Identificador único	
id_pedido	INT (FK)	Pedido relacionado	
id_produto	INT (FK)	Produto solicitado	
quantidade	INT	Quantidade do item	
preco_unitario	DECIMAL(10,2)	Preço na compra	
subtotal	DECIMAL(10,2)	Total do item	

Pré-requisitos
MySQL 8.0 ou superior
MySQL Workbench (opcional, interface gráfica)
Git para controle de versão

Verificar MySQL
mysql –version

Instalação
1. Clonar o Repositório
git clone https://github.com/seu-usuario/cafe-arte-database.git
cd cafe-arte-database

2. Executar Script SQL
mysql -u root -p < database/cafe_arte_schema.sql

Via MySQL Workbench:
Abrir MySQL Workbench
File → Open SQL Script
Selecionar cafe_arte_schema.sql
Executar (⚡ ícone de raio)

Verificar Criação
USE cafe_arte;
SHOW TABLES;

Resultado esperado:
Tables_in_cafe_arte	
categorias	
clientes	
itens_pedido	
pedidos	
produtos	

Estrutura do Banco
Views Disponíveis

vw_produtos_por_categoria Lista todos os produtos disponíveis organizados por categoria.
SELECT * FROM vw_produtos_por_categoria;

vw_resumo_pedidos Resumo de pedidos com informações do cliente.
SELECT * FROM vw_resumo_pedidos;

vw_produtos_mais_vendidos Ranking de produtos mais vendidos com receita.
SELECT * FROM vw_produtos_mais_vendidos LIMIT 10;

vw_clientes_frequentes Clientes com mais pedidos e ticket médio.
SELECT * FROM vw_clientes_frequentes;

Stored Procedures
sp_adicionar_item_pedido Adiciona item ao pedido e recalcula total automaticamente.
CALL sp_adicionar_item_pedido(1, 2, 2, 'Sem açúcar');
Parâmetros:
p_id_pedido: ID do pedido
p_id_produto: ID do produto
p_quantidade: Quantidade
p_observacoes: Observações (opcional)

Consultas Úteis

Listar cardápio completo
SELECT 
    c.nome_categoria AS Categoria,
    p.nome_produto AS Produto,
    p.preco AS 'Preço (R$)',
    p.disponivel AS Disponível
FROM produtos p
INNER JOIN categorias c ON p.id_categoria = c.id_categoria
ORDER BY c.nome_categoria, p.nome_produto;

Pedidos do dia
SELECT 
    pe.id_pedido,
    cl.nome_completo AS Cliente,
    pe.status_pedido,
    pe.valor_total,
    pe.data_pedido
FROM pedidos pe
INNER JOIN clientes cl ON pe.id_cliente = cl.id_cliente
WHERE DATE(pe.data_pedido) = CURDATE()
ORDER BY pe.data_pedido DESC;


Faturamento mensal
SELECT 
    DATE_FORMAT(data_pedido, '%Y-%m') AS Mês,
    COUNT(*) AS 'Total Pedidos',
    SUM(valor_total) AS 'Faturamento (R$)'
FROM pedidos
WHERE status_pedido != 'cancelado'
GROUP BY DATE_FORMAT(data_pedido, '%Y-%m')
ORDER BY Mês DESC;

Top 5 clientes
SELECT 
    cl.nome_completo,
    COUNT(pe.id_pedido) AS 'Total Pedidos',
    SUM(pe.valor_total) AS 'Valor Total (R$)'
FROM clientes cl
INNER JOIN pedidos pe ON cl.id_cliente = pe.id_cliente
GROUP BY cl.id_cliente
ORDER BY SUM(pe.valor_total) DESC
LIMIT 5;

Tecnologias
MySQL 8.0+ - Sistema de gerenciamento de banco de dados
InnoDB - Engine para suporte a transações
UTF-8 (utf8mb4) - Encoding para suporte completo a caracteres

Recursos Utilizados
✅ Relacionamentos (Foreign Keys)
✅ Constraints (CHECK, UNIQUE, NOT NULL)
✅ Índices para performance
✅ Views para consultas complexas

✅ Stored Procedures
✅ Triggers (ON UPDATE CASCADE)
✅ Timestamps automáticos

📝 Dados de Exemplo
O script inclui dados pré-cadastrados para testes:

3 categorias (Cafés, Bebidas, Acompanhamentos)
10 produtos diversos
4 clientes cadastrados
4 pedidos com status variados
8 itens distribuídos nos pedidos

🚀 Próximos Passos
[ ] Implementar sistema de pontos/fidelidade
[ ] Adicionar tabela de cupons de desconto
[ ] Criar módulo de controle de estoque
[ ] Integrar com API de pagamentos
[ ] Dashboard de analytics em tempo real

👥 Autores
Projeto de Extensão Universitária Digitalização de Cafeterias - Campo Grande/MS
Matheus Bazzo.

📄 Licença
Este projeto está sob a licença MIT. Veja o arquivo LICENSE para mais detalhes.

📞 Contato
Café & Arte 📍 Rua das Flores, 123 - Centro, Campo Grande/MS 📧 contato@cafearte.com.br 📱 (67) 1234-5678
