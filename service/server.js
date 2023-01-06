const express = require("express");
const sequelize = require("./util/database");
const app = express();
const getAuthenticationData = require("../service/routes/authenticate_route");
const Email = require("./models/email");
const Password = require("./models/password");
app.use(express.json());

Password.belongsTo(Email, { constraints: true, onDelete: "CASCADE" });
Email.hasOne(Password, { constraints: true, onDelete: "CASCADE" });
app.use(getAuthenticationData);

sequelize
  // .sync({ force: true })
  .sync()
  .then(() => {
    return Email.findByPk(1);
  })
  .then((email) => {
    if (!email) {
      return Email.bulkCreate([
        { email: "teacher@gmail.com" },
        { email: "student@gmail.com" },
        { email: "staff@gmail.com" },
      ]);
    }
  })
  .then((emails) => {
    if (emails) {
      emails.forEach((email) => {
        email.createPassword({});
      });
    }
  })
  .catch((err) => {
    console.log(err);
  });

app.listen(3000);
