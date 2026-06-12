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

CREATE TABLE TipoCurso (
  id_tipo int ,
  nome varchar(30) not null,
  
  CONSTRAINT pk_tipo PRIMARY KEY (id_tipo)
);

CREATE TABLE Curso (
  id_curso int ,
  nome varchar(80) not null,
  sigla varchar(10)not null,
  id_tipo int not null,
  
  CONSTRAINT pk_curso  
  PRIMARY KEY (id_curso),
  
  CONSTRAINT fk_curso_tipo 
  FOREIGN KEY (id_tipo)
  REFERENCES TipoCurso(id_tipo)
);


CREATE TABLE Aluno (
  prontuario char(8) ,
  nome varchar(50) not null,
  cpf char(11) not null,
  cidade varchar(30) not null DEFAULT 'Cubatão',
  dt_nasc date not null,
  email varchar(100) not null,
  
  CONSTRAINT pk_aluno 
	PRIMARY KEY (prontuario),
	CONSTRAINT u_cpf UNIQUE (cpf),
  CONSTRAINT u_email UNIQUE (email),
	
  CONSTRAINT ck_idade
	CHECK (
  	dt_nasc <= DATEADD(YEAR, -14, GETDATE())
	),
	
  CONSTRAINT ck_cidade
	CHECK (
    cidade IN (
        'Cubatão',
        'Santos',
        'São Vicente',
        'Praia Grande',
        'Guarujá',
        'Mongaguá',
        'Itanhaém',
        'Peruíbe',
        'Bertioga'
    )
)
);
CREATE TABLE Professor (
  prontuario char(8) ,
  nome varchar(50) not null,
  apelido varchar(50),
  email varchar(50) not null,
  titulacao varchar(20) not null,
  
  CONSTRAINT pk_professor 
	PRIMARY KEY (prontuario),
	CONSTRAINT u_email_prof UNIQUE (email)
);

CREATE TABLE Disciplina (
  id_disciplina int ,
  nome  varchar(50) not null,
  codigo char(10) not null,
  id_curso int not null,
  prontuario_professor char(8),
  
  CONSTRAINT pk_disciplina 
	PRIMARY KEY (id_disciplina),
	
  CONSTRAINT fk_disciplina_curso
	FOREIGN KEY (id_curso)
	REFERENCES Curso(id_curso) ,
	
	CONSTRAINT fk_disciplina_professor
  FOREIGN KEY (prontuario_professor)
  REFERENCES Professor(prontuario)
);

CREATE TABLE Turma (
  id_turma int ,
  nome varchar(10) not null,
  id_curso int not null,
  
  CONSTRAINT pk_turma 
	PRIMARY KEY (id_turma),
	
  CONSTRAINT fk_turma_curso
	FOREIGN KEY (id_curso)
	REFERENCES Curso(id_curso)
);

CREATE TABLE Aluno_Turma (
    prontuario CHAR(8),
    id_turma INT,

    CONSTRAINT pk_aluno_turma 
        PRIMARY KEY (prontuario, id_turma),

    CONSTRAINT fk_alunoturma_aluno 
        FOREIGN KEY (prontuario) 
        REFERENCES Aluno(prontuario),

    CONSTRAINT fk_alunoturma_turma 
        FOREIGN KEY (id_turma) 
        REFERENCES Turma(id_turma)
);

CREATE TABLE Turma_Disciplina (
    id_turma INT,
    id_disciplina INT,

    CONSTRAINT pk_turma_disciplina 
        PRIMARY KEY (id_turma, id_disciplina),

    CONSTRAINT fk_turmadisciplina_turma 
        FOREIGN KEY (id_turma) 
        REFERENCES Turma(id_turma),

    CONSTRAINT fk_turmadisciplina_disciplina 
        FOREIGN KEY (id_disciplina) 
        REFERENCES Disciplina(id_disciplina)
);

-- INSERTS FIXOS
INSERT INTO TipoCurso (id_tipo, nome) VALUES 
(1, 'Tecnologia'),
(2, 'Licenciatura'),
(3, 'Bacharelado'),
(4, 'Engenharia');


