const { Sequelize } = require("sequelize");
require("dotenv").config();
const sequelize = new Sequelize(
  dotenv.process.database_name,
  dotenv.process.user,
  dotenv.process.password,
  {
    dialect: "mysql",
    host: "localhost",
  }
);
module.exports = sequelize;
