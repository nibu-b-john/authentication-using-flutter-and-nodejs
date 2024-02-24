const { Sequelize } = require("sequelize");
require("dotenv").config();
const sequelize = new Sequelize(
  "authentication",
  "root",
  "opsen_8901425000427",
  {
    dialect: "mysql",
    host: "localhost",
  }
);
module.exports = sequelize;
