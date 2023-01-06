const { DataTypes } = require("sequelize");
const sequelize = require("../util/database");

const Password = sequelize.define(
  "password",
  {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      allowNull: false,
      autoIncrement: true,
    },
    pass: {
      type: DataTypes.STRING,
      defaultValue: "123456789",
    },
  },
  { timestamps: false }
);
module.exports = Password;
