class Validation {

  //Done
  static String timeValidation(String value){
    if (value.isEmpty) {
      return "Task time can't be empty";
    } else {
      return null;
    }
  }

  //Done
  static String dateValidation(String value){
    if (value.isEmpty) {
      return "Task Date can't be empty";
    } else {
      return null;
    }
  }

  //Done
  static String titleValidation(String value){
    if (value.isEmpty) {
      return "Task title can't be empty";
    } else {
      return null;
    }
  }

}