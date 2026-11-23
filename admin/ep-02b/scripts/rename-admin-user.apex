// Renames the user running this script (you) to Owen Hartley, as in episode 1.
// Run it from the ep-01 folder:
//   sf apex run --file scripts/rename-admin-user.apex
User me = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
me.FirstName = 'Owen';
me.LastName = 'Hartley';
update me;
System.debug('Renamed to ' + me.FirstName + ' ' + me.LastName);
