const {body} = require('express-validator');
const EMAIL_TYPE = "^[a-zA-Z0-9.!#$%&''*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$";
const PHONE_TYPE = "^[0-9]{10,11}$";

let validateRegisterPhone = () => {
    return [
            body('phone').matches(PHONE_TYPE)
        
    ]; 
};

let validateLogin = () => {
    return [
            body('uname').matches(PHONE_TYPE) || body('uname').matches(EMAIL_TYPE) 
        
    ]; 
};

let validator = {
    validateRegisterPhone: validateRegisterPhone,
    validateLogin: validateLogin
  };

module.exports = {
    validator
};