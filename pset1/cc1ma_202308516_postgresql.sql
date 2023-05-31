-- ALUNO: RENAN CARVALHO MANERA
-- TURMA: CC1M

--Criando um  usuário e criando uma senha:
\c postgres postgres;
CREATE USER renan WITH ENCRYPTED PASSWORD '0000' LOGIN CREATEDB CREATEROLE;

--Criando banco de dados:
DROP DATABASE IF EXISTS uvv;
CREATE DATABASE uvv with owner renan
TEMPLATE template0
encoding UTF8 LC_COLLATE 'pt_BR.UTF-8' LC_CTYPE 'pt_BR.UTF-8'
allow_connections true;

--Usando banco de dados e permitindo acesso sem necessitar de senha:
\c "dbname=uvv user=renan password=0000";

--Criando schema e dando as permissões para o usuário:
DROP SCHEMA if exists lojas;
CREATE SCHEMA lojas;
ALTER SCHEMA lojas OWNER TO renan;
SET search_path TO lojas,"$user", public;
ALTER user renan
SET search_path TO lojas,"$user", public;

--Criando tabela de produtos:
CREATE TABLE produtos (
                produto_id NUMERIC(38) NOT NULL,
                nome VARCHAR(255) NOT NULL,
                preco_unitario NUMERIC(10,2) CHECK(preco_unitario >= 0),
                detalhes BYTEA,
                imagem BYTEA,
                imagem_mime_type VARCHAR(512),
                imagem_arquivo VARCHAR(512),
                imagem_charset VARCHAR(512),
                imagem_ultima_atualizacao DATE,
                CONSTRAINT pk_produtos PRIMARY KEY (produto_id)
);
COMMENT ON TABLE produtos IS 'Aqui está uma tabela com dados sobre produtos.';
COMMENT ON COLUMN produtos.produto_id IS 'Aqui está uma coluna com os dados sobre o id do produto.';
COMMENT ON COLUMN produtos.nome IS 'Aqui está uma coluna com os dados sobre o nome.';
COMMENT ON COLUMN produtos.preco_unitario IS 'Aqui está uma coluna com os dados sobre o preço unitário.';
COMMENT ON COLUMN produtos.detalhes IS 'Aqui está uma coluna com os dados sobre os detalhes.';
COMMENT ON COLUMN produtos.imagem IS 'Aqui está uma coluna com os dados sobre a imagem.';
COMMENT ON COLUMN produtos.imagem_mime_type IS 'Aqui está uma coluna com os dados sobre o mime type da imagem.';
COMMENT ON COLUMN produtos.imagem_arquivo IS 'Aqui está uma coluna com os dados sobre o arquivo da imagem.';
COMMENT ON COLUMN produtos.imagem_charset IS 'Aqui está uma coluna com os dados sobre o charset da imagem.';
COMMENT ON COLUMN produtos.imagem_ultima_atualizacao IS 'Aqui está uma coluna com os dados sobre a última atualização da imagem.';

--Criando tabela de lojas:
CREATE TABLE lojas (
                loja_id NUMERIC(38) NOT NULL,
                nome VARCHAR(255) NOT NULL,
                endereco_web VARCHAR(100),
                endereco_fisico VARCHAR(512),
                latitude NUMERIC,
                longitude NUMERIC,
                logo BYTEA,
                logo_mime_type VARCHAR(512),
                logo_arquivo VARCHAR(512),
                logo_charset VARCHAR(512),
                logo_ultima_atualizacao DATE,
                                CONSTRAINT min_um CHECK (endereco_web IS NOT NULL OR endereco_fisico IS NOT NULL),
                CONSTRAINT pk_lojas PRIMARY KEY (loja_id)
);
COMMENT ON TABLE lojas IS 'Aqui está uma tabela com dados sobre lojas';
COMMENT ON COLUMN lojas.loja_id IS 'Aqui está uma coluna com os dados sobre o id da loja.';
COMMENT ON COLUMN lojas.nome IS 'Aqui está uma coluna com os dados sobre o nome.';
COMMENT ON COLUMN lojas.endereco_web IS 'Aqui está uma coluna com os dados sobre o endereço web.';
COMMENT ON COLUMN lojas.endereco_fisico IS 'Aqui está uma coluna com os dados sobre o endereço físico.';
COMMENT ON COLUMN lojas.latitude IS 'Aqui está uma coluna com os dados sobre a latitude.';
COMMENT ON COLUMN lojas.longitude IS 'Aqui está uma coluna com os dados sobre o longitude.';
COMMENT ON COLUMN lojas.logo IS 'Aqui está uma coluna com os dados sobre a logo.';
COMMENT ON COLUMN lojas.logo_mime_type IS 'Aqui está uma coluna com os dados sobre o mime type do logo.';
COMMENT ON COLUMN lojas.logo_arquivo IS 'Aqui está uma coluna com os dados sobre o arquivo da logo.';
COMMENT ON COLUMN lojas.logo_charset IS 'Aqui está uma coluna com os dados sobre o charset da logo.';
COMMENT ON COLUMN lojas.logo_ultima_atualizacao IS 'Aqui está uma coluna com os dados sobre a última atualização da logo.';

--Criando tabela de estoques:
CREATE TABLE estoques (
                estoque_id NUMERIC(38) NOT NULL,
                loja_id NUMERIC(38) NOT NULL,
                produto_id NUMERIC(38) NOT NULL,
                quantidade NUMERIC(38) NOT NULL CHECK(quantidade >= 0),
                CONSTRAINT pk_estoques PRIMARY KEY (estoque_id)
);
COMMENT ON TABLE estoques IS 'Aqui está uma tabela com dados sobre estoques.';
COMMENT ON COLUMN estoques.estoque_id IS 'Aqui está uma coluna com os dados sobre o id do estoque.';
COMMENT ON COLUMN estoques.loja_id IS 'Aqui está uma coluna com os dados sobre o id da loja.';
COMMENT ON COLUMN estoques.produto_id IS 'Aqui está uma coluna com os dados sobre o id do produto.';
COMMENT ON COLUMN estoques.quantidade IS 'Aqui está uma coluna com os dados sobre a quantidade.';

--Criando tabela de clientes:
CREATE TABLE clientes (
                cliente_id NUMERIC(38) NOT NULL,
                email VARCHAR(255) NOT NULL CHECK(email LIKE '%@%'),
                nome VARCHAR(255) NOT NULL,
                telefone1 VARCHAR(20),
                telefone2 VARCHAR(20),
                telefone3 VARCHAR(20),
                CONSTRAINT pk_clientes PRIMARY KEY (cliente_id)
);
COMMENT ON TABLE clientes IS 'Aqui está uma tabela com dados sobre clientes.';
COMMENT ON COLUMN clientes.cliente_id IS 'Aqui está uma coluna com dados sobre o id do cliente.';
COMMENT ON COLUMN clientes.email IS 'Aqui está uma coluna com os dados sobre email do cliente.';
COMMENT ON COLUMN clientes.nome IS 'Aqui está uma coluna com os dados sobre o nome do cliente.';
COMMENT ON COLUMN clientes.telefone1 IS 'Aqui está uma coluna com os dados sobre o telefone 1 do cliente.';
COMMENT ON COLUMN clientes.telefone2 IS 'Aqui está uma coluna com os dados sobre o telefone 2 do cliente.';
COMMENT ON COLUMN clientes.telefone3 IS 'Aqui está uma coluna com os dados sobre o telefone 3 do cliente.';

--Criando tabela de envios:
CREATE TABLE envios (
                envio_id NUMERIC(38) NOT NULL,
                loja_id NUMERIC(38) NOT NULL,
                cliente_id NUMERIC(38) NOT NULL,
				endereco_entrega VARCHAR(512) NOT NULL,
                status VARCHAR(15) NOT NULL CHECK(status IN('CRIADO', 'ENVIADO', 'TRANSITO', 'ENTREGUE')),
                CONSTRAINT pk_envios PRIMARY KEY (envio_id)
);
COMMENT ON TABLE envios IS 'Aqui está uma tabela com dados sobre envios.';
COMMENT ON COLUMN envios.envio_id IS 'Aqui está uma coluna com os dados sobre o id do envio.';
COMMENT ON COLUMN envios.loja_id IS 'Aqui está uma coluna com os dados sobre o id da loja.';
COMMENT ON COLUMN envios.cliente_id IS 'Aqui está uma coluna com os dados sobre o id do cliente.';
COMMENT ON COLUMN envios.endereco_entrega IS 'Aqui está uma coluna com os dados sobre o endereço de entrega.';
COMMENT ON COLUMN envios.status IS 'Aqui está uma coluna com os dados sobre o status.';

--Criando tabela de pedidos:
CREATE TABLE pedidos (
                pedido_id NUMERIC(38) NOT NULL,
                data_hora TIMESTAMP NOT NULL,
                cliente_id NUMERIC(38) NOT NULL,
                status VARCHAR(15) NOT NULL CHECK(status IN('CANCELADO', 'COMPLETO', 'ABERTO', 'PAGO', 'REEMBOLSADO', 'ENVIADO')),
                loja_id NUMERIC(38) NOT NULL,
                CONSTRAINT pk_pedidos PRIMARY KEY (pedido_id)
);
COMMENT ON TABLE pedidos IS 'Aqui está uma tabela com dados sobre pedidos.';
COMMENT ON COLUMN pedidos.pedido_id IS 'Aqui está uma coluna com os dados sobre o id do pedido.';
COMMENT ON COLUMN pedidos.data_hora IS 'Aqui está uma coluna com os dados sobre a data e hora dos pedidos.';
COMMENT ON COLUMN pedidos.cliente_id IS 'Aqui está uma coluna com os dados sobre o id do cliente.';
COMMENT ON COLUMN pedidos.status IS 'Aqui está uma coluna com os dados sobre o status dos pedidos.';
COMMENT ON COLUMN pedidos.loja_id IS 'Aqui está uma coluna com os dados sobre o id da loja.';

--Criando tabela de pedidos itens:
CREATE TABLE pedidos_itens (
                pedido_id NUMERIC(38) NOT NULL,
                produto_id NUMERIC(38) NOT NULL,
                numero_da_linha NUMERIC(38) NOT NULL,
                preco_unitario NUMERIC(10,2) NOT NULL CHECK(preco_unitario >= 0),
                quantidade NUMERIC(38) NOT NULL CHECK(quantidade >= 0),
                envio_id NUMERIC(38),
                CONSTRAINT pk_pedidos_itens PRIMARY KEY (pedido_id, produto_id)
);
COMMENT ON TABLE pedidos_itens IS 'Aqui está uma tabela com dados sobre os pedidos dos itens.';
COMMENT ON COLUMN pedidos_itens.pedido_id IS 'Aqui está uma coluna com os dados sobre o id do pedido.';
COMMENT ON COLUMN pedidos_itens.produto_id IS 'Aqui está uma coluna com os dados sobre o id do produto.';
COMMENT ON COLUMN pedidos_itens.numero_da_linha IS 'Aqui está uma coluna com os dados sobre o número da linha.';
COMMENT ON COLUMN pedidos_itens.preco_unitario IS 'Aqui está uma coluna com os dados sobre o preço unitário.';
COMMENT ON COLUMN pedidos_itens.quantidade IS 'Aqui está uma coluna com os dados sobre a quantidade.';
COMMENT ON COLUMN pedidos_itens.envio_id IS 'Aqui está uma coluna com os dados sobre o id do envio.';

--Criando foreign key:
ALTER TABLE estoques ADD CONSTRAINT produtos_estoques_fk
FOREIGN KEY (produto_id)
REFERENCES produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE pedidos_itens ADD CONSTRAINT produtos_pedidos_itens_fk
FOREIGN KEY (produto_id)
REFERENCES produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE envios ADD CONSTRAINT lojas_envios_fk
FOREIGN KEY (loja_id)
REFERENCES lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE estoques ADD CONSTRAINT lojas_estoques_fk
FOREIGN KEY (loja_id)
REFERENCES lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE pedidos ADD CONSTRAINT lojas_pedidos_fk
FOREIGN KEY (loja_id)
REFERENCES lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE pedidos ADD CONSTRAINT clientes_pedidos_fk
FOREIGN KEY (cliente_id)
REFERENCES clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE envios ADD CONSTRAINT clientes_envios_fk
FOREIGN KEY (cliente_id)
REFERENCES clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE pedidos_itens ADD CONSTRAINT envios_pedidos_itens_fk
FOREIGN KEY (envio_id)
REFERENCES envios (envio_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE pedidos_itens ADD CONSTRAINT pedidos_pedidos_itens_fk
FOREIGN KEY (pedido_id)
REFERENCES pedidos (pedido_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
