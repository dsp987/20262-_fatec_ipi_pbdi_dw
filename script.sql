--valores aleatórios

DO $$
DECLARE
	n1 NUMERIC(5, 2);
	n2 INTEGER;
	limite_inferior INTEGER := 5;
	limite_superior INTEGER := 17;	
BEGIN
	-- 0 <= n1 < 1:
	n1 := random();
	RAISE NOTICE '%', n1;
	n1 := random() * 10 + 1;
	RAISE NOTICE '%', n1;
	n2 := floor(random() * 10 + 1)::INT;
	RAISE NOTICE '%', n2;
	n2 := floor(random() * 12 + 5)::INT;
	RAISE NOTICE '%', n2;
END;
$$