package db

import (
	"context"
	"database/sql"
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
	require.Equal(t, len(users), 3)

	for i := 0; i < len(users); i++ {
		require.NotEqual(t, users[i].TicketCount, 0)
	}
}

func TestGetSumOfPaymentInDifferentMonth(t *testing.T) {
	users, err := testQueries.GetSumOfPaymentInDifferentMonth(context.Background())

	require.NoError(t, err)
	require.NotNil(t, users)
	require.Equal(t, len(users), 3)
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

func TestGetUserInfoWithNewTicket(t *testing.T) {
	user, err := testQueries.GetUserInfoWithNewTicket(context.Background())

	require.NoError(t, err)
	require.NotNil(t, user)
	require.Equal(t, user.UserID, int64(6))

}

func TestGetUserMoreThanAmountAvrage(t *testing.T) {
	users, err := testQueries.GetUserMoreThanAmountAvrage(context.Background())

	require.NoError(t, err)
	require.NotNil(t, users)
	require.Equal(t, len(users), 2)
}

func TestGetCountOfTicketVehicle(t *testing.T) {
	vehicles, err := testQueries.GetCountOfTicketVehicle(context.Background())

	require.NoError(t, err)
	require.NotNil(t, vehicles)
	require.Equal(t, len(vehicles), 3)

	for i := 0; i < len(vehicles); i++ {
		require.Greater(t, vehicles[i].NO, int64(0))
	}
}

func TestGetThreeUsersWithMostPurchaseInWeek(t *testing.T) {
	users, err := testQueries.GetThreeUsersWithMostPurchaseInWeek(context.Background())

	require.NoError(t, err)
	require.NotNil(t, users)
	require.Equal(t, len(users), 3)
}

func TestGetCountOfTicketFromTehran(t *testing.T) {
	cities, err := testQueries.GetCountOfTicketFromTehran(context.Background())

	require.NoError(t, err)
	require.NotNil(t, cities)
	require.Equal(t, len(cities), 3)

	for i := 0; i < len(cities); i++ {
		require.Equal(t, cities[i].Origin, "Tehran")
		require.Greater(t, cities[i].TripNO, int64(0))
	}
}

func TestGetCityWithOldestUser(t *testing.T) {
	cities, err := testQueries.GetCityWithOldestUser(context.Background())

	require.NoError(t, err)
	require.NotNil(t, cities)

	for i := 1; i < len(cities); i++ {
		require.Equal(t, cities[i].ID, cities[i-1].ID)
	}
}

func TestGetAdminName(t *testing.T) {
	admins, err := testQueries.GetAdminName(context.Background())

	require.NoError(t, err)
	require.NotNil(t, admins)
	require.Equal(t, len(admins), 3)
	require.Equal(t, admins[0].FullName, "Ali Ahmadi")
	require.Equal(t, admins[1].FullName, "Maryam Hosseini")
	require.Equal(t, admins[2].FullName, "Reza Mohammadi")
}

func TestGetUserWithMoreThanTwoTicket(t *testing.T) {
	users, err := testQueries.GetUserWithMoreThanTwoTicket(context.Background())

	require.NoError(t, err)
	require.NotNil(t, users)
	require.Equal(t, len(users), 2)
	for i := 0; i < len(users); i++ {
		require.Greater(t, users[i].TicketCount, int64(0))
	}
}

func TestGetUserWithLessThanTwoTicketVehicle(t *testing.T) {
	users, err := testQueries.GetUserWithLessThanTwoTicketVehicle(context.Background())

	require.NoError(t, err)
	require.NotNil(t, users)
	require.Equal(t, len(users), 4)
}

func TestGetUserWithAllVehicleRejected(t *testing.T) {
	users, err := testQueries.GetUserWithAllVehicleRejected(context.Background())

	require.NoError(t, err)
	require.NotNil(t, users)
	require.Equal(t, len(users), 0)
	for i := 0; i < len(users); i++ {
		require.True(t, users[i].Email != "" || users[i].PhoneNumber != "")
	}
}

func TestGetTicketInfoForToday(t *testing.T) {
	tickets, err := testQueries.GetTicketInfoForToday(context.Background())

	require.NoError(t, err)
	require.NotNil(t, tickets)
	require.Equal(t, len(tickets), 4)
}

func TestGetSecondPopularTicketInfo(t *testing.T) {
	ticket, err := testQueries.GetSecondPopularTicketInfo(context.Background())

	require.NoError(t, err)
	require.NotNil(t, ticket)

}

func TestGetAdminWithMostReject(t *testing.T) {
	admin, err := testQueries.GetAdminWithMostReject(context.Background())

	require.NoError(t, err)
	require.NotNil(t,admin)
	require.Equal(t, admin.AdminID, sql.NullInt64{Int64: 1, Valid: true})
	require.Equal(t, admin.FullName, "Ali Ahmadi")
}

func TestChangeUserWithMostCancle(t *testing.T) {
	err := testQueries.ChangeUserWithMostCancle(context.Background())

	require.NoError(t, err)
}

// func TestDeleteRedingtonTicket(t *testing.T) {
// 	err := testQueries.DeleteRedingtonTicket(context.Background())

// 	require.NoError(t, err)
// }

// func TestDeleteAllCancledTicket(t *testing.T) {
// 	err := testQueries.DeleteAllCancledTicket(context.Background())

// 	require.NoError(t, err)
// }

func TestUpadateMahanAirCost(t *testing.T) {
	err := testQueries.UpadateMahanAirTicketCost(context.Background())
	require.NoError(t, err)
	err = testQueries.UpdateMahanAirPaymentCost(context.Background())
	require.NoError(t, err)
}

func TestGetReport(t *testing.T) {
	reports, err := testQueries.GetReport(context.Background())

	require.NoError(t, err)
	require.NotNil(t, reports)
	require.Equal(t, len(reports), 3)

	for i := 1; i < len(reports); i++ {
		require.Equal(t, reports[i].TicketID, reports[i - 1].TicketID)
	}
}