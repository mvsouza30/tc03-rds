CREATE DATABASE IF NOT EXISTS qtop_database;
USE qtop_database;

-- Criação das tabelas
CREATE TABLE IF NOT EXISTS `qtop_database`.`cardapio` (
    id INT NOT NULL AUTO_INCREMENT,
    item VARCHAR(255) NOT NULL,
    preco DECIMAL(10, 2) NOT NULL,
    descricao VARCHAR(255) NOT NULL,
    arquivo VARCHAR(25) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE bebidas (
    id INT NOT NULL AUTO_INCREMENT,
    item VARCHAR(255) NOT NULL,
    preco DECIMAL(10, 2) NOT NULL,
    descricao VARCHAR(255) NOT NULL,
    arquivo VARCHAR(25) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE acompanhamentos (
    id INT NOT NULL AUTO_INCREMENT,
    item VARCHAR(255) NOT NULL,
    descricao VARCHAR(255) NOT NULL,
    preco DECIMAL(10, 2) NOT NULL,
    arquivo VARCHAR(25) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE sobremesas (
    id INT NOT NULL AUTO_INCREMENT,
    item VARCHAR(255) NOT NULL,
    preco DECIMAL(10, 2) NOT NULL,
    descricao VARCHAR(255) NOT NULL,
    arquivo VARCHAR(25) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE clientes (
    id INT NOT NULL AUTO_INCREMENT,
    nome VARCHAR(50) NOT NULL,
    cpf VARCHAR(15) NOT NULL,
    email VARCHAR(150) NOT NULL,
    PRIMARY KEY (id)
);

-- Criação do usuário 'root' com todos os privilégios
CREATE USER 'mvsouza'@'%' IDENTIFIED BY 'myconnect';

-- Dê todos os privilégios ao usuário 'root' no banco de dados 'qtop_database'
GRANT ALL PRIVILEGES ON qtop_database.* TO 'mvsouza'@'%';

-- Atualize as permissões
FLUSH PRIVILEGES;
