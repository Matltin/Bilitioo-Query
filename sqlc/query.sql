-- name: GetUsersWithNoTickets :many
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