INSERT INTO Curso (id_curso, nome, sigla, id_tipo) VALUES 
(1, 'Tecnologia em Automação Industrial', 'CSA', 1),
(2, 'Tecnologia em Gestão de Turismo', 'TUR', 1),
(3, 'Tecnologia em Análise e Desenvolvimento de Sistemas', 'ADS', 1),
(4, 'Licenciatura em Letras - Português', 'LET', 2),
(5, 'Licenciatura em Matemática', 'LMA', 2),
(6, 'Engenharia de Controle e Automação', 'ECA', 4),
(7, 'Bacharelado em Turismo', 'TUR', 3);


INSERT INTO Professor (prontuario, nome, apelido, email, titulacao) VALUES 
('WTM001', 'WELLINGTON TULER MORAES', 'Wellington', 'wellingtontm@ifsp.edu.br', 'Mestre'),
('NSP002', 'NELSON DA SILVA PAZ', 'Nelson', 'nelsonpaz@ifsp.edu.br', 'Mestre'),
('MPQ003', 'MATILDE PEREZ QUINTAIROS', 'Matilde', 'matilde.perez.quintairos@ifsp.edu.br', 'Mestre'),
('AMN004', 'ANTONIO MENDES DE OLIVEIRA NETO', 'Antonio', 'anmendes@ifsp.edu.br', 'Doutor'),
('ALF005', 'ALBERTO LUIZ FERREIRA', 'Alberto', 'alberto@ifsp.edu.br', 'Mestre'),
('SHR006', 'SÉRGIO HENRIQUE ROCHA BATISTA', 'Sergio', 'rocha.sergio@ifsp.edu.br', 'Doutor'),
('CRM007', 'CARLOS ROBERTO MARTINS', 'Carlos', 'carlos.martins@ifsp.edu.br', 'Doutor'),
('FPS008', 'FERNANDA PEREIRA SOUZA', 'Fernanda', 'fernanda.souza@ifsp.edu.br', 'Mestre'),
('RCS009', 'RICARDO CESAR SANTOS', 'Ricardo', 'ricardo.santos@ifsp.edu.br', 'Doutor'),
('PLA010', 'PATRICIA LIMA ALVES', 'Patricia', 'patricia.alves@ifsp.edu.br', 'Mestre');

INSERT INTO Disciplina (id_disciplina, nome, codigo, id_curso, prontuario_professor) VALUES 
(1, 'História da Ciência e da Tecnologia', 'HCTI1', 3, 'CRM007'),
(2, 'Inglês Técnico', 'INGL1', 3 , 'SHR006'),
(3, 'Comunicação e Expressão', 'CEEI1', 3, 'FPS008'),
(4, 'Matemática', 'MATI1', 3, 'PLA010'),
(5, 'Algoritmos e Programação', 'APOI1', 3, 'ALF005'),
(6, 'Arquitetura de Computadores', 'ARQI1', 3, 'MPQ003'),
(7, 'Desenvolvimento Web', 'DWEI1', 3,'ALF005'),
(8, 'Programação Estruturada', 'PESI1', 3, 'NSP002'),
(9, 'Matemática Financeira', 'MFII2', 3, 'PLA010'),
(10, 'Banco de Dados I', 'BD1I2', 3, 'NSP002'),
(11, 'Análise Orientada a Objetos', 'AOOI2', 3, 'WTM001'),
(12, 'Desenvolvimento Web Avançado', 'DWAI2', 3, 'ALF005'),
(13, 'Programação Orientada a Objetos', 'POOI2', 3, 'WTM001'),
(14, 'Estatística', 'ESTI2', 3, 'PLA010'),
(15, 'Introdução à Administração', 'ADMI2', 3, 'CRM007'),
(16, 'Inglês Técnico Avançado', 'IGTI2', 3, 'SHR006'),
(17, 'Engenharia de Software', 'ESWI3', 3, 'WTM001'),
(18, 'Banco de Dados II', 'BD2I3', 3, 'NSP002'),
(19, 'Interação Humano-Computador', 'IHCI3', 3, 'WTM001'),
(20, 'Qualidade de Software', 'QSWI3', 3, 'AMN004'),
(21, 'Linguagem de Programação I', 'LP1I3', 3, 'WTM001'),
(22, 'Estruturas de Dados I', 'ED1I3', 3, 'ALF005'),
(23, 'Sistemas Operacionais', 'SOPI3', 3, 'MPQ003');

