-- 1)
    SELECT 
        u.id, 
        CONCAT(p.first_name, ' ', p.last_name) AS full_name, 
        u.role,
        COUNT(r.ticket_id) AS ticket_count
    FROM "user" u
    LEFT JOIN "reservation" r ON u.id = r.user_id
    JOIN "profile" p ON u.id = p.user_id
    WHERE u.role != 'ADMIN'
    GROUP BY u.id, p.first_name, p.last_name, u.role, r.status
    HAVING COUNT(r.ticket_id) = 0
    ORDER BY u.id;

-- 2)
    SELECT 
        u.id, 
        CONCAT(pro.first_name, ' ', pro.last_name) AS full_name, 
        u.role,
        COUNT(r.ticket_id) AS ticket_count
    FROM "user" u
	INNER JOIN "profile" pro ON u.id = pro.user_id
    INNER JOIN "reservation" r ON u.id = r.user_id
	INNER JOIN "payment" pa ON pa.id = r.payment_id
    WHERE u.role != 'ADMIN' AND pa.status = 'COMPLETED'
    GROUP BY u.id, pro.first_name, pro.last_name, u.role
    HAVING COUNT(r.ticket_id) > 0
    ORDER BY u.id;

-- 3)
    SELECT 
        u.id, 
        CONCAT(pro.first_name, ' ', pro.last_name) AS full_name,
        TO_CHAR(pa.created_at, 'YYYY-MM') AS payment_month,
        SUM(pa.amount) AS total_amount
    FROM "user" u 
    INNER JOIN "reservation" r ON u.id = r.user_id
    LEFT JOIN "payment" pa ON r.payment_id = pa.id
    JOIN "profile" pro ON u.id = pro.user_id
    GROUP BY u.id, pro.first_name, pro.last_name, TO_CHAR(pa.created_at, 'YYYY-MM')
    HAVING SUM(pa.amount) IS NOT NULL
    ORDER BY u.id, payment_month;

-- 4)
    SELECT 
        u.id,
        CONCAT(pro.first_name, ' ', pro.last_name) AS full_name,
        CONCAT(dc.province, '  (', dc.county, ')') AS destination,
        COUNT(dc.county) AS "tripNO."
    FROM "user" u
    INNER JOIN "profile" pro ON u.id = pro.user_id
    INNER JOIN "reservation" re ON u.id = re.user_id
    INNER JOIN "ticket" t ON re.ticket_id = t.id
    INNER JOIN "route" ro ON t.route_id = ro.id
    INNER JOIN "city" oc ON oc.id = ro.origin_city_id
    INNER JOIN "city" dc ON dc.id = ro.destination_city_id
    GROUP BY u.id, pro.first_name, pro.last_name, dc.county, dc.province
    HAVING COUNT(dc.county) = 1
    ORDER BY u.id;

-- 5)
    SELECT 
        u.id,
        CONCAT(pro.first_name, ' ', pro.last_name) AS full_name,
        TO_CHAR(pa.created_at, 'YYYY-MM-DD	HH24:MI:SS') AS "created at"
    FROM "user" u
    INNER JOIN "profile" pro ON u.id = pro.user_id
    INNER JOIN "reservation" re ON u.id = re.user_id
    INNER JOIN "ticket" t ON re.ticket_id = t.id
    INNER JOIN "payment" pa ON pa.id = re.payment_id
    WHERE pa.status = 'COMPLETED'
    ORDER BY pa.created_at DESC
    LIMIT 1;

-- 6)
    SELECT 
        u.id, 
        COALESCE(u.email, 'No Email') AS email, 
        COALESCE(u.phone_number, 'No Phone') AS phone_number, 
        SUM(p.amount) AS "total amount" FROM "user" u
    INNER JOIN "reservation" r ON u.id = r.user_id
    INNER JOIN "payment" p ON p.id = r.payment_id
    GROUP BY u.id, u.email, u.phone_number
    HAVING SUM(p.amount) > (SELECT AVG(p.amount)
        FROM "user" u
        INNER JOIN "reservation" re ON re.user_id = u.id
        INNER JOIN "payment" p ON p.id = re.payment_id
        WHERE p.status = 'COMPLETED'
    );

-- 7)
    SELECT 
        t.vehicle_type, 
        COUNT(t.id) AS "NO." 
    FROM "ticket" t
    INNER JOIN "reservation" r ON r.ticket_id = t.id
    INNER JOIN "payment" p ON p.id = r.payment_id
    WHERE p.status = 'COMPLETED'
    GROUP BY t.vehicle_type
    ORDER BY "NO." DESC;

-- 8)
    SELECT 
        u.id, 
        CONCAT(pro.first_name, ' ', pro.last_name) AS full_name, 
        COUNT(re.id) AS "NO."
    FROM "user" u
    INNER JOIN "profile" pro ON u.id = pro.user_id
    INNER JOIN "reservation" re ON u.id = re.user_id
    INNER JOIN "payment" pa ON pa.id = re.payment_id
    WHERE pa.status = 'COMPLETED' AND pa.created_at > NOW() - INTERVAL '7 days'
    GROUP BY u.id, pro.first_name, pro.last_name
    ORDER BY "NO." DESC
    LIMIT 3;

-- 9)
	SELECT 
		oc.county AS origin,
		'Tehran' AS origin,
        CONCAT(dc.province, '  (', dc.county, ')') AS destination,
        COUNT(dc.county) AS "tripNO."
    FROM "ticket" t
    INNER JOIN "reservation" re ON t.id = re.ticket_id
    INNER JOIN "route" ro ON t.route_id = ro.id
    INNER JOIN "city" oc ON oc.id = ro.origin_city_id
    INNER JOIN "city" dc ON dc.id = ro.destination_city_id
	WHERE oc.county = 'Tehran'
    GROUP BY oc.county, dc.province, dc.county;

