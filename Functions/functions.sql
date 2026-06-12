EXEC sp_executesql N'
CREATE FUNCTION fn_Triplo (@numero INT)
RETURNS INT AS
BEGIN RETURN @numero * 3 END'

EXEC sp_executesql N'
CREATE FUNCTION fn_Quadrado (@numero DECIMAL(18,4))
RETURNS DECIMAL(18,4) AS
BEGIN RETURN @numero * @numero END'

EXEC sp_executesql N'
CREATE FUNCTION fn_ParImpar (@numero INT)
RETURNS VARCHAR(5) AS
BEGIN
    DECLARE @r VARCHAR(5)
    IF @numero % 2 = 0 SET @r = ''PAR'' ELSE SET @r = ''IMPAR''
    RETURN @r
END'

EXEC sp_executesql N'
CREATE FUNCTION fn_Maioridade (@idade INT)
RETURNS VARCHAR(20) AS
BEGIN
    DECLARE @r VARCHAR(20)
    IF @idade >= 18 SET @r = ''MAIOR DE IDADE'' ELSE SET @r = ''MENOR DE IDADE''
    RETURN @r
END'

EXEC sp_executesql N'
CREATE FUNCTION fn_Maioridade1 (@data_nasc DATE)
RETURNS VARCHAR(20) AS
BEGIN
    DECLARE @idade INT, @r VARCHAR(20)
    SET @idade = DATEDIFF(YEAR, @data_nasc, GETDATE())
    IF DATEADD(YEAR, @idade, @data_nasc) > GETDATE() SET @idade = @idade - 1
    IF @idade >= 18 SET @r = ''MAIOR DE IDADE'' ELSE SET @r = ''MENOR DE IDADE''
    RETURN @r
END'

EXEC sp_executesql N'
CREATE FUNCTION fn_Desconto (@preco DECIMAL(10,2), @percentual DECIMAL(5,2))
RETURNS DECIMAL(10,2) AS
BEGIN
    DECLARE @r DECIMAL(10,2)
    SET @r = @preco - (@preco * @percentual / 100)
    RETURN @r
END'

EXEC sp_executesql N'
CREATE FUNCTION fn_FormataCPF (@cpf VARCHAR(20))
RETURNS VARCHAR(12) AS
BEGIN
    SET @cpf = REPLACE(REPLACE(REPLACE(REPLACE(@cpf,''.'',''''),'','',''''),''-'',''''),''/'','''')
    RETURN LEFT(@cpf,9)+''-''+RIGHT(@cpf,2)
END'

EXEC sp_executesql N'
CREATE FUNCTION fn_Conceito (@nota DECIMAL(4,2))
RETURNS CHAR(1) AS
BEGIN
    DECLARE @c CHAR(1)
    IF @nota >= 9 SET @c=''A''
    ELSE IF @nota >= 7 SET @c=''B''
    ELSE IF @nota >= 5 SET @c=''C''
    ELSE SET @c=''D''
    RETURN @c
END'

EXEC sp_executesql N'
CREATE FUNCTION fn_StrZero (@numero DECIMAL(18,2), @tamanho INT)
RETURNS VARCHAR(50) AS
BEGIN
    DECLARE @s VARCHAR(50)
    SET @s = CAST(CAST(ROUND(@numero*100,0) AS BIGINT) AS VARCHAR(50))
    WHILE LEN(@s) < @tamanho SET @s = ''0''+@s
    RETURN @s
END'

EXEC sp_executesql N'
CREATE FUNCTION fn_ValidaCPF (@cpf VARCHAR(20))
RETURNS BIT AS
BEGIN
    SET @cpf = REPLACE(REPLACE(REPLACE(REPLACE(@cpf,''.'',''''),''-'',''''),''/'',''''),'' '','''')
    IF LEN(@cpf)<>11 RETURN 0
    IF @cpf=REPLICATE(LEFT(@cpf,1),11) RETURN 0
    DECLARE @soma INT=0, @i INT=1
    WHILE @i<=9 BEGIN SET @soma=@soma+CAST(SUBSTRING(@cpf,@i,1) AS INT)*(11-@i) SET @i=@i+1 END
    DECLARE @resto INT=@soma%11, @d1 INT=CASE WHEN @soma%11<2 THEN 0 ELSE 11-@soma%11 END
    IF @d1<>CAST(SUBSTRING(@cpf,10,1) AS INT) RETURN 0
    SET @soma=0 SET @i=1
    WHILE @i<=10 BEGIN SET @soma=@soma+CAST(SUBSTRING(@cpf,@i,1) AS INT)*(12-@i) SET @i=@i+1 END
    DECLARE @d2 INT=CASE WHEN @soma%11<2 THEN 0 ELSE 11-@soma%11 END
    IF @d2<>CAST(SUBSTRING(@cpf,11,1) AS INT) RETURN 0
    RETURN 1
END'

SELECT dbo.fn_Triplo(5)                    AS fn_Triplo
SELECT dbo.fn_Quadrado(7)                  AS fn_Quadrado
SELECT dbo.fn_ParImpar(4)                  AS fn_ParImpar
SELECT dbo.fn_Maioridade(20)               AS fn_Maioridade
SELECT dbo.fn_Maioridade1('2000-01-01')    AS fn_Maioridade1
SELECT dbo.fn_Desconto(200.00, 10)         AS fn_Desconto
SELECT dbo.fn_FormataCPF('123.456.789-09') AS fn_FormataCPF
SELECT dbo.fn_Conceito(8.5)               AS fn_Conceito
SELECT dbo.fn_StrZero(100.34, 9)           AS fn_StrZero
SELECT dbo.fn_ValidaCPF('529.982.247-25')  AS fn_ValidaCPF