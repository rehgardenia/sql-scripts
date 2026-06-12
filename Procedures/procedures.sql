
Create Database TpStored
go
Use TpStored
go

create table cursos
(id_curso int identity not null,
 nome_curso varchar(100) not null,
 descricao varchar(200) not null,
 valor decimal(7,2),
 max_parcelas int,
 constraint pk_cursos primary key (id_curso)
 )

 INSERT INTO cursos (nome_curso, descricao, valor, max_parcelas) VALUES
('Desenvolvimento Web com HTML, CSS e JavaScript',
 'Curso voltado ao desenvolvimento de páginas e sistemas web responsivos.',
 1200.00, 6),

('Programação em C#',
 'Curso de programação orientada a objetos utilizando a linguagem C# e .NET.',
 1800.00, 8),

('Banco de Dados com SQL Server',
 'Modelagem, criação e manipulação de bancos de dados no MS SQL Server.',
 1500.00, 6),

('Desenvolvimento Mobile Android',
 'Criação de aplicativos Android utilizando Kotlin e Android Studio.',
 2200.00, 10),

('Redes de Computadores',
 'Fundamentos de redes, protocolos, cabeamento e configuração de dispositivos.',
 1400.00, 5),

('Segurança da Informação',
 'Princípios de segurança digital, criptografia e proteção de sistemas.',
 2100.00, 8),

('Python para Ciência de Dados',
 'Curso de programação Python aplicado à análise e manipulação de dados.',
 2500.00, 10),

('Inteligência Artificial e Machine Learning',
 'Introdução aos conceitos de IA, aprendizado de máquina e aplicações práticas.',
 3200.00, 12),

('Administração de Sistemas Linux',
 'Instalação, configuração e administração de servidores Linux.',
 1700.00, 6),

('Desenvolvimento de Jogos Digitais',
 'Criação de jogos digitais utilizando motores gráficos e lógica de programação.',
 2800.00, 12);

go

Create table matricula

(id_matricula int not null,
 cpf char(11) not null,
 nome varchar(50) not null,
 genero char(1) not null,
 email varchar(100) not null,
 id_curso int not null,
 dt_matricula date,
 parcelas int,
 status int,
 constraint pk_matricula primary key(id_matricula),
 constraint fk_matricula_curso foreign key(id_curso)
            references cursos(id_curso)
)
go


create table mensalidades
(
 id_mensalidade int identity,
 id_matricula int not null,
 parcela int not null,
 dt_vencimento date not null,
 valor decimal(7,2) not null,
 dt_pagto date null,
 status int not null,
 constraint pk_mensalidades primary key(id_mensalidade),
 constraint fk_mensalidade_matricula foreign key(id_matricula) references matricula(id_matricula)
 )
go

-- DADOS PARA TABELA MATRICULA
INSERT INTO Matricula
(id_matricula, cpf, nome, genero, email, id_curso, dt_matricula, parcelas, status)
VALUES
(1, '12345678901', 'João Silva', 'M', 'joao@gmail.com', 1, '2026-01-10', 6, 1),

(2, '98765432100', 'Maria Oliveira', 'F', 'maria@gmail.com', 3, '2026-02-15', 5, 1),

(3, '45678912345', 'Carlos Souza', 'M', 'carlos@gmail.com', 7, '2026-03-05', 10, 1),

(4, '74185296300', 'Ana Costa', 'F', 'ana@gmail.com', 2, '2026-04-12', 8, 1),

(5, '15935745688', 'Fernanda Lima', 'F', 'fernanda@gmail.com', 5, '2026-05-20', 5, 0);
GO


-- DADOS PARA TABELA MENSALIDADES
INSERT INTO mensalidades
(id_matricula, parcela, dt_vencimento, valor, dt_pagto, status)
VALUES
(1, 1, '2026-02-10', 200.00, '2026-02-09', 1),
(2, 1, '2026-03-15', 300.00, '2026-03-14', 1),
(3, 1, '2026-04-05', 250.00, NULL, 0),
(4, 1, '2026-05-12', 225.00, '2026-05-10', 1),
(5, 1, '2026-06-20', 280.00, NULL, 0);
GO