-- 10)
    SELECT 
        u.id, 
		CONCAT(oc.province, '  (', oc.county, ')') AS origin
	FROM "user" u
    INNER JOIN "reservation" re ON u.id = re.user_id
    INNER JOIN "payment" pa ON pa.id = re.payment_id
    INNER JOIN "ticket" t ON re.ticket_id = t.id
    INNER JOIN "route" ro ON t.route_id = ro.id
    INNER JOIN "city" oc ON oc.id = ro.origin_city_id
    WHERE u.id = (SELECT u.id FROM "user" u 
    WHERE u.role = 'USER'
    ORDER BY u.created_at DESC 
    LIMIT 1) AND pa.status = 'COMPLETED'
    GROUP BY u.id, oc.province, oc.county;

-- 11)
    SELECT 
        u.id,
        CONCAT(pro.first_name, ' ', pro.last_name) AS full_name
    FROM "user" u
    INNER JOIN "profile" pro ON u.id = pro.user_id
    WHERE u.role = 'ADMIN'
    ORDER BY u.id;

-- 12)
	SELECT 
        u.id, 
        CONCAT(pro.first_name, ' ', pro.last_name) AS full_name, 
        u.role,
        COUNT(r.ticket_id) AS ticket_count
    FROM "user" u
	INNER JOIN "profile" pro ON u.id = pro.user_id
    INNER JOIN "reservation" r ON u.id = r.user_id
	INNER JOIN "payment" pa ON pa.id = r.payment_id
    WHERE u.role != 'ADMIN' AND pa.status = 'COMPLETED'
    GROUP BY u.id, pro.first_name, pro.last_name, u.role
    HAVING COUNT(r.ticket_id) > 1
    ORDER BY u.id;

-- 13)
	SELECT 
        u.id, 
        CONCAT(pro.first_name, ' ', pro.last_name) AS full_name, 
        t.vehicle_type,
        COUNT(r.ticket_id) AS ticket_count
    FROM "user" u
	INNER JOIN "profile" pro ON u.id = pro.user_id
    INNER JOIN "reservation" r ON u.id = r.user_id
	INNER JOIN "payment" pa ON pa.id = r.payment_id
	INNER JOIN "ticket" t ON t.id = r.ticket_id
    WHERE pa.status = 'COMPLETED'
    GROUP BY u.id, pro.first_name, pro.last_name, t.vehicle_type
    HAVING COUNT(r.ticket_id) > 1
    ORDER BY u.id;

-- 15)
    SELECT 
        u.id,
        CONCAT(pro.first_name, ' ', pro.last_name) AS full_name, 
        t.id AS "ticket id",
        t.vehicle_type,
        TO_CHAR(pa.created_at, 'YYYY-MM-DD HH24:MI:SS') AS issued
    FROM "user" u
    INNER JOIN "profile" pro ON u.id = pro.user_id
    INNER JOIN "reservation" r ON u.id = r.user_id
    INNER JOIN "ticket" t ON  t.id = r.ticket_id
    INNER JOIN "payment" pa ON  pa.id = r.payment_id
    WHERE pa.status = 'COMPLETED' AND pa.created_at >= date_trunc('day', now())
    ORDER BY pa.created_at;

-- 17)
    WITH canceled_changes AS (
    SELECT 
        cr.admin_id, 
        CONCAT(pro.first_name, ' ', pro.last_name) AS full_name,
        COUNT(cr.id) AS cancel_count
    FROM change_reservation cr
    INNER JOIN "profile" pro ON pro.user_id = cr.admin_id
    WHERE cr.from_status NOT IN ('CANCELED', 'CANCELED-BY-TIME')
        AND cr.to_status = 'CANCELED'
    GROUP BY cr.admin_id, pro.first_name, pro.last_name
    ),
    total_canceled AS (
    SELECT COUNT(*) AS total FROM change_reservation
    WHERE from_status NOT IN ('CANCELED', 'CANCELED-BY-TIME')
        AND to_status = 'CANCELED'
    )
    SELECT 
    cc.admin_id,
    cc.full_name,
    cc.cancel_count AS "NO. of Cancellations",
    ROUND((cc.cancel_count::decimal / tc.total) * 100, 2) AS "Cancellation Percentage"
    FROM canceled_changes cc, total_canceled tc
    ORDER BY cc.cancel_count DESC
    LIMIT 1; 

-- 18)
    UPDATE "profile"
    SET last_name = 'Redington'
    WHERE user_id = (
    SELECT cr.user_id
    FROM "change_reservation" cr
    WHERE cr.from_status NOT IN ('CANCELED', 'CANCELED-BY-TIME')
        AND cr.to_status = 'CANCELED'
    GROUP BY cr.user_id
    ORDER BY COUNT(cr.id) DESC
    LIMIT 1
    );

-- 19)
    DELETE FROM "reservation" r
    WHERE r.user_id = (SELECT pro.user_id FROM "profile" pro
    WHERE pro.last_name = 'Redigton'
    LIMIT 1) AND r.status IN ('CANCELED', 'CANCELED-BY-TIME');

-- 20)
    DELETE FROM "reservation" re
    WHERE re.status IN ('CANCELED', 'CANCELED-BY-TIME');

-- 22) 
    SELECT 
        rep.*, 
        sub.rep_count
    FROM "report" rep 
    INNER JOIN (SELECT  
            rep.reservation_id,
            COUNT(rep.reservation_id) AS rep_count
        FROM "reservation" re
        INNER JOIN "report" rep ON rep.reservation_id = re.id
        GROUP BY rep.user_id, rep.reservation_id
        ORDER BY rep_count DESC LIMIT 1
    ) sub ON rep.reservation_id = sub.reservation_id;