-- 1) 
    DROP FUNCTION IF EXISTS get_tickets(VARCHAR);

    CREATE OR REPLACE FUNCTION get_tickets(inp VARCHAR)
    RETURNS TABLE(
        "user id" BIGINT,
        "ticket id" BIGINT,
        "reservation id" BIGINT,
        "payment id" BIGINT,
        "origin city" VARCHAR,
        "destination city" VARCHAR,
        "time" VARCHAR
    )
    LANGUAGE plpgsql
    AS $$
    BEGIN
        RETURN QUERY 
        SELECT 
            u.id AS "user id", 
            t.id AS "ticket id", 
            re.id AS "reservation id", 
            p.id AS "payment id", 
            oc.county AS "origin city", 
            dc.county AS "destination city",
            TO_CHAR(p.created_at, 'YYYY-MM-DD HH24:MI:SS')::VARCHAR AS time
        FROM "user" u
        INNER JOIN "reservation" re ON re.user_id = u.id
        INNER JOIN "ticket" t ON t.id = re.ticket_id
        INNER JOIN "payment" p ON p.id = re.payment_id
        INNER JOIN "route" ro ON ro.id = t.route_id
        INNER JOIN "city" oc ON oc.id = ro.origin_city_id
        INNER JOIN "city" dc ON dc.id = ro.destination_city_id
        WHERE (u.email = inp OR u.phone_number = inp) AND p.status = 'COMPLETED'
        ORDER BY time;
    END;
    $$;

-- 2) 
    DROP FUNCTION IF EXISTS get_change_reservation(VARCHAR);

    CREATE OR REPLACE FUNCTION get_change_reservation(inp VARCHAR)
    RETURNS TABLE(
        "user id" BIGINT,
        "full name" VARCHAR,
        "from status" VARCHAR,
        "to status" VARCHAR
    )
    LANGUAGE plpgsql
    AS $$
    BEGIN
        RETURN QUERY 
        SELECT 
            u_user.id,
            CONCAT(pro.first_name, ' ', pro.last_name)::VARCHAR AS full_name, 
            cr.from_status::VARCHAR,
            cr.to_status::VARCHAR
        FROM "change_reservation" cr
        INNER JOIN "user" u_admin ON u_admin.id = cr.admin_id
        INNER JOIN "user" u_user ON u_user.id = cr.user_id
        INNER JOIN "profile" pro ON pro.user_id = u_user.id
        WHERE (u_admin.email = inp OR u_admin.phone_number = inp)
        AND cr.from_status NOT IN ('CANCELED')
        AND cr.to_status IN ('CANCELED')
        ORDER BY u_user.id;
    END;
    $$;

-- 3)
    DROP FUNCTION IF EXISTS get_tickets_city(VARCHAR);

    CREATE OR REPLACE FUNCTION get_tickets_city(inp_city VARCHAR)
    RETURNS TABLE(
        ticket_id BIGINT,
        origin_city VARCHAR,
    destination_city VARCHAR,
        vehicle_type VARCHAR
    )
    LANGUAGE plpgsql
    AS $$
    BEGIN
        RETURN QUERY 
        SELECT 
            t.id,
            CONCAT(oc.province, '  (', oc.county, ')')::VARCHAR AS origin_city,
      inp_city AS destination_city,
            t.vehicle_type::VARCHAR
        FROM "ticket" t
        INNER JOIN "route" ro ON ro.id = t.route_id
        INNER JOIN "city" oc ON oc.id = ro.origin_city_id
        INNER JOIN "city" dc ON dc.id = ro.destination_city_id
        INNER JOIN "reservation" re ON re.ticket_id = t.id
        INNER JOIN "payment" pa ON pa.id = re.payment_id
        WHERE (dc.county = inp_city OR dc.province = inp_city) 
        AND pa.status = 'COMPLETED'
        ORDER BY t.id;
    END;
    $$;

-- 4) 
    DROP FUNCTION IF EXISTS get_find_match(VARCHAR);

    CREATE OR REPLACE FUNCTION get_find_match(inp VARCHAR)
    RETURNS TABLE(
        user_id BIGINT,
        ticket_id BIGINT,
        full_name VARCHAR,
        origin_city VARCHAR,
        destination_city VARCHAR,
    extra_info VARCHAR
    )
    LANGUAGE plpgsql
    AS $$
    BEGIN
        RETURN QUERY 
        
        SELECT 
            u.id,
            t.id,
            CONCAT(p.first_name, ' ', p.last_name)::VARCHAR AS full_name, 
            CONCAT(oc.province, '  (', oc.county, ')')::VARCHAR AS origin_city,
            CONCAT(dc.province, '  (', dc.county, ')')::VARCHAR AS destination_city,
      (CASE 
              WHEN b."VIP" IS NOT NULL THEN 
                  CASE WHEN b."VIP" THEN 'VIP' ELSE 'Not VIP' END
              WHEN tr.rank IS NOT NULL THEN 'Train Rank: ' || tr.rank
              WHEN ai.flight_class IS NOT NULL THEN 'Flight Class: ' || ai.flight_class
              ELSE NULL
          END)::VARCHAR AS extra_info
        FROM "ticket" t
        INNER JOIN "reservation" re ON re.ticket_id = t.id
        INNER JOIN "user" u ON u.id = re.user_id
        INNER JOIN "profile" p ON p.user_id = u.id
        INNER JOIN "route" ro ON ro.id = t.route_id
        INNER JOIN "city" oc ON oc.id = ro.origin_city_id
        INNER JOIN "city" dc ON dc.id = ro.destination_city_id
        INNER JOIN "vehicle" v ON v.id = t.vehicle_id
        LEFT JOIN "bus" b ON v.id = b.vehicle_id
        LEFT JOIN "train" tr ON v.id = tr.vehicle_id
        LEFT JOIN "airplane" ai ON v.id = ai.vehicle_id
        WHERE CONCAT(p.first_name, ' ', p.last_name) ILIKE CONCAT('%', inp, '%') OR
            CONCAT(oc.province, '  (', oc.county, ')') ILIKE CONCAT('%', inp, '%') OR
            CONCAT(dc.province, '  (', dc.county, ')') ILIKE CONCAT('%', inp, '%') OR
            tr.rank::VARCHAR ILIKE CONCAT('%', inp, '%') OR
            (
                'vip' ILIKE CONCAT('%', inp, '%') 
            ) OR (
                'notvip' ILIKE CONCAT('%', inp, '%')
            ) OR
            ai.flight_class::VARCHAR ILIKE CONCAT('%', inp, '%');
    END;
    $$;

