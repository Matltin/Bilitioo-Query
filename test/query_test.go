package db

import (
	"context"
	"testing"

	"github.com/stretchr/testify/require"
)

func TestGetUsersWithNoTickets(t *testing.T) {
	users, err := testQueries.GetUsersWithNoTickets(context.Background())

	require.NoError(t, err)
	require.NotNil(t, users)
	require.Equal(t, len(users), 7)
}