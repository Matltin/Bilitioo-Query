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

func TestGetUsersWithTickets(t *testing.T) {
	users, err := testQueries.GetUserWithTickets(context.Background())

	require.NoError(t, err)
	require.NotNil(t, users)
	require.Equal(t,len(users), 3)

	for i := 0; i < len(users); i++ {
		require.NotEqual(t, users[i].TicketCount, 0)
	}
}

func TestGetSumOfPaymentInDifferentMonth(t *testing.T) {
	users, err := testQueries.GetSumOfPaymentInDifferentMonth(context.Background())

	require.NoError(t, err)
	require.NotNil(t, users)
	require.Equal(t, len(users), 4)
}

func TestGetUserWithOneTicketInCity(t *testing.T) {
	users, err := testQueries.GetUserWithOneTicketInCity(context.Background())

	require.NoError(t, err)
	require.NotNil(t, users)
	require.Equal(t, len(users), 9)
	for i := 0; i < len(users); i++ {
		require.Equal(t, users[i].TripNO, int64(1))
	}
}

func TestGetUserInfoWithNewTicket (t *testing.T) {
	user, err := testQueries.GetUserInfoWithNewTicket(context.Background())

	require.NoError(t, err)
	require.NotNil(t, user)
	require.Equal(t, user.ID, int64(6))
	require.Equal(t, user.FullName, "Mohammad Ghasemi")

}

