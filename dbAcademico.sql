/*
ATIVIDADE 01 - BANCO DE DADOS II – 2º bim
---------------------------------------
MEMBROS DO GRUPO:
1 - Júlia Vitória 
2 - Lucas Antonio 
3 - Renata Gardenia
4 - Théo da Costa
---------------------------------------
*/
-- Estrutura de Dados 

CREATE DATABASE dbAcademico;
USE dbAcademico;

CREATE TABLE Curso (
  id_curso int ,
  nome varchar(50) not null,
  sigla varchar(10)not null,
  id_tipo int not null,
  CONSTRAINT pk_curso PRIMARY KEY (id_curso)
);

CREATE TABLE TipoCurso (
  id_tipo int ,
  nome varchar(30) not null,
  CONSTRAINT pk_tipo PRIMARY KEY (id_tipo)
);

CREATE TABLE Aluno (
  prontuario char(8) ,
  nome varchar(50) not null,
  cpf char(12) not null,
  cidade varchar(30) not null,
  dt_nasc date not null,
  email varchar(100) not null
  CONSTRAINT pk_aluno PRIMARY KEY (prontuario)
);

CREATE TABLE Turma (
  id_turma int ,
  nome varchar(10) not null,
  id_curso int not null,
  CONSTRAINT pk_turma PRIMARY KEY (id_turma)
);

CREATE TABLE Professor (
  prontuario char(8) ,
  nome varchar(50) not null,
  apelido varchar(50),
  email varchar(50) not null,
  titulacao varchar(20) not null,
  CONSTRAINT pk_professor PRIMARY KEY (prontuario)
);
CREATE TABLE Disciplina (
  id_disciplina int ,
  nome  varchar(50) not null,
  codigo char(10) not null,
  id_curso int not null,
  CONSTRAINT pk_disciplina PRIMARY KEY (id_disciplina)
);

-- Restrições 
-- Inserts
-- Inserts Alunos
