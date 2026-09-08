--08_09_26
--Cubo OLAP: a última peça

--É a visão do star schema como um espaço de várias dimensões,
--onde cada célula guarda uma métrica já agregada.

--Dimensões (exemplo):
--Tempo   (y): meses
--Produto (x): bebidas, higiene, casa, etc
--Filial  (z): A, B, C, D,...

--célula(fev, casa, filial A)
--receita = R$ 18.420,00

--As quatro perações do cubo
--Slice                                    (WHERE d.month=3)
--Dice                                     (WHERE com vários IN)
--Drill-down (detalha) / roll-up (agrega)  (GROUP BY: de year para month, por ex.)
--Pivot                                    (equivalente à tabela dinâmica do Excel)

--No PostgreSQL
-- GROUPING SETS
--ROLLUP
--CUBE

--Cód.27.Subtotais automáticos com ROLLUP e CUBE
--ROLLUP
SELECT
    b.branch_code               AS filial,
    d.month_name                AS mes,
    SUM(f.total)::NUMERIC(12,2) AS receita
FROM dw.fact_sales f 
JOIN dw.dim_branch b ON b.branch_sk = f.branch_sk 
JOIN dw.dim_date   d ON d.date_sk   = f.date_sk
GROUP BY ROLLUP(b.branch_code, d.month_name) 
HAVING b.branch_code IS NOT NULL AND d.month_name IS NOT NULL
ORDER BY b.branch_code, d.month_name;

--CUBE
SELECT 
    COALESCE(b.branch_code, 'TODAS')  AS filial,
    COALESCE(p.payment_type, 'TODOS') AS pagamento,
    SUM(f.total)::NUMERIC(12,2)       AS receita
FROM dw.fact_sales f
JOIN dw.dim_branch b ON b.branch_sk = f.branch_sk 
JOIN dw.dim_payment p ON p.payment_sk = f.payment_sk
GROUP BY CUBE(b.branch_code, p.payment_type)
ORDER BY filial, pagamento;
