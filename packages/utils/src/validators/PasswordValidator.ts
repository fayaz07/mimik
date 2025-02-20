const numberRe = /[0-9]/;
const lowercaseRe = /[a-z]/;
const uppercaseRe = /[A-Z]/;
const specialcaseRe = /[`!@#%$&^*()]+/;

function validatePassword(password: string) {
  const pLength = password.length;
  if (pLength < 8 || pLength > 24) {
    return "password should have a minimum of 8 and maximum of 24 characters";
  }

  if (!numberRe.test(password)) {
    return "password should contain numbers";
  }

  if (!lowercaseRe.test(password)) {
    return "password should contain lowercase letters";
  }

  if (!uppercaseRe.test(password)) {
    return "password should contain uppercase letters";
  }

  if (!specialcaseRe.test(password)) {
    return "password should contain special characters";
  }
  return null;
}

export default validatePassword;