SELECT * FROM Matricula;
/*PROPOSTA 01*/

CREATE PROCEDURE sp_InsereMatricula
(
    @id_matricula INT,
    @cpf VARCHAR(20),
    @nome VARCHAR(50),
    @genero CHAR(1),
    @email VARCHAR(100),
    @id_curso INT,
    @parcelas INT
)
AS
BEGIN
	DECLARE
		@cpf_limpo CHAR(11),
        @nome_formatado VARCHAR(50),
        @email_formatado VARCHAR(100),
        @genero_formatado CHAR(1),
        @max_parcelas INT,
        @valor_curso DECIMAL(7,2),
        @valor_parcela DECIMAL(7,2),
        @contador INT = 1

	-- Remove caracteres do CPF
    SET @cpf_limpo =
        REPLACE(REPLACE(REPLACE(@cpf,'.',''),'-',''),' ','')

    -- Nome em maiúsculo sem espaços extras
    SET @nome_formatado = UPPER(LTRIM(RTRIM(@nome)))

    -- Email em minúsculo
    SET @email_formatado = LOWER(@email)

    -- Gênero válido
    SET @genero_formatado = UPPER(@genero)

    IF @genero_formatado NOT IN ('M','F','O','N')
        SET @genero_formatado = 'N'

		-- Busca dados do curso
    SELECT
        @max_parcelas = max_parcelas,
        @valor_curso = valor
    FROM cursos
    WHERE id_curso = @id_curso

    -- Regras das parcelas
    IF @parcelas <= 0
        SET @parcelas = 1

    IF @parcelas > @max_parcelas
        SET @parcelas = @max_parcelas

    -- Calcula valor da parcela
    SET @valor_parcela = @valor_curso / @parcelas

    -- Inserção da matrícula
    INSERT INTO Matricula
    (
        id_matricula,
        cpf,
        nome,
        genero,
        email,
        id_curso,
        dt_matricula,
        parcelas,
        status
    )
    VALUES
    (
        @id_matricula,
        @cpf_limpo,
        @nome_formatado,
        @genero_formatado,
        @email_formatado,
        @id_curso,
        GETDATE(),
        @parcelas,
        1
    )

    -- Inserção das mensalidades
    WHILE @contador <= @parcelas
    BEGIN

        INSERT INTO mensalidades
        (
            id_matricula,
            parcela,
            dt_vencimento,
            valor,
            dt_pagto,
            status
        )
        VALUES
        (
            @id_matricula,
            @contador,
            DATEADD(MONTH, @contador, GETDATE()),
            @valor_parcela,
            NULL,
            1
        )

        SET @contador = @contador + 1

    END
END
go

EXEC sp_InsereMatricula
    @id_matricula = 10,
    @cpf = '123.456.789-00',
    @nome = '  João da Silva  ',
    @genero = 'm',
    @email = 'JOAO@GMAIL.COM',
    @id_curso = 2,
    @parcelas = 12
GO


/*PROPOSTA 02*/
CREATE PROCEDURE sp_cancelaMatricula
	@id_matricula int ,
	@dt_cancelamento date
AS
BEGIN
	UPDATE Matricula
	SET status = 0
	WHERE id_matricula = @id_matricula

	UPDATE mensalidades
    SET status = 0
    WHERE id_matricula = @id_matricula
      AND dt_vencimento > @dt_cancelamento

END

EXEC sp_cancelaMatricula
     @id_matricula = 3,
     @dt_cancelamento = '2026-04-10'
GO

/*PROPOSTA 03 - EXIBIR Nome, Nome do Curso, Data da Matricula, Valor do Curso*/
CREATE PROCEDURE sp_exibeMatricula 
   @cpf CHAR(11)
AS
BEGIN
    SELECT
        m.nome AS Nome,
        c.nome_curso AS [Nome do Curso],
        m.dt_matricula AS [Data da Matricula],
        c.valor AS [Valor do Curso]
    FROM Matricula m
    INNER JOIN cursos c
        ON m.id_curso = c.id_curso
    WHERE m.cpf = @cpf
END
GO

EXEC sp_exibeMatricula '12345678901';

