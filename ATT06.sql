
-- Q01.O User_B poderá selecionar todos os atributos da relação INSTRUCTOR e TAKES, exceto salary e grade, respectivamente. IMPORTANTE: O User_B foi criado na avaliação contínua anterior.
CREATE VIEW dbo.vw_instructor_publico AS 
SELECT ID, name, dept_name FROM dbo.instructor;
GO

CREATE VIEW dbo.vw_takes_publico AS 
SELECT ID, course_id, sec_id, semester, year FROM dbo.takes;
GO

GRANT SELECT ON dbo.vw_instructor_publico TO User_B;
GRANT SELECT ON dbo.vw_takes_publico TO User_B;
GO


-- Q02. O User_C poderá selecionar ou modificar a relação SECTION, mas só poderá recuperar e modificar os atributos course_id, sec_id, semester e year. IMPORTANTE: O User_C foi criado na avaliação contínua anterior.

CREATE VIEW dbo.vw_section_publico AS
SELECT course_id, sec_id, semester, year FROM dbo.section; -- O que pode ver
GO

GRANT SELECT, UPDATE ON dbo.vw_section_publico TO User_C; -- Quem pode ver
GO


-- Q03. O User_D poderá selecionar qualquer atributo das relações INSTRUCTOR e STUDENT. Poderá selecionar os atributos da view grade_points. IMPORTANTE: O User_D foi criado na avaliação contínua anterior.
CREATE VIEW dbo.grade_points AS
SELECT ID, course_id, grade FROM dbo.takes;
GO
    
GRANT SELECT ON dbo.instructor TO User_D;
GRANT SELECT ON dbo.student TO User_D;
GRANT SELECT ON dbo.grade_points TO User_D;
GO


-- Q04. O User_E poderá selecionar qualquer atributo de STUDENT, mas somente para tuplas de STUDENT que tem dept_name = ‘Civil Eng.’ IMPORTANTE: O User_E foi criado na avaliação contínua anterior.
CREATE VIEW dbo.vw_Student_CivilEng AS
SELECT * FROM dbo.student
WHERE dept_name = 'Civil Eng.';
GO

GRANT SELECT ON dbo.vw_Student_CivilEng TO User_E;
GO


-- Q05. Revogue os privilégios do usuário User_E
REVOKE SELECT ON dbo.vw_Student_CivilEng FROM User_E;
GO


-- Q06. Mostre os privilégios concedidos aos usuários 'User_A', 'User_B', 'User_C', 'User_D' e 'User_E'.
SELECT 
    p.name AS Usuario,
    perm.permission_name AS Permissao, -- Pega o nome do privilégio concedido (como SELECT ou UPDATE).
    perm.state_desc AS Status, -- Permissão está ativa (GRANT) ou foi negada (DENY).
    OBJECT_NAME(perm.major_id) AS Nome_Objeto, -- Converte o ID numérico do SQL em nome real da tabela ou visão
    col.name AS Nome_Coluna -- Mostrar o nome real das colunas restringidas
FROM sys.database_permissions AS perm -- Define a tabela de origem (guarda todas as permissões do BDD)
JOIN sys.database_principals AS p ON perm.grantee_principal_id = p.principal_id -- Cruza permissões com User
LEFT JOIN sys.columns AS col ON col.object_id = perm.major_id AND col.column_id = perm.minor_id -- Traz o nome da coluna se a permissão for específica. Se for na tabela toda, mantém a linha e deixa o campo vazio.
WHERE p.name IN ('User_A', 'User_B', 'User_C', 'User_D', 'User_E') -- Filtra os resultados
ORDER BY p.name; -- Ordena os Users em ordem alfabética