-- 5) 
    DROP FUNCTION IF EXISTS get_townsman(VARCHAR);

    CREATE OR REPLACE FUNCTION get_townsman(inp VARCHAR)
    RETURNS TABLE(
        user_id BIGINT,
        full_name VARCHAR,
        email VARCHAR,
        phone_number VARCHAR,
        city VARCHAR
    )
    LANGUAGE plpgsql
    AS $$
    BEGIN
        RETURN QUERY 
        SELECT
            u.id,
            CONCAT(p.first_name, ' ', p.last_name)::VARCHAR AS full_name,
            u.email,
            u.phone_number,
            CONCAT(c.province, '  (', c.county, ')')::VARCHAR AS city
        FROM "user" u
        INNER JOIN "profile" p ON u.id = p.user_id
        INNER JOIN "city" c ON c.id = p.city_id
        WHERE p.city_id = (
            SELECT 
                pro.city_id 
            FROM "user" u
            INNER JOIN "profile" pro ON pro.user_id = u.id
            WHERE u.email = inp OR u.phone_number = inp
            LIMIT 1
        );
    END;
    $$;

-- 6)
    DROP FUNCTION IF EXISTS get_person_by_time(INT, TIMESTAMPTZ);

    CREATE OR REPLACE FUNCTION get_person_by_time(n INT, start_time TIMESTAMPTZ)
    RETURNS TABLE (
        user_id BIGINT,
        full_name VARCHAR,
        reservation_count BIGINT
    )
    LANGUAGE plpgsql
    AS $$
    BEGIN
        RETURN QUERY 
        SELECT 
            u.id,
            CONCAT(pro.first_name, ' ', pro.last_name)::VARCHAR AS full_name,
            COUNT(re.id) AS reservation_count
        FROM "user" u
        INNER JOIN "profile" pro ON u.id = pro.user_id
        INNER JOIN "reservation" re ON u.id = re.user_id
        INNER JOIN "payment" pa ON pa.id = re.payment_id
        WHERE pa.status = 'COMPLETED' AND pa.created_at >= start_time
        GROUP BY u.id, pro.first_name, pro.last_name
        ORDER BY reservation_count DESC
        LIMIT n;
    END;
    $$;

-- 7)
    DROP FUNCTION IF EXISTS get_canceld_by_vehicle(VARCHAR);

    CREATE OR REPLACE FUNCTION get_canceld_by_vehicle(inp_vehicle VARCHAR)
    RETURNS TABLE (
        ticket_id BIGINT,
        vehicle_type VARCHAR,
        origin_city VARCHAR,
        destination_city VARCHAR
    )
    LANGUAGE plpgsql
    AS $$
    BEGIN
        RETURN QUERY 
        SELECT
            t.id AS ticket_id,
            t.vehicle_type::VARCHAR AS vehicle_type,
            CONCAT(oc.province, '  (', oc.county, ')')::VARCHAR AS origin_city,
            CONCAT(dc.province, '  (', dc.county, ')')::VARCHAR AS destination_city
        FROM "ticket" t
        INNER JOIN "reservation" re ON re.ticket_id = t.id
        INNER JOIN "route" ro ON ro.id = t.route_id
        INNER JOIN "city" oc ON oc.id = ro.origin_city_id
        INNER JOIN "city" dc ON dc.id = ro.destination_city_id
        WHERE inp_vehicle ILIKE t.vehicle_type::VARCHAR
        AND re.status IN ('CANCELED', 'CANCELED-BY-TIME')
        ORDER BY t.created_at;
    END;
    $$;

-- 8)
    DROP FUNCTION IF EXISTS get_request_type(VARCHAR);

    CREATE OR REPLACE FUNCTION get_request_type(inp VARCHAR)
    RETURNS TABLE(
        id BIGINT,
        full_name VARCHAR,
        report_count VARCHAR
    )
    LANGUAGE plpgsql
    AS $$
    BEGIN
        RETURN QUERY 
        WITH report_counts AS (
            SELECT 
                u.id AS user_id, 
                COUNT(*) AS rep_count
            FROM "user" u
            INNER JOIN "report" r ON r.user_id = u.id
            GROUP BY u.id
        )
        SELECT 
            u.id,
            CONCAT(p.first_name, ' ', p.last_name)::VARCHAR AS full_name,
            rc.rep_count::VARCHAR
        FROM report_counts rc
        JOIN "user" u ON u.id = rc.user_id
        JOIN "profile" p ON p.user_id = u.id
        WHERE rc.rep_count = (
            SELECT MAX(rep_count) 
            FROM report_counts
        );
    END;
    $$;