INSERT INTO Turma (id_turma, nome, id_curso) VALUES 
(1, 'ADS171', 3),
(2, 'ADS271', 3),
(3, 'ADS371', 3),
(4, 'ADS471', 3),
(5, 'ADS571', 3),
(6, 'ADS671', 3);

INSERT INTO Turma_Disciplina VALUES
(1,1),
(1,2),
(1,3),
(1,4);

INSERT INTO Turma_Disciplina VALUES
(2,5),
(2,6),
(2,7),
(2,8);

INSERT INTO Turma_Disciplina VALUES
(3,9),
(3,10),
(3,11),
(3,12);

INSERT INTO Turma_Disciplina VALUES
(4,13),
(4,14),
(4,15),
(4,16);

INSERT INTO Turma_Disciplina VALUES
(5,17),
(5,18),
(5,19),
(5,20);

INSERT INTO Turma_Disciplina VALUES
(6,21),
(6,22),
(6,23);

/* Versão COM tabela de relacionamento*/


/*Inserir os 100 alunos  */
DECLARE @i INT = 1;

WHILE @i <= 100
BEGIN
    INSERT INTO Aluno (prontuario, nome, cpf, cidade, dt_nasc, email)
    VALUES (
        CONCAT('AL', RIGHT('000000' + CAST(@i AS VARCHAR), 6)),
        CONCAT('Aluno ', @i),

        RIGHT('00000000000' + CAST(ABS(CHECKSUM(NEWID())) % 10000000000 AS VARCHAR), 11),

        CASE (@i % 8)
            WHEN 0 THEN 'Santos'
            WHEN 1 THEN 'São Vicente'
            WHEN 2 THEN 'Guarujá'
            WHEN 3 THEN 'Praia Grande'
            WHEN 4 THEN 'Cubatão'
            WHEN 5 THEN 'Mongaguá'
            WHEN 6 THEN 'Itanhaém'
            ELSE 'Peruíbe'
        END,

        DATEADD(YEAR, -(14 + ABS(CHECKSUM(NEWID())) % 16), GETDATE()),

        CONCAT('aluno', @i, '@email.com')
    );

/*Distribuir entre as 6 turmas */
    INSERT INTO Aluno_Turma (prontuario, id_turma)
    VALUES (
        CONCAT('AL', RIGHT('000000' + CAST(@i AS VARCHAR), 6)),
        ((@i - 1) % 6) + 1
    );

    SET @i = @i + 1;
END;

-- TESTES 

-- ERRO: Cidade Inválida
INSERT INTO Aluno (prontuario, nome, cpf, cidade, dt_nasc, email)
VALUES ('TESTE001', 'Teste Cidade', '12345678901', 'São Paulo', '2000-01-01', 'teste@email.com');
-- ERRO: Idade não permitida
INSERT INTO Aluno (prontuario, nome, cpf, cidade, dt_nasc, email)
VALUES ('TESTE002', 'Teste Idade', '12345678902', 'Santos', GETDATE(), 'teste2@email.com');
---Valor padrão "Cubatão" 
INSERT INTO Aluno (prontuario, nome, cpf, dt_nasc, email)
VALUES ('TESTE003', 'Teste Default', '12345678903', '2000-01-01', 'teste3@email.com'); 


/* Conferência */
-- Alunos da Turma ADS171
SELECT 
    a.prontuario,
    a.nome,
    t.nome AS turma
FROM Aluno a
JOIN Aluno_Turma at ON a.prontuario = at.prontuario
JOIN Turma t ON t.id_turma = at.id_turma
WHERE t.nome = 'ADS171'
ORDER BY a.nome;
