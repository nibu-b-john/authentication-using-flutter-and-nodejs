const express = require("express");
const router = express.Router();

const {
  check,
  formData,
  loginData,
} = require("../controllers/authentication_controller");

router.get("/check", check);
router.post("/postFormData", formData);
router.post("/postLoginData", loginData);
module.exports = router;
