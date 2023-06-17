class PatientState {}

class PatientInitial extends PatientState {}

// change visible Password
class ChangeVisiblePassword extends PatientState {}

// change old visible Password
class ChangeVisibleOldPassword extends PatientState {}

// change bottom nav bar
class ChangeBottomNavBar extends PatientState {}
// change bottom nav bar

// get patient profile
class LoadingGetPatientProfile extends PatientState {}

class SuccessGetPatientProfile extends PatientState {}

class ErrorGetPatientProfile extends PatientState {}
// get patient profile

// get patient appointments
class LoadingGetPatientAppointments extends PatientState {}

class SuccessGetPatientAppointments extends PatientState {}

class ErrorGetPatientAppointments extends PatientState {}
// get patient appointments

// get patient diagnosis
class LoadingGetPatientDiagnosis extends PatientState {}

class SuccessGetPatientDiagnosis extends PatientState {}

class ErrorGetPatientDiagnosis extends PatientState {}
// get patient diagnosis

//=====================================
// patient notifications
//=====================================
// get all patient notifications
class LoadingGetAllPatientNotifications extends PatientState {}

class SuccessGetAllPatientNotifications extends PatientState {}

class ErrorGetAllPatientNotifications extends PatientState {}
// get all patient notifications

// delete specific patient notification
class LoadingDeleteSpecificPatientNotification extends PatientState {}

class SuccessDeleteSpecificPatientNotification extends PatientState {}

class ErrorDeleteSpecificPatientNotification extends PatientState {}
// delete specific patient notification

// delete all patient notifications
class LoadingDeleteAllPatientNotifications extends PatientState {}

class SuccessDeleteAllPatientNotifications extends PatientState {}

class ErrorDeleteAllPatientNotifications extends PatientState {}
// delete all patient notifications
//=====================================
// patient notifications
//=====================================

// Change Patient Password
class LoadingChangePatientPassword extends PatientState {}

class SuccessChangePatientPassword extends PatientState {}

class ErrorChangePatientPassword extends PatientState {}
// Change Patient Password