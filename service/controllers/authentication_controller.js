const Email = require("../models/email");
const bcrypt = require("bcrypt");
const Password = require("../models/password");

require("dotenv").config({});
exports.check = (req, res, next) => {
  console.log(process.env);
  res.json({
    hello: "sdjkflj",
  });
};

exports.formData = (req, res, next) => {
  const email = req.body.email;
  const password = req.body.password;

  bcrypt.hash(password, 10, function (err, hash) {
    const HashedPassword = hash;
    Email.create({ email: email })
      .then((email) => {
        email.createPassword({ pass: HashedPassword });
      })
      .then(() => {
        res.json({ token: 1234362486 });
      });
  });
};

exports.loginData = (req, res, next) => {
  const email = req.body.email;
  const password = req.body.password;

  Email.findOne({ where: { email: email } }).then((foundEmail) => {
    if (foundEmail != null) {
      Password.findOne({ where: { emailId: foundEmail.id } }).then(
        async (foundPassword) => {
          const passwordCheck = await bcrypt.compare(
            password,
            foundPassword.pass
          );
          console.log(passwordCheck);
          if (passwordCheck == false) {
            return res.json({ tokken: null });
          }
          return res.json({ tokken: "12344545" });
        }
      );
    } else {
      console.log("email doesn't exist");
      return res.json({ token: null });
    }
  });
};
