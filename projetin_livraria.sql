create database livraria;
use livraria;

create table cliente(
	Id_Cliente int auto_increment primary key,
	nome varchar(50) not null,
    email varchar(50) not null,
    cpf char(11) not null unique,
    telefone char(12),
    endereço varchar(100),
    data_registro date
);

create table editora(
	Id_editora int auto_increment primary key,
	nome varchar(45),
    pais varchar(15),
    contato char(15),
    website varchar(50)
);

create table autor(
	Id_autor int auto_increment primary key,
	nome varchar (30),
    nacionalidade varchar(15),
    data_nasch date,
    biografia text
);

drop table categoria;

create table categoria(
	Id_categoria int auto_increment primary key,
	nome_categoria varchar(20),
	descrição varchar(100)
);

create table livros(
	Id_Livro int auto_increment primary key,
    titulo varchar(50),
    preço decimal,
    ano_publicado date,
    ISBN varchar (15),
    AutorLivro int,
    CategoriaLivro int,
    EditoraLivro int,
    constraint fk_autor_livro foreign key (AutorLivro) references autor(Id_autor),
    constraint fk_categoria_livro foreign key (CategoriaLivro) references categoria(Id_categoria),
    constraint fk_editora_livro foreign key (EditoraLivro) references editora(Id_editora)
);

create table estoque(
	Id_estoque int auto_increment primary key,
    quantidade int,
    data_atualizado date,
    LivroEstoque int,
    constraint fk_livro_estoque foreign key (LivroEstoque) references livros(Id_Livro)
);

create table pedidos(
	Id_Pedidos int auto_increment primary key,
    data_pedido datetime,
    valor_total decimal,
    estatus enum("Em andamento", "Concluído", "Cancelado"),
    ClientePedido int,
    constraint fk_cliente_pedido foreign key (ClientePedido) references cliente(Id_Cliente)
); 

drop table livros_pedidos;

create table livros_pedidos(
	Id_Ppedidos int,
    Id_Plivros int,
    quantidade int,
    primary key (Id_Ppedidos, Id_Plivros),
    constraint fk_plivros_pedidos foreign key (Id_Plivros) references livros(Id_Livro),
    constraint fk_ppedidos_pedidos foreign key (Id_Ppedidos) references pedidos(Id_Pedidos)
);


-- Tabela cliente
INSERT INTO cliente (nome, email, cpf, telefone, endereço, data_registro) VALUES 
	('João Silva', 'joao.silva@email.com', '12345678901', '21998765432', 'Rua A, 123', '2024-01-15'),
	('Maria Oliveira', 'maria.oliveira@email.com', '09876543210', '21912345678', 'Rua B, 456', '2024-02-01'),
	('Pedro Santos', 'pedro.santos@email.com', '11223344556', '21987654321', 'Rua C, 789', '2024-03-12');

-- Tabela editora
INSERT INTO editora (nome, pais, contato, website) VALUES 
('Editora Globo', 'Brasil', '21912340001', 'www.editoraglobo.com.br'),
('Penguin Books', 'Reino Unido', '442071234567', 'www.penguin.co.uk'),
('Companhia das Letras', 'Brasil', '1132145678', 'www.companhiadasletras.com.br');

-- Tabela autor
INSERT INTO autor (nome, nacionalidade, data_nasch, biografia)
VALUES 
('Machado de Assis', 'Brasileira', '1839-06-21', 'Escritor brasileiro, fundador da Academia Brasileira de Letras.'),
('J.K. Rowling', 'Britânica', '1965-07-31', 'Autora da série Harry Potter.'),
('Gabriel García Márquez', 'Colombiana', '1927-03-06', 'Autor de Cem Anos de Solidão.');

-- Tabela categoria
INSERT INTO categoria (nome_categoria, descrição)
VALUES 
('Romance', 'Obras de ficção.'),
('Fantasia', 'Livros com elementos.'),
('Biografia', 'Histórias sobre a vida.');

-- Tabela livros
INSERT INTO livros (titulo, preço, ano_publicado, ISBN)
VALUES 
('Dom Casmurro', 39.90, '1899-01-01', '9781234567890'),
('Harry Potter e a Pedra Filosofal', 59.90, '1997-06-26', '9780747532743'),
('Cem Anos de Solidão', 49.90, '1967-05-30', '9780307474728');

-- Tabela estoque
INSERT INTO estoque (quantidade, data_atualizado)
VALUES 
(50, '2024-01-15'),
(200, '2024-01-10'),
(0, '2024-01-12');

-- Tabela pedidos
INSERT INTO pedidos (data_pedido, valor_total, estatus)
VALUES 
('2024-12-10 14:30:00', 119.80, 'Concluído'),
('2024-12-12 10:00:00', 59.90, 'Em andamento'),
('2024-12-13 16:45:00', 89.80, 'Concluído', 3);

-- Tabela livros_pedidos
INSERT INTO livros_pedidos (Id_Ppedidos, Id_Plivros, quantidade)
VALUES 
(3, 4, 1),
(3, 5, 1),
(2, 5, 1),
(1, 5, 2);

select * from livros;
select * from pedidos;

SELECT 
    Id_Pedidos AS PedidoID,
    data_pedido AS DataPedido,
    valor_total AS ValorTotal,
    estatus AS Status
FROM pedidos;

SELECT 
    livros_pedidos.Id_Ppedidos AS PedidoID,
    livros.titulo AS Livro,
    livros_pedidos.quantidade AS Quantidade
FROM livros_pedidos
JOIN livros ON livros_pedidos.Id_Plivros = livros.Id_Livro;

