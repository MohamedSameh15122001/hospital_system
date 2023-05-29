class DoctorState {}

class DoctorInitial extends DoctorState {}

// Add Diagnosis
class LoadingAddDiagnosis extends DoctorState {}

class SuccessAddDiagnosis extends DoctorState {}

class ErrorAddDiagnosis extends DoctorState {}
// Add Diagnosis

// Get Patient With His Diagnosis
class LoadingGetPatientWithHisDiagnosis extends DoctorState {}

class SuccessGetPatientWithHisDiagnosis extends DoctorState {}

class ErrorGetPatientWithHisDiagnosis extends DoctorState {}
// Get Patient With His Diagnosis

// Update Patient Diagnosis
class LoadingUpdatePatientDiagnosis extends DoctorState {}

class SuccessUpdatePatientDiagnosis extends DoctorState {}

class ErrorUpdatePatientDiagnosis extends DoctorState {}
// Update Patient Diagnosis

// Delete Patient Diagnosis
class LoadingDeletePatientDiagnosis extends DoctorState {}

class SuccessDeletePatientDiagnosis extends DoctorState {}

class ErrorDeletePatientDiagnosis extends DoctorState {}
// Delete Patient Diagnosis
 