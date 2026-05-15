/*
ATIVIDADE 02 - BANCO DE DADOS II – 2º bim
---------------------------------------
Realizado por Renata Gardenia
---------------------------------------
*/
-- create

CREATE TABLE Cliente (
  id_cliente int,
  nome varchar(150) not null,
  cpf char(11) not null,
  rg char(9) not null,
  uf_rg char(2) not null,
  dt_nasc date not null,
  endereco varchar(100),
  bairro varchar(30),
  cidade varchar(30),
  uf char(2),
  cep char(8),
  telefone char(11),

  CONSTRAINT pk_cliente PRIMARY KEY (id_cliente),
  CONSTRAINT u_cpf UNIQUE (cpf)
);
GO


CREATE TABLE Conjuge(
  id_conjuge int,
  id_cliente int, 
  nome_conjuge varchar(150),
  dt_nasc date,
  cpf char(11),
  rg char(9),
  uf_rg char(2),

  CONSTRAINT pk_conjuge PRIMARY KEY (id_conjuge),
  CONSTRAINT u_cpf_conjuge UNIQUE (cpf),
  CONSTRAINT fk_conjuge_cliente 
      FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente)
);
GO

CREATE TABLE Empresa(
  id_empresa int,
  id_cliente int, 
  nome_empresa varchar(200) not null,
  endereco varchar(100),
  bairro varchar(30),
  cidade varchar(30),
  uf char(2),
  cep varchar(8),
  telefone varchar(20),
  cargo varchar(20),
  salario float,

  CONSTRAINT pk_empresa PRIMARY KEY (id_empresa),

  CONSTRAINT fk_empresa_cliente
      FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente)
);
GO
-- INSERTS
INSERT INTO Cliente VALUES
(1,'Ana Souza','11111111111','123456789','SP','1990-05-10','Rua A','Centro','Santos','SP','11000000','13999990001'),
(2,'Bruno Lima','22222222222','223456789','SP','1988-03-15','Rua B','Gonzaga','Santos','SP','11000001','13999990002'),
(3,'Carlos Silva','33333333333','323456789','RJ','1992-07-20','Rua C','Boqueirao','Santos','SP','11000002','13999990003'),
(4,'Daniela Costa','44444444444','423456789','MG','1995-09-01','Rua D','Aparecida','Santos','SP','11000003','13999990004'),
(5,'Eduardo Alves','55555555555','523456789','SP','1987-11-11','Rua E','Embare','Santos','SP','11000004','13999990005'),
(6,'Fernanda Rocha','66666666666','623456789','PR','1993-12-25','Rua F','Ponta da Praia','Santos','SP','11000005','13999990006'),
(7,'Gabriel Martins','77777777777','723456789','SP','1991-04-30','Rua G','Campo Grande','Santos','SP','11000006','13999990007'),
(8,'Helena Ribeiro','88888888888','823456789','BA','1996-08-18','Rua H','Macuco','Santos','SP','11000007','13999990008'),
(9,'Igor Ferreira','99999999999','923456789','SP','1985-01-05','Rua I','Jose Menino','Santos','SP','11000008','13999990009'),
(10,'Juliana Mendes','10101010101','103456789','RS','1998-06-12','Rua J','Vila Mathias','Santos','SP','11000009','13999990010');
GO

INSERT INTO Conjuge VALUES
(1,1,'Marcos Souza','1991-02-10','11111111112','111111111','SP'),
(2,2,'Paula Lima','1989-05-21','22222222223','222222222','SP'),
(3,4,'Amanda Costa','1996-03-30','44444444445','444444444','MG'),
(4,5,'Bianca Alves','1988-12-19','55555555556','555555555','SP'),
(5,7,'Patricia Martins','1993-01-27','77777777778','777777777','SP'),
(6,8,'Rafael Ribeiro','1994-06-14','88888888889','888888888','BA'),
(7,10,'Thiago Mendes','1997-09-09','10101010102','101010101','RS');
GO

INSERT INTO Empresa VALUES
(1,1,'Tech Solutions','Av. Ana Costa','Centro','Santos','SP','11010000','1330000001','Analista',4500),
(2,3,'Inova Tech','Rua XV','Centro','Curitiba','PR','80000000','4130000003','Programador',5200),
(3,4,'Alpha Engenharia','Rua das Flores','Centro','Belo Horizonte','MG','30000000','3130000004','Engenheira',7600),
(4,6,'Digital Corp','Rua Verde','Centro','Londrina','PR','86000000','4330000006','Designer',4100),
(5,7,'Ocean Logistica','Av. Portuaria','Valongo','Santos','SP','11030000','1330000007','Coordenador',6200),
(6,9,'Master Finance','Av. Central','Centro','Campinas','SP','13000000','1930000009','Contador',6700),
(7,10,'Vision Software','Rua Nova','Jardins','Porto Alegre','RS','90000000','5130000010','Desenvolvedora',7200);
GO
-- VIEWS
-- vw_MalaDireta --> nome, endereço, bairro, cidade, uf e Cep dos Clientes
CREATE VIEW vw_MalaDireta AS
SELECT 
    c.nome,
    c.endereco,
    c.bairro,
    c.cidade,
    c.uf,
    c.cep
FROM Cliente c;
GO
  
-- vw_InfoClientes --> dados dos clientes, conjuges e empresa apenas dos clientes que sejam casados e trabalhem
CREATE VIEW vw_InfoClientes AS
SELECT 
    c.nome,
    c.cpf,
    c.rg,
    c.uf_rg,
    c.dt_nasc,
    c.endereco,
    c.bairro,
    c.cidade,
    c.uf,
    c.cep,
    c.telefone,
    cj.nome_conjuge,
    e.nome_empresa
FROM Cliente c
LEFT JOIN Conjuge cj 
    ON c.id_cliente = cj.id_cliente
LEFT JOIN Empresa e 
    ON c.id_cliente = e.id_cliente;
GO

--- vw_ClientesConjuges --> nome dos clientes e conjuges. Os dados de todos os clientes devem ser retornados, independente de serem casados ou não
---- vw_ClientesEmpresas -->nome, CPF , RG, Nome da Empresa e Cargo dos Clientes 

SELECT * FROM vw_InfoClientes;
GO